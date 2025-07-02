DO $$
DECLARE 
    base_date DATE := CURRENT_DATE - INTERVAL '18 months';
BEGIN

-- Clear existing data in safe order
TRUNCATE TABLE lms.Submissions CASCADE;
TRUNCATE TABLE lms.CourseRegistrations CASCADE;
TRUNCATE TABLE lms.Reviews CASCADE;
TRUNCATE TABLE lms.PaymentRecords CASCADE;
TRUNCATE TABLE lms.Modules CASCADE;
TRUNCATE TABLE lms.Assessments CASCADE;
TRUNCATE TABLE lms.Courses CASCADE;
TRUNCATE TABLE lms.Categories CASCADE;
TRUNCATE TABLE lms.Instructors CASCADE;
TRUNCATE TABLE lms.Students CASCADE;

-- Sample Data for Students (500 students)
-- Modified email generation to ensure uniqueness
INSERT INTO lms.Students (studentID, firstName, lastName, email, enrollmentDate, phone)
SELECT 
    'S' || LPAD(g::text, 3, '0'),
    first_names[ceil(random() * array_length(first_names, 1))],
    last_names[ceil(random() * array_length(last_names, 1))],
    lower(
        first_names[ceil(random() * array_length(first_names, 1))] || 
        '.' || 
        last_names[ceil(random() * array_length(last_names, 1))] || 
        g::text ||  -- Added student number to ensure uniqueness
        '@example.com'
    ),
    CURRENT_DATE - (g % 90 || ' days')::interval,
    '123-456-' || LPAD((g % 1000)::text, 3, '0')
FROM generate_series(1, 500) AS g,
LATERAL (
    SELECT ARRAY['Alice', 'Bob', 'Charlie', 'Diana', 'Ethan', 'Fiona', 'George', 'Hannah', 'Ian', 'Julia', 'Kevin', 'Lena', 'Mike', 'Nina', 'Oscar', 'Paula', 'Quinn', 'Rachel', 'Sam', 'Tina'] AS first_names,
           ARRAY['Anderson', 'Brown', 'Clark', 'Davis', 'Evans', 'Foster', 'Garcia', 'Hernandez', 'Ingram', 'Jones', 'King', 'Lee', 'Miller', 'Nelson', 'Owens', 'Parker', 'Quincy', 'Robinson', 'Smith', 'Taylor'] AS last_names
) AS names;

-- Sample Data for Instructors (50 instructors)
INSERT INTO lms.Instructors (instructorID, firstName, lastName, email, department, hireDate)
SELECT 
    'I' || LPAD(g::text, 2, '0'),
    first_names[ceil(random() * array_length(first_names, 1))],
    last_names[ceil(random() * array_length(last_names, 1))],
    lower(
        first_names[ceil(random() * array_length(first_names, 1))] || 
        '.' || 
        last_names[ceil(random() * array_length(last_names, 1))] || 
        g::text ||  -- Added instructor number to ensure uniqueness
        '@university.edu'
    ),
    dept[ceil(random() * array_length(dept, 1))],
    CURRENT_DATE - (g % 720 || ' days')::interval
FROM generate_series(1, 50) AS g,
LATERAL (
    SELECT ARRAY['Alice', 'Bob', 'Charlie', 'Diana', 'Ethan', 'Fiona', 'George', 'Hannah', 'Ian', 'Julia'] AS first_names,
           ARRAY['Anderson', 'Brown', 'Clark', 'Davis', 'Evans', 'Foster', 'Garcia', 'Hernandez'] AS last_names,
           ARRAY['Computer Science', 'Data Science', 'Business'] AS dept
) AS details;

-- Sample Data for Categories
INSERT INTO lms.Categories (categoryID, name)
VALUES
('C1', 'Programming'),
('C2', 'Data Science'),
('C3', 'Business');

-- Sample Data for Courses (20 courses)
INSERT INTO lms.Courses (courseID, title, description, credits, instructorID, categoryID, startDate, endDate)
SELECT 
    'CRS' || LPAD(g::text, 3, '0'),
    course_titles[ceil(random() * array_length(course_titles, 1))],
    'Description for ' || course_titles[ceil(random() * array_length(course_titles, 1))],
    (random() * 2 + 3)::int,
    'I' || LPAD((ceil(random() * 50))::text, 2, '0'),
    'C' || (ceil(random() * 3))::text,
    CURRENT_DATE - (g * 30 || ' days')::interval,
    CURRENT_DATE - (g * 30 || ' days')::interval + interval '3 months'
FROM generate_series(1, 20) AS g,
LATERAL (
    SELECT ARRAY[
        'Introduction to Programming',
        'Advanced Data Structures',
        'Data Science Fundamentals',
        'Business Analytics',
        'Machine Learning Basics',
        'Web Development Fundamentals',
        'Financial Accounting',
        'Software Engineering Principles',
        'Database Design',
        'User Experience Design'
    ] AS course_titles
) AS titles;

-- Sample Data for Modules (3-5 modules per course)
INSERT INTO lms.Modules (moduleID, courseID, title, moduleOrder, content)
SELECT 
    'M' || LPAD((g * 10 + m)::text, 3, '0'),
    'CRS' || LPAD(g::text, 3, '0'),
    module_titles[ceil(random() * array_length(module_titles, 1))],
    m,
    'Content for ' || module_titles[ceil(random() * array_length(module_titles, 1))] 
FROM (
    SELECT g, m FROM generate_series(1, 20) AS g
    CROSS JOIN generate_series(1, (random() * 3 + 3)::int) AS m
) AS data,
LATERAL (
    SELECT ARRAY[
        'Introduction to Programming',
        'Control Flow and Functions',
        'Data Structures',
        'Object-Oriented Programming',
        'Web Development Basics',
        'Database Design Patterns',
        'User Experience Principles',
        'Data Analysis Techniques',
        'Machine Learning Models',
        'Software Testing and Debugging'
    ] AS module_titles
) AS mods;

-- Sample Data for Assessments (2-4 assessments per course)
INSERT INTO lms.Assessments (assessmentID, courseID, type, title, maxScore, duedate)
SELECT 
    'A' || LPAD((row_number() OVER ())::text, 3, '0'),
    'CRS' || LPAD(course_num::text, 3, '0'),
    COALESCE(
        CASE (random() * 3)::int
            WHEN 0 THEN 'Assignment'
            WHEN 1 THEN 'Exam'
            WHEN 2 THEN 'Project'
        END,
        'Assignment' -- Default value in case of null
    ),
    assessment_titles[ceil(random() * array_length(assessment_titles, 1))],
    (random() * 50 + 100)::int,
    (SELECT startDate + (assess_num * 7 || ' days')::interval 
     FROM lms.Courses WHERE courseID = 'CRS' || LPAD(course_num::text, 3, '0'))
FROM (
    SELECT
        g.g AS course_num,
        row_number() OVER (PARTITION BY g.g ORDER BY s.g) AS assess_num
    FROM generate_series(1, 20) AS g
    CROSS JOIN generate_series(1, (random() * 2 + 2)::int) AS s(g)
) AS data,
LATERAL (
    SELECT ARRAY[
        'Intro Assignment',
        'Midterm Exam',
        'Data Analysis Project',
        'Final Research Paper',
        'UI Design Challenge',
        'Database Optimization Task',
        'Machine Learning Model Report',
        'Web Development Assignment',
        'Business Case Study'
    ] AS assessment_titles
) AS ass;

-- Sample Data for PaymentRecords
INSERT INTO lms.PaymentRecords (paymentID, amount, paymentDate, paymentMethod, transactionID, status)
SELECT 
    'P' || LPAD(g::text, 3, '0'),
    (random() * 100 + 100)::numeric(10,2),
    CURRENT_DATE - (random() * 30 || ' days')::interval,
    CASE FLOOR(random() * 3)  -- Ensure we get 0, 1, or 2
        WHEN 0 THEN 'Credit Card'
        WHEN 1 THEN 'PayPal'
        WHEN 2 THEN 'Bank Transfer'
    END,
    'T' || LPAD((g * 1000)::text, 6, '0'),
    'Completed'
FROM generate_series(1, 50) AS g;

-- Sample Data for CourseRegistrations (unique range #1)
INSERT INTO lms.CourseRegistrations (registrationID, studentID, courseID, startDate, endDate, status, paymentID, type, upgradedate)
SELECT 
    'R' || LPAD(g::text, 3, '0'),
    'S' || LPAD((ceil(random() * 500))::text, 3, '0'),
    c.courseID,
    CURRENT_DATE - (g % 90 || ' days')::interval,
    CURRENT_DATE - (g % 90 || ' days')::interval + INTERVAL '3 months',
    'Active',
    NULL,
    CASE WHEN g <= 20 THEN 'enrollment' ELSE 'subscription' END,
    NULL
FROM generate_series(1, 40) AS g,
LATERAL (
    SELECT 'CRS' || LPAD((ceil(random() * 20))::text, 3, '0') AS courseID
) AS c;

-- Additional CourseRegistrations with proper endDate (unique range #2)
INSERT INTO lms.CourseRegistrations (registrationID, studentID, courseID, startDate, endDate, status, paymentID, type, upgradedate)
SELECT 
    'R' || LPAD((g + 100)::text, 3, '0'), -- Offset to avoid duplicates
    'S' || LPAD((ceil(random() * 500))::text, 3, '0'),
    c.courseID,
    CURRENT_DATE - (g % 90 || ' days')::interval,
    CURRENT_DATE - (g % 90 || ' days')::interval + INTERVAL '3 months',
    'Active',
    'P' || LPAD((ceil(random() * 50))::text, 3, '0'), -- Select from existing payments
    CASE WHEN g <= 20 THEN 'enrollment' ELSE 'subscription' END,
    NULL
FROM generate_series(1, 40) AS g,
LATERAL (
    SELECT 'CRS' || LPAD((ceil(random() * 20))::text, 3, '0') AS courseID
) AS c;

-- Students who never submitted any assessments (potential dropouts)
INSERT INTO lms.CourseRegistrations (registrationID, studentID, courseID, startDate, endDate, status, paymentID, type, upgradedate)
SELECT 
    'R' || LPAD((row_number() OVER () + 500)::text, 3, '0'),
    st.studentID,
    c.courseID,
    CURRENT_DATE - (g * 100 || ' days')::interval,
    CURRENT_DATE - (g * 50 || ' days')::interval,
    'Inactive',
    NULL,
    'enrollment',
    NULL
FROM (
    SELECT studentID
    FROM lms.Students
    ORDER BY random()
    LIMIT 10
) st
CROSS JOIN (
    SELECT courseID
    FROM lms.Courses
    ORDER BY random()
    LIMIT 1
) c
CROSS JOIN generate_series(1, 2) AS g;

-- Students who upgraded from enrollment to subscription
INSERT INTO lms.CourseRegistrations (registrationID, studentID, courseID, startDate, endDate, status, paymentID, type, upgradedate)
SELECT 
    'R' || LPAD((row_number() OVER () + 600)::text, 3, '0'),
    st.studentID,
    c.courseID,
    CURRENT_DATE - (random() * 30 + 30)::int * INTERVAL '1 day',
    CURRENT_DATE - (random() * 30 + 30)::int * INTERVAL '1 day' + INTERVAL '3 months',
    'Active',
    'P' || LPAD((ceil(random() * 50))::text, 3, '0'), -- Select from existing payments
    'subscription',
    CURRENT_DATE - (random() * 20 + 10)::int * INTERVAL '1 day'
FROM (
    SELECT studentID
    FROM lms.Students
    ORDER BY random()
    LIMIT 20
) st
CROSS JOIN (
    SELECT courseID
    FROM lms.Courses
    ORDER BY random()
    LIMIT 1
) c;

-- Corresponding free enrollments before upgrade
INSERT INTO lms.CourseRegistrations (registrationID, studentID, courseID, startDate, endDate, status, paymentID, type, upgradedate)
SELECT 
    'R' || LPAD((row_number() OVER () + 800)::text, 3, '0'),
    studentID,
    courseID,
    startDate - (random() * 10 + 20)::int * INTERVAL '1 day',
    upgradedate, -- Use upgradedate as endDate
    'Inactive',
    'P' || LPAD((random() * 50 + 1)::int::text, 3, '0'),
    'enrollment',
    NULL
FROM (
    SELECT studentID, courseID, startDate, upgradedate
    FROM lms.CourseRegistrations
    WHERE type = 'subscription'
      AND upgradedate IS NOT NULL -- Ensuring upgradedate exists
    LIMIT 20
) AS sub;

-- Update CourseRegistrations with payment IDs
-- Only assign paymentIDs that exist in PaymentRecords
UPDATE lms.CourseRegistrations 
SET paymentID = (
    SELECT paymentID 
    FROM lms.PaymentRecords 
    ORDER BY random() 
    LIMIT 1
)
WHERE type != 'trial' AND registrationID IN (
    SELECT registrationID
    FROM lms.CourseRegistrations
    WHERE type != 'trial'
    ORDER BY random()
    LIMIT (SELECT COUNT(*) FROM lms.CourseRegistrations) * 0.7
);

-- Sample Data for Submissions (adjusted for partial completions)
INSERT INTO lms.Submissions (submissionID, studentID, assessmentID, submissionDate, score, fileURL, feedback)
SELECT 
    'SUB' || LPAD((row_number() OVER ())::text, 5, '0'),
    'S' || LPAD((ceil(random() * 500))::text, 3, '0'),
    a.assessmentID,
    a.duedate - (random() * 7 || ' days')::interval,
    (random() * 40 + 60)::int,
    'https://example.com/submission/' || (row_number() OVER ()) || '.pdf',
    CASE (random() * 3)::int
        WHEN 0 THEN 'Good job!'
        WHEN 1 THEN 'Solid work.'
        WHEN 2 THEN 'Needs improvement.'
        WHEN 3 THEN 'Excellent analysis.'
    END
FROM lms.Assessments a
CROSS JOIN generate_series(1, (random() * 6 + 4)::int) AS s;

-- Students with ~80% completion
INSERT INTO lms.Submissions (submissionID, studentID, assessmentID, submissionDate, score, fileURL, feedback)
SELECT 
    'SUB' || LPAD((row_number() OVER () + 2000)::text, 5, '0'),
    st.studentID,
    a.assessmentID,
    a.duedate - (random() * 5 || ' days')::interval,
    (random() * 20 + 70)::int,
    'https://example.com/submission/' || (row_number() OVER ()) || '.pdf',
    'Solid work.'
FROM (
    SELECT studentID
    FROM lms.Students
    ORDER BY random()
    LIMIT 5
) st
CROSS JOIN lms.Assessments a
WHERE random() > 0.2; -- Skip 20% of assessments

-- Students with ~90% completion
INSERT INTO lms.Submissions (submissionID, studentID, assessmentID, submissionDate, score, fileURL, feedback)
SELECT 
    'SUB' || LPAD((row_number() OVER () + 3000)::text, 5, '0'),
    st.studentID,
    a.assessmentID,
    a.duedate - (random() * 5 || ' days')::interval,
    (random() * 25 + 70)::int,
    'https://example.com/submission/' || (row_number() OVER ()) || '.pdf',
    'Good job!'
FROM (
    SELECT studentID
    FROM lms.Students
    ORDER BY random()
    LIMIT 5
) st
CROSS JOIN lms.Assessments a
WHERE random() > 0.1; -- Skip 10% of assessments

-- Late submissions in the last month (for query #15)
INSERT INTO lms.Submissions (submissionID, studentID, assessmentID, submissionDate, score, fileURL, feedback)
SELECT 
    'SUB' || LPAD((row_number() OVER () + 4000)::text, 5, '0'),
    st.studentID,
    a.assessmentID,
    a.duedate + (random() * 7 || ' days')::interval, -- After deadline
    (random() * 40 + 60)::int,
    'https://example.com/submission/' || (row_number() OVER ()) || '.pdf',
    CASE (random() * 3)::int
        WHEN 0 THEN 'Late but good work!'
        WHEN 1 THEN 'Submitted after deadline.'
        WHEN 2 THEN 'Needs improvement and was late.'
        WHEN 3 THEN 'Excellent but late analysis.'
    END
FROM (
    SELECT studentID
    FROM lms.Students
    ORDER BY random()
    LIMIT 15
) st
CROSS JOIN (
    SELECT assessmentID, duedate
    FROM lms.Assessments
    WHERE duedate >= CURRENT_DATE - INTERVAL '2 months'
    ORDER BY random()
    LIMIT 10
) a;

-- Sample Data for Reviews
INSERT INTO lms.Reviews (reviewID, studentID, courseID, rating, comment, reviewDate)
SELECT 
    'RV' || LPAD(g::text, 3, '0'),
    'S' || LPAD((ceil(random() * 500))::text, 3, '0'),
    'CRS' || LPAD((ceil(random() * 20))::text, 3, '0'),
    (random() * 4 + 1)::int,
    CASE (random() * 5)::int
        WHEN 0 THEN 'Great course!'
        WHEN 1 THEN 'Very informative and well-structured.'
        WHEN 2 THEN 'Good content but could use more examples.'
        WHEN 3 THEN 'Challenging but rewarding.'
        WHEN 4 THEN 'Would recommend to others.'
        WHEN 5 THEN 'Needs more hands-on exercises.'
    END,
    CURRENT_DATE - (random() * 90 || ' days')::interval
FROM generate_series(1, 100) AS g;

-- Validation
RAISE NOTICE 'Data generation completed successfully';
RAISE NOTICE 'Students: %', (SELECT COUNT(*) FROM lms.Students);
RAISE NOTICE 'Instructors: %', (SELECT COUNT(*) FROM lms.Instructors);
RAISE NOTICE 'Courses: %', (SELECT COUNT(*) FROM lms.Courses);
RAISE NOTICE 'Assessments: %', (SELECT COUNT(*) FROM lms.Assessments);
RAISE NOTICE 'Submissions: %', (SELECT COUNT(*) FROM lms.Submissions);
RAISE NOTICE 'Reviews: %', (SELECT COUNT(*) FROM lms.Reviews);
RAISE NOTICE 'Registrations: %', (SELECT COUNT(*) FROM lms.CourseRegistrations);
RAISE NOTICE 'Payments: %', (SELECT COUNT(*) FROM lms.PaymentRecords);

END $$;