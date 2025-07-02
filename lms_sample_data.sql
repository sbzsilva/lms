-- -----------------------------------------------------
-- Clear existing data in safe order
-- -----------------------------------------------------
TRUNCATE TABLE lms.Submissions CASCADE;
TRUNCATE TABLE lms.CourseRegistrations CASCADE;
TRUNCATE TABLE lms.Reviews CASCADE;
TRUNCATE TABLE lms.PaymentRecords CASCADE;

-- Parent tables
TRUNCATE TABLE lms.Modules CASCADE;
TRUNCATE TABLE lms.Assessments CASCADE;
TRUNCATE TABLE lms.Courses CASCADE;
TRUNCATE TABLE lms.Categories CASCADE;
TRUNCATE TABLE lms.Instructors CASCADE;
TRUNCATE TABLE lms.Students CASCADE;

-- Sample Data for Students (Expanded to 60+)
-- (Dates shifted to align with current date: June 2025)
INSERT INTO lms.Students (studentID, firstName, lastName, email, enrollmentDate, phone)
VALUES
('S1', 'John', 'Doe', 'john.doe@example.com', '2024-12-01', '123-456-7890'),
('S2', 'Jane', 'Smith', 'jane.smith@example.com', '2024-12-05', '234-567-8901'),
('S3', 'Alice', 'Johnson', 'alice.johnson@example.com', '2025-01-01', '345-678-9012'),
('S4', 'Bob', 'Brown', 'bob.brown@example.com', '2025-01-10', '456-789-0123'),
('S5', 'Charlie', 'Davis', 'charlie.davis@example.com', '2025-02-01', '567-890-1234'),
('S6', 'Diana', 'Evans', 'diana.evans@example.com', '2025-02-15', '678-901-2345'),
('S7', 'Ethan', 'Clark', 'ethan.clark@example.com', '2025-03-01', '789-012-3456'),
('S8', 'Fiona', 'Harris', 'fiona.harris@example.com', '2025-03-10', '890-123-4567'),
('S9', 'George', 'Walker', 'george.walker@example.com', '2024-12-05', '901-234-5678'),
('S10', 'Hannah', 'King', 'hannah.king@example.com', '2024-12-10', '012-345-6789'),
('S11', 'Ian', 'Wright', 'ian.wright@example.com', '2024-12-12', '123-456-7891'),
('S12', 'Julia', 'Lopez', 'julia.lopez@example.com', '2024-12-15', '234-567-8902'),
('S13', 'Kevin', 'Hill', 'kevin.hill@example.com', '2024-12-18', '345-678-9013'),
('S14', 'Laura', 'Scott', 'laura.scott@example.com', '2024-12-20', '456-789-0124'),
('S15', 'Mike', 'Green', 'mike.green@example.com', '2024-12-22', '567-890-1235'),
('S16', 'Nina', 'Adams', 'nina.adams@example.com', '2024-12-25', '678-901-2346'),
('S17', 'Oscar', 'Baker', 'oscar.baker@example.com', '2024-12-28', '789-012-3457'),
('S18', 'Paula', 'Mitchell', 'paula.mitchell@example.com', '2025-01-02', '890-123-4568'),
('S19', 'Quinn', 'Parker', 'quinn.parker@example.com', '2025-01-05', '901-234-5679'),
('S20', 'Rita', 'Turner', 'rita.turner@example.com', '2025-01-08', '012-345-6780'),
('S21', 'Sam', 'Phillips', 'sam.phillips@example.com', '2025-01-12', '123-456-7892'),
('S22', 'Tina', 'Campbell', 'tina.campbell@example.com', '2025-01-15', '234-567-8903'),
('S23', 'Uma', 'Perez', 'uma.perez@example.com', '2025-01-18', '345-678-9014'),
('S24', 'Victor', 'Roberts', 'victor.roberts@example.com', '2025-01-20', '456-789-0125'),
('S25', 'Wendy', 'Murphy', 'wendy.murphy@example.com', '2025-01-22', '567-890-1236'),
('S26', 'Xander', 'Cook', 'xander.cook@example.com', '2025-01-25', '678-901-2347'),
('S27', 'Yara', 'Morgan', 'yara.morgan@example.com', '2025-01-28', '789-012-3458'),
('S28', 'Zack', 'Bell', 'zack.bell@example.com', '2025-02-02', '890-123-4569'),
('S29', 'Amber', 'Bailey', 'amber.bailey@example.com', '2025-02-05', '901-234-5670'),
('S30', 'Brandon', 'Rivera', 'brandon.rivera@example.com', '2025-02-08', '012-345-6781'),
('S31', 'Caleb', 'Cooper', 'caleb.cooper@example.com', '2025-02-10', '123-456-7893'),
('S32', 'Daisy', 'Reed', 'daisy.reed@example.com', '2025-02-12', '234-567-8904'),
('S33', 'Elliot', 'Howard', 'elliot.howard@example.com', '2025-02-14', '345-678-9015'),
('S34', 'Faith', 'Ward', 'faith.ward@example.com', '2025-02-16', '456-789-0126'),
('S35', 'Gabriel', 'Torres', 'gabriel.torres@example.com', '2025-02-18', '567-890-1237'),
('S36', 'Holly', 'Peterson', 'holly.peterson@example.com', '2025-02-20', '678-901-2348'),
('S37', 'Ian', 'Jenkins', 'ian.jenkins@example.com', '2025-02-22', '789-012-3459'),
('S38', 'Jessica', 'Graham', 'jessica.graham@example.com', '2025-02-25', '890-123-4560'),
('S39', 'Karl', 'Sullivan', 'karl.sullivan@example.com', '2025-02-28', '901-234-5671'),
('S40', 'Lena', 'Price', 'lena.price@example.com', '2025-03-02', '012-345-6782'),
('S41', 'Marcus', 'Kelly', 'marcus.kelly@example.com', '2025-03-05', '123-456-7894'),
('S42', 'Natalie', 'Sanders', 'natalie.sanders@example.com', '2025-03-08', '234-567-8905'),
('S43', 'Oliver', 'Bennett', 'oliver.bennett@example.com', '2025-03-12', '345-678-9016'),
('S44', 'Patricia', 'Wood', 'patricia.wood@example.com', '2025-03-15', '456-789-0127'),
('S45', 'Quincy', 'Barnes', 'quincy.barnes@example.com', '2025-03-18', '567-890-1238'),
('S46', 'Rachel', 'Ross', 'rachel.ross@example.com', '2025-03-20', '678-901-2349'),
('S47', 'Simon', 'Coleman', 'simon.coleman@example.com', '2025-03-22', '789-012-3460'),
('S48', 'Tanya', 'Jenkins', 'tanya.jenkins@example.com', '2025-03-25', '890-123-4570'),
('S49', 'Umar', 'Myers', 'umar.myers@example.com', '2025-03-28', '901-234-5680'),
('S50', 'Vanessa', 'Long', 'vanessa.long@example.com', '2025-04-02', '012-345-6790'),
('S51', 'Warren', 'Foster', 'warren.foster@example.com', '2025-04-05', '123-456-7901'),
('S52', 'Xenia', 'Ellis', 'xenia.ellis@example.com', '2025-04-08', '234-567-8012'),
('S53', 'Yvette', 'Hansen', 'yvette.hansen@example.com', '2025-04-10', '345-678-9123'),
('S54', 'Zachary', 'Black', 'zachary.black@example.com', '2025-04-12', '456-789-0234'),
('S55', 'Anna', 'White', 'anna.white@example.com', '2025-04-15', '567-890-1345'),
('S56', 'Brian', 'Hughes', 'brian.hughes@example.com', '2025-04-18', '678-901-2456'),
('S57', 'Carla', 'Edwards', 'carla.edwards@example.com', '2025-04-20', '789-012-3567'),
('S58', 'Daniel', 'Stewart', 'daniel.stewart@example.com', '2025-04-22', '890-123-4678'),
('S59', 'Emily', 'Sanchez', 'emily.sanchez@example.com', '2025-04-25', '901-234-5789'),
('S60', 'Frank', 'Morris', 'frank.morris@example.com', '2025-04-28', '012-345-6890'),
('S61', 'Grace', 'Rogers', 'grace.rogers@example.com', '2025-05-01', '123-456-8012'),
('S62', 'Henry', 'Reyes', 'henry.reyes@example.com', '2025-05-05', '234-567-9123'),
('S63', 'Isabella', 'Gonzalez', 'isabella.gonzalez@example.com', '2025-05-10', '345-678-9234'),
('S64', 'Jack', 'Wilson', 'jack.wilson@example.com', '2025-05-15', '456-789-0345'),
('S65', 'Katherine', 'Anderson', 'katherine.anderson@example.com', '2025-05-20', '567-890-1456'),
('S66', 'Liam', 'Thomas', 'liam.thomas@example.com', '2025-05-25', '678-901-2567'),
('S67', 'Mia', 'Taylor', 'mia.taylor@example.com', '2025-05-30', '789-012-3678'),
('S68', 'Noah', 'Hernandez', 'noah.hernandez@example.com', '2025-06-01', '890-123-4789'),
('S69', 'Olivia', 'Lopez', 'olivia.lopez@example.com', '2025-06-01', '901-234-5890'),
('S70', 'Paul', 'Gonzalez', 'paul.gonzalez@example.com', '2025-06-02', '012-345-6901'),
('S71', 'Quinn', 'Wilson', 'quinn.wilson@example.com', '2025-06-02', '123-456-7012'),
('S72', 'Rachel', 'Anderson', 'rachel.anderson@example.com', '2025-06-03', '234-567-8123'),
('S73', 'Samuel', 'Thomas', 'samuel.thomas@example.com', '2025-06-03', '345-678-9234'),
('S74', 'Tina', 'Taylor', 'tina.taylor@example.com', '2025-06-04', '456-789-0345'),
('S75', 'Uma', 'Hernandez', 'uma.hernandez@example.com', '2025-06-04', '567-890-1456'),
('S76', 'Victor', 'Lopez', 'victor.lopez@example.com', '2025-06-05', '678-901-2567'),
('S77', 'Wendy', 'Gonzalez', 'wendy.gonzalez@example.com', '2025-06-05', '789-012-3678'),
('S78', 'Xander', 'Wilson', 'xander.wilson@example.com', '2025-06-06', '890-123-4789'),
('S79', 'Yara', 'Anderson', 'yara.anderson@example.com', '2025-06-06', '901-234-5890'),
('S80', 'Zack', 'Thomas', 'zack.thomas@example.com', '2025-06-07', '012-345-6901'),
('S81', 'Amber', 'Taylor', 'amber.taylor@example.com', '2025-06-07', '123-456-7012'),
('S82', 'Brandon', 'Hernandez', 'brandon.hernandez@example.com', '2025-06-08', '234-567-8123'),
('S83', 'Caleb', 'Lopez', 'caleb.lopez@example.com', '2025-06-08', '345-678-9234'),
('S84', 'Daisy', 'Gonzalez', 'daisy.gonzalez@example.com', '2025-06-09', '456-789-0345'),
('S85', 'Elliot', 'Wilson', 'elliot.wilson@example.com', '2025-06-09', '567-890-1456'),
('S86', 'Faith', 'Anderson', 'faith.anderson@example.com', '2025-06-10', '678-901-2567'),
('S87', 'Gabriel', 'Thomas', 'gabriel.thomas@example.com', '2025-06-10', '789-012-3678'),
('S88', 'Holly', 'Taylor', 'holly.taylor@example.com', '2025-06-11', '890-123-4789'),
('S89', 'Ian', 'Hernandez', 'ian.hernandez@example.com', '2025-06-11', '901-234-5890'),
('S90', 'Jessica', 'Lopez', 'jessica.lopez@example.com', '2025-06-12', '012-345-6901'),
('S91', 'Karl', 'Gonzalez', 'karl.gonzalez@example.com', '2025-06-12', '123-456-7012'),
('S92', 'Lena', 'Wilson', 'lena.wilson@example.com', '2025-06-13', '234-567-8123'),
('S93', 'Marcus', 'Anderson', 'marcus.anderson@example.com', '2025-06-13', '345-678-9234'),
('S94', 'Natalie', 'Thomas', 'natalie.thomas@example.com', '2025-06-14', '456-789-0345'),
('S95', 'Oliver', 'Taylor', 'oliver.taylor@example.com', '2025-06-14', '567-890-1456'),
('S96', 'Patricia', 'Hernandez', 'patricia.hernandez@example.com', '2025-06-15', '678-901-2567'),
('S97', 'Quincy', 'Lopez', 'quincy.lopez@example.com', '2025-06-15', '789-012-3678'),
('S98', 'Rachel', 'Gonzalez', 'rachel.gonzalez@example.com', '2025-06-16', '890-123-4789'),
('S99', 'Simon', 'Wilson', 'simon.wilson@example.com', '2025-06-16', '901-234-5890'),
('S100', 'Tanya', 'Anderson', 'tanya.anderson@example.com', '2025-06-17', '012-345-6901'),
('S101', 'Umar', 'Thomas', 'umar.thomas@example.com', '2025-06-17', '123-456-7012'),
('S102', 'Vanessa', 'Taylor', 'vanessa.taylor@example.com', '2025-06-18', '234-567-8123'),
('S103', 'Warren', 'Hernandez', 'warren.hernandez@example.com', '2025-06-18', '345-678-9234'),
('S104', 'Xenia', 'Lopez', 'xenia.lopez@example.com', '2025-06-19', '456-789-0345'),
('S105', 'Yvette', 'Gonzalez', 'yvette.gonzalez@example.com', '2025-06-19', '567-890-1456'),
('S106', 'Zachary', 'Wilson', 'zachary.wilson@example.com', '2025-06-20', '678-901-2567'),
('S107', 'Anna', 'Anderson', 'anna.anderson@example.com', '2025-06-20', '789-012-3678'),
('S108', 'Brian', 'Thomas', 'brian.thomas@example.com', '2025-06-20', '890-123-4789'),
('S190', 'Carla', 'Taylor', 'carla.taylor@example.com', '2025-06-20', '901-234-5890'),
('S110', 'Daniel', 'Hernandez', 'daniel.hernandez@example.com', '2025-06-20', '012-345-6901'),
('S111', 'William', 'Martinez', 'william.martinez@example.com', '2025-06-20', '123-456-7891'),
('S112', 'Sophia', 'Garcia', 'sophia.garcia@example.com', '2025-06-20', '234-567-8902'),
('S113', 'Liam', 'Rodriguez', 'liam.rodriguez@example.com', '2025-06-21', '345-678-9013'),
('S114', 'Emma', 'Hernandez', 'emma.hernandez@example.com', '2025-06-21', '456-789-0124'),
('S115', 'Noah', 'Lopez', 'noah.lopez@example.com', '2025-06-22', '567-890-1235'),
('S116', 'Oliver', 'Gonzalez', 'oliver.gonzalez@example.com', '2025-06-22', '678-901-2346'),
('S117', 'James', 'Wilson', 'james.wilson@example.com', '2025-06-23', '789-012-3457'),
('S118', 'Isabella', 'Anderson', 'isabella.anderson@example.com', '2025-06-23', '890-123-4568'),
('S119', 'Elijah', 'Thomas', 'elijah.thomas@example.com', '2025-06-24', '901-234-5679'),
('S120', 'Charlotte', 'Taylor', 'charlotte.taylor@example.com', '2025-06-24', '012-345-6780');

-- Sample Data for Instructors
-- (No date changes needed - hireDate already in past relative to 2025)
INSERT INTO lms.Instructors (instructorID, firstName, lastName, email, department, hireDate) VALUES
('I1', 'Michael', 'Wilson', 'michael.wilson@university.edu', 'Computer Science', '2022-08-15'),
('I2', 'Sarah', 'Taylor', 'sarah.taylor@university.edu', 'Data Science', '2021-06-01'),
('I3', 'David', 'Martinez', 'david.martinez@university.edu', 'Business', '2023-03-10'),
('I4', 'Emily', 'Garcia', 'emily.garcia@university.edu', 'Programming', '2024-01-10'),
('I5', 'James', 'Lee', 'james.lee@university.edu', 'Data Science', '2023-11-05');

-- Sample Data for Categories
-- (No changes needed - static data)
INSERT INTO lms.Categories (categoryID, name) VALUES
('C1', 'Programming'),
('C2', 'Data Science'),
('C3', 'Business');

-- Sample Data for Courses
-- (Updated start/end dates to align with 2025)
INSERT INTO lms.Courses (courseID, title, description, credits, instructorID, categoryID, startDate, endDate) VALUES
('CRS1', 'Introduction to Programming', 'Basic concepts of programming using Python.', 3, 'I1', 'C1', '2024-12-10', '2025-03-10'),
('CRS2', 'Advanced Data Structures', 'In-depth study of advanced data structures.', 4, 'I1', 'C1', '2025-01-01', '2025-03-30'),
('CRS3', 'Data Science Fundamentals', 'An overview of data science tools and techniques.', 3, 'I2', 'C2', '2025-01-15', '2025-04-15'),
('CRS4', 'Business Analytics', 'Data-driven decision making in business.', 3, 'I3', 'C3', '2025-02-01', '2025-05-01'),
('CRS5', 'Machine Learning Basics', 'Introduction to machine learning concepts.', 4, 'I5', 'C2', '2025-04-10', '2025-07-10'),
('CRS6', 'Web Development Fundamentals', 'Building websites using HTML, CSS, and JavaScript.', 3, 'I4', 'C1', '2025-05-01', '2025-08-01'),
('CRS7', 'Financial Accounting', 'Fundamentals of accounting principles.', 3, 'I3', 'C3', '2025-04-15', '2025-07-15');

-- Sample Data for Modules
-- (No date changes needed - modules relate to updated courses)
INSERT INTO lms.Modules (moduleID, courseID, title, moduleOrder, content) VALUES
('M1', 'CRS1', 'Module 1: Introduction to Python', 1, 'Variables, Data Types, and Basic Syntax'),
('M2', 'CRS1', 'Module 2: Control Flow', 2, 'Conditionals and Loops'),
('M3', 'CRS2', 'Module 1: Trees and Graphs', 1, 'Understanding non-linear data structures'),
('M4', 'CRS3', 'Module 1: Introduction to Data Analysis', 1, 'Loading and Inspecting Data'),
('M5', 'CRS5', 'Module 1: Introduction to Machine Learning', 1, 'What is ML? Types of learning.'),
('M6', 'CRS6', 'Module 1: HTML & CSS Basics', 1, 'Structure and styling web pages'),
('M7', 'CRS7', 'Module 1: Accounting Principles', 1, 'Introduction to financial statements');

-- Sample Data for Assessments
-- (Updated due dates to align with 2025)
INSERT INTO lms.Assessments (assessmentID, courseID, type, title, maxScore, duedate) VALUES
('A1', 'CRS1', 'Assignment', 'Intro to Python Assignment', 100, '2025-01-01'),
('A2', 'CRS1', 'Exam', 'Midterm Exam', 100, '2025-02-01'),
('A3', 'CRS3', 'Project', 'Data Visualization Project', 150, '2025-02-15'),
('A4', 'CRS4', 'Assignment', 'Business Case Study', 100, '2025-03-01'),
('A5', 'CRS5', 'Project', 'Linear Regression Project', 150, '2025-05-15'),
('A6', 'CRS6', 'Assignment', 'Responsive Web Page Assignment', 100, '2025-06-01'),
('A7', 'CRS7', 'Exam', 'Midterm Exam', 100, '2025-05-20');

-- Additional Sample Data for Submissions
-- (Updated submissionDate to align with 2025)
INSERT INTO lms.Submissions (submissionID, studentID, assessmentID, submissionDate, score, fileURL, feedback) VALUES
('SUB1', 'S1', 'A1', '2024-12-28', 92, 'https://example.com/submission1.py', 'Good job!'),
('SUB2', 'S1', 'A2', '2025-01-30', 85, 'https://example.com/submission2.py', 'Solid work.'),
('SUB3', 'S2', 'A1', '2024-12-30', 78, 'https://example.com/submission3.py', 'Needs improvement.'),
('SUB4', 'S3', 'A3', '2025-02-10', 135, 'https://example.com/submission4.ipynb', 'Excellent analysis.'),
('SUB5', 'S6', 'A5', '2025-05-10', 130, 'https://example.com/submission5.py', 'Very good implementation.'),
('SUB6', 'S7', 'A6', '2025-05-28', 95, 'https://example.com/submission6.html', 'Clean design and layout.'),
('SUB7', 'S8', 'A7', '2025-05-18', 88, 'https://example.com/submission7.docx', 'Well done.');

-- Additional Sample Data for PaymentRecords
-- (Updated paymentDate to align with 2025)
INSERT INTO lms.PaymentRecords (paymentID, amount, paymentDate, paymentMethod, transactionID, status) VALUES
('P1', 199.99, '2024-12-01', 'Credit Card', 'T123456', 'Completed'),
('P2', 299.99, '2025-01-05', 'PayPal', 'T789012', 'Completed'),
('P3', 99.99, '2025-02-01', 'Credit Card', 'T345678', 'Failed'),
('P4', 199.99, '2025-02-15', 'PayPal', 'T901234', 'Completed'),
('P5', 249.99, '2025-03-10', 'Credit Card', 'T567890', 'Completed'),
('P6', 149.99, '2025-04-05', 'PayPal', 'T678901', 'Completed'),
('P7', 199.99, '2025-05-01', 'Credit Card', 'T789012', 'Completed');

-- Additional Sample Data for CourseRegistrations
-- (Updated startDate/endDate to align with 2025)
INSERT INTO lms.CourseRegistrations (registrationID, studentID, courseID, startDate, endDate, status, paymentID, type) VALUES
('R1', 'S1', 'CRS1', '2024-12-10', '2025-03-10', 'Active', 'P1', 'enrollment'),
('R2', 'S2', 'CRS1', '2024-12-10', '2025-03-10', 'Active', 'P2', 'subscription'),
('R3', 'S3', 'CRS3', '2025-01-15', '2025-04-15', 'Completed', 'P3', 'enrollment'),
('R4', 'S4', 'CRS4', '2025-02-01', '2025-05-01', 'Active', 'P4', 'subscription'),
('R5', 'S5', 'CRS5', '2025-04-10', '2025-07-10', 'Active', 'P5', 'subscription'),
('R6', 'S6', 'CRS6', '2025-05-01', '2025-08-01', 'Active', 'P6', 'enrollment'),
('R7', 'S7', 'CRS7', '2025-04-15', '2025-07-15', 'Completed', 'P7', 'enrollment');

-- Additional Sample Data for Reviews
-- (Updated reviewDate to align with 2025)
INSERT INTO lms.Reviews (reviewID, studentID, courseID, rating, comment, reviewDate) VALUES
('RV1', 'S1', 'CRS1', 5, 'Great introduction to Python!', '2025-02-15'),
('RV2', 'S2', 'CRS1', 4, 'Well structured but a bit fast-paced.', '2025-02-20'),
('RV3', 'S3', 'CRS3', 5, 'Loved the hands-on approach.', '2025-03-01'),
('RV4', 'S5', 'CRS4', 3, 'Good content, but assignments were too long.', '2025-03-10'),
('RV5', 'S6', 'CRS5', 4, 'Good course but a bit theoretical.', '2025-06-01'),
('RV6', 'S7', 'CRS6', 5, 'Loved the hands-on approach!', '2025-06-10'),
('RV7', 'S8', 'CRS7', 4, 'Informative but could use more examples.', '2025-06-15');

-- -----------------------------------------------------
-- Table: ModuleCompletions
-- -----------------------------------------------------
CREATE TABLE lms.ModuleCompletions (
    studentID VARCHAR(50) NOT NULL,
    moduleID VARCHAR(50) NOT NULL,
    completedDate DATE NOT NULL,
    PRIMARY KEY (studentID, moduleID),
    FOREIGN KEY (studentID) REFERENCES lms.Students(studentID) ON DELETE CASCADE,
    FOREIGN KEY (moduleID) REFERENCES lms.Modules(moduleID) ON DELETE CASCADE
);

-- Populate sample data for ModuleCompletions
INSERT INTO lms.ModuleCompletions (studentID, moduleID, completedDate) VALUES
('S1', 'M1', '2025-01-15'),
('S1', 'M2', '2025-02-01'),
('S2', 'M1', '2025-01-20'),
('S3', 'M4', '2025-02-10'),
('S6', 'M5', '2025-05-12'),
('S7', 'M6', '2025-05-29'),
('S8', 'M7', '2025-05-20');
