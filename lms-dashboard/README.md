# LMS Dashboard

The LMS Dashboard is a web-based analytics dashboard for a Learning Management System (LMS). It provides visualizations and insights into key metrics related to courses, students, instructors, and revenue.

## Features

- **Most Enrolled Courses**: Displays the courses with the highest number of enrolled students
- **Top Instructors**: Shows instructors with the most student enrollments across their courses
- **Enrollments by Category**: Visualizes student distribution across course categories using bar charts
- **Revenue Distribution**: Presents revenue sources through pie charts
- **Top Revenue Students**: Identifies students contributing the highest revenue in the last year

## Deployment Instructions

### Prerequisites

1. Python 3.x installed
2. PostgreSQL database with LMS schema and data
3. Required Python packages: Flask, psycopg2, and dependencies listed in requirements.txt
4. Database connection credentials

### Steps to Deploy

1. Clone the repository:
```
git clone https://github.com/lms/lms.git
```

2. Navigate to the project directory:
```
cd lms-dashboard
```

3. Install required packages:
```
pip install -r requirements.txt
```

4. Set up database connection environment variables:
```bash
export DB_USER=your_db_username
export DB_PASSWORD=your_db_password
export DB_HOST=localhost # or your database server
export DB_PORT=5432 # default PostgreSQL port
```

5. Start the application:
```
python app.py
```

6. Open your browser and navigate to `http://localhost:5000`

## API Endpoints

- `/api/queries/most_enrolled_courses` - Data for most enrolled courses
- `/api/queries/top_instructors` - Data for top instructors
- `/api/queries/category_enrollments` - Data for enrollments by category
- `/api/queries/revenue_by_type` - Data for revenue distribution
- `/api/queries/top_revenue_students` - Data for students contributing highest revenue

## Technologies Used

- Python with Flask framework
- PostgreSQL database
- DataTables.js for interactive tables
- Chart.js for data visualizations
- Bootstrap for responsive UI design
- jQuery for DOM manipulation

## Project Structure

- `app.py`: Main application file with Flask routes
- `templates/index.html`: Main HTML template with dashboard UI
- `requirements.txt`: List of Python package dependencies
- Various SQL files in `final/` directory for database setup