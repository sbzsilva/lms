import os
import logging
from flask import Flask, jsonify, render_template
import psycopg2
from psycopg2 import pool
import traceback

# Configuration for database connection
DB_CONFIG = {
    'dbname': os.getenv('DB_NAME', 'lms'),
    'user': os.getenv('DB_USER', 'ssilva'),
    'password': os.getenv('DB_PASSWORD', 'Pa55w.rd'),
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': os.getenv('DB_PORT', '5432')
}

# Create the application
app = Flask(__name__)
app.config['JSON_SORT_KEYS'] = False  # Maintain JSON key order

# Create connection pool
connection_pool = None

# Get a connection from the pool
def get_db_connection():
    global connection_pool
    try:
        if connection_pool is None:
            create_connection_pool()
            
        connection = connection_pool.getconn()
        if connection is None:
            raise Exception("Failed to get database connection from pool")
            
        print("Database connection successful")
        return connection
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Error getting database connection: {error}")
        return None

# Release a connection back to the pool
def release_db_connection(connection):
    global connection_pool
    if connection_pool is not None and connection is not None:
        try:
            connection_pool.putconn(connection)
            print("Database connection released to pool")
        except (Exception, psycopg2.DatabaseError) as error:
            print(f"Error releasing connection: {error}")
            # If there's an error releasing the connection, close it
            try:
                if connection:
                    connection.close()
            except:
                pass

def create_connection_pool():
    global connection_pool
    try:
        connection_pool = psycopg2.pool.SimpleConnectionPool(
            minconn=1,
            maxconn=5,
            **DB_CONFIG
        )
        print("Connection pool created successfully")
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Failed to create connection pool: {error}")
        raise

# Initialize app and connection pool
def init_app(app):
    @app.before_request
    def before_request():
        if not hasattr(app, 'db_pool_initialized'):
            try:
                create_connection_pool()
                app.db_pool_initialized = True
                print("Database connection pool initialized")
            except Exception as e:
                app.logger.critical(f"Failed to initialize database connection pool: {e}")
                raise

# SQL queries
QUERIES = {
    "most_enrolled_courses": "SELECT c.courseid, c.title as title, COUNT(cr.studentid) AS student_count FROM lms.courseregistrations cr JOIN lms.courses c ON cr.courseid = c.courseid GROUP BY c.courseid, c.title ORDER BY student_count DESC LIMIT 5",
    "top_revenue_students": "SELECT s.studentid, s.firstname, s.lastname, SUM(p.amount) AS total_revenue FROM lms.paymentrecords p JOIN lms.courseregistrations cr ON p.paymentid = cr.paymentid JOIN lms.students s ON cr.studentid = s.studentid WHERE p.paymentdate >= CURRENT_DATE - INTERVAL '1 year' GROUP BY s.studentid, s.firstname, s.lastname ORDER BY total_revenue DESC LIMIT 5",
    "top_instructors": "SELECT i.instructorid, i.firstname, i.lastname, COUNT(cr.registrationid) AS student_count FROM lms.instructors i JOIN lms.courses c ON i.instructorid = c.instructorid JOIN lms.courseregistrations cr ON c.courseid = cr.courseid GROUP BY i.instructorid, i.firstname, i.lastname ORDER BY student_count DESC LIMIT 5",
    "category_enrollments": "SELECT ct.name as categoryname, COUNT(cr.registrationid) AS student_count FROM lms.categories ct JOIN lms.courses c ON ct.categoryid = c.categoryid JOIN lms.courseregistrations cr ON c.courseid = cr.courseid GROUP BY ct.name ORDER BY student_count DESC",
    "revenue_by_type": "SELECT payment_type, total_amount, formatted_revenue FROM lms.revenuebytype",
    "student_revenue_last_year": "SELECT s.studentid, s.firstname, s.lastname, SUM(p.amount) AS totalrevenue FROM lms.paymentrecords p JOIN lms.courseregistrations cr ON p.paymentid = cr.paymentid JOIN lms.students s ON cr.studentid = s.studentid WHERE p.paymentdate >= CURRENT_DATE - INTERVAL '1 year' GROUP BY s.studentid, s.firstname, s.lastname ORDER BY totalrevenue DESC LIMIT 5"
}

# Configure logging
if not app.debug:
    app.logger.setLevel(logging.INFO)
    handler = logging.StreamHandler()
    handler.setLevel(logging.INFO)
    app.logger.addHandler(handler)

# Initialize app
init_app(app)

@app.route('/')
def index():
    try:
        return render_template('index.html')
    except Exception as e:
        app.logger.error(f"Error rendering template: {e}")
        return "Error loading dashboard", 500

@app.route('/api/queries/<query_name>', methods=['GET'])
def execute_query(query_name):
    if query_name not in QUERIES:
        app.logger.info(f"Query not found: {query_name}")
        return jsonify({"error": "Query not found"}), 404

    conn = None
    try:
        conn = get_db_connection()
        if conn is None:
            app.logger.error("Database connection failed")
            return jsonify({"error": "Database connection failed"}), 500
            
        with conn.cursor() as cur:
            app.logger.debug(f"Executing query: {QUERIES[query_name]}")
            cur.execute(QUERIES[query_name])
            columns = [desc[0] for desc in cur.description]
            results = [dict(zip(columns, row)) for row in cur.fetchall()]
            
        app.logger.info(f"Executed query {query_name} successfully")
        return jsonify(results)
        
    except psycopg2.Error as e:
        app.logger.error(f"Database error in query '{query_name}': {e.pgerror}")
        app.logger.error(f"SQL: {QUERIES[query_name]}")
        return jsonify({
            "error": "Database operation failed",
            "details": str(e.pgerror),
            "query": query_name
        }), 500
    except Exception as e:
        app.logger.error(f"Unexpected error: {str(e)}", exc_info=True)
        return jsonify({"error": "Internal server error"}), 500
    finally:
        if conn is not None:
            release_db_connection(conn)

@app.route('/api/queries/top_revenue_students')
def top_revenue_students():
    try:
        conn = get_db_connection()
        if conn is None:
            return jsonify({'error': 'Database connection failed'}), 500
            
        with conn.cursor() as cur:
            # Check if the view exists more robustly
            cur.execute("""
                SELECT EXISTS (
                    SELECT 1 
                    FROM pg_matviews WHERE matviewname = 'studentrevenuelastyear' AND schemaname = 'lms'
                ) OR EXISTS (
                    SELECT 1 
                    FROM pg_views WHERE viewname = 'studentrevenuelastyear' AND schemaname = 'lms'
                )
            """)
            view_exists = cur.fetchone()[0]
            
            if not view_exists:
                app.logger.error("StudentRevenueLastYear view does not exist")
                return jsonify({'error': 'Revenue view does not exist'}), 500
            
            # Try to query the view
            cur.execute("""
                SELECT s.studentid,
                       s.firstname,
                       s.lastname,
                       COALESCE(SUM(p.amount), 0) AS totalrevenue,
                       TO_CHAR(COALESCE(SUM(p.amount), 0), 'L999G999G999D99') AS formatted_revenue
                FROM lms.students s
                LEFT JOIN lms.courseregistrations cr ON s.studentid = cr.studentid
                LEFT JOIN lms.paymentrecords p ON cr.paymentid = p.paymentid AND p.paymentdate >= CURRENT_DATE - INTERVAL '1 year'
                GROUP BY s.studentid, s.firstname, s.lastname
                ORDER BY totalrevenue DESC
                LIMIT 10
            """)
            results = cur.fetchall()
            
            # Log detailed information
            app.logger.debug(f"View exists: {view_exists}")
            app.logger.debug(f"Query executed successfully")
            app.logger.debug(f"Number of results: {len(results) if results else 0}")
            
            # Convert results to list of dictionaries
            columns = [desc[0] for desc in cur.description]
            result_list = [dict(zip(columns, row)) for row in results]
            
            # Add default values for missing fields
            for item in result_list:
                if not item.get('totalrevenue'):
                    item['totalrevenue'] = 0
                if not item.get('formatted_revenue'):
                    item['formatted_revenue'] = "$0.00"
            
            return jsonify(result_list)
    except Exception as e:
        app.logger.error(f"Error in top_revenue_students endpoint: {e}")
        app.logger.error(f"Traceback: {traceback.format_exc()}")
        return jsonify({'error': 'Internal server error', 'details': str(e)}), 500
    finally:
        if conn is not None:
            release_db_connection(conn)

# Add schema validation on startup
@app.before_request
def check_schema():
    if not hasattr(app, 'schema_checked'):
        try:
            conn = get_db_connection()
            if conn is None:
                app.logger.error("Database connection failed during schema check")
                return
                
            with conn.cursor() as cur:
                # Check for required tables
                cur.execute("""
                    SELECT EXISTS (
                        SELECT 1 
                        FROM pg_tables
                        WHERE tablename IN ('courseregistrations', 'courses', 'students', 'paymentrecords', 'instructors')
                        AND schemaname = 'lms'
                    )
                """)
                tables_exist = cur.fetchone()[0]
                
                if not tables_exist:
                    app.logger.warning("Some required tables are missing from the lms schema")
                    
            app.schema_checked = True
        finally:
            release_db_connection(conn)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
