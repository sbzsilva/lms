-- -----------------------------------------------------
-- Create database (run this separately if needed)
-- -----------------------------------------------------
-- CREATE DATABASE lms;

-- Optionally connect to the database
-- \c lms

-- -----------------------------------------------------
-- Schema: lms
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS lms AUTHORIZATION ssilva;

-- -----------------------------------------------------
-- Table: Students
-- -----------------------------------------------------
CREATE TABLE lms.Students (
    studentID VARCHAR(50) PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    enrollmentDate DATE,
    phone VARCHAR(20)
);

-- -----------------------------------------------------
-- Table: Instructors
-- -----------------------------------------------------
CREATE TABLE lms.Instructors (
    instructorID VARCHAR(50) PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    department VARCHAR(100),
    hireDate DATE
);

-- -----------------------------------------------------
-- Table: Categories
-- -----------------------------------------------------
CREATE TABLE lms.Categories (
    categoryID VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Table: Courses
-- -----------------------------------------------------
CREATE TABLE lms.Courses (
    courseID VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    credits INT,
    instructorID VARCHAR(50) NOT NULL,
    categoryID VARCHAR(50),
    startDate DATE,
    endDate DATE,
    FOREIGN KEY (instructorID)
        REFERENCES lms.Instructors(instructorID)
        ON DELETE CASCADE,
    FOREIGN KEY (categoryID)
        REFERENCES lms.Categories(categoryID)
        ON DELETE SET NULL
);

-- -----------------------------------------------------
-- Table: Modules
-- -----------------------------------------------------
CREATE TABLE lms.Modules (
    moduleID VARCHAR(50) PRIMARY KEY,
    courseID VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    moduleOrder INT NOT NULL,
    content TEXT,
    FOREIGN KEY (courseID)
        REFERENCES lms.Courses(courseID)
        ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: Assessments
-- -----------------------------------------------------
CREATE TABLE lms.Assessments (
    assessmentID VARCHAR(50) PRIMARY KEY,
    courseID VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    maxScore INT NOT NULL,
    dueDate DATE,
    FOREIGN KEY (courseID)
        REFERENCES lms.Courses(courseID)
        ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: Submissions
-- -----------------------------------------------------
CREATE TABLE lms.Submissions (
    submissionID VARCHAR(50) PRIMARY KEY,
    studentID VARCHAR(50) NOT NULL,
    assessmentID VARCHAR(50) NOT NULL,
    submissionDate DATE NOT NULL,
    score FLOAT,
    fileURL VARCHAR(512),
    feedback TEXT,
    FOREIGN KEY (studentID)
        REFERENCES lms.Students(studentID)
        ON DELETE CASCADE,
    FOREIGN KEY (assessmentID)
        REFERENCES lms.Assessments(assessmentID)
        ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: PaymentRecords
-- -----------------------------------------------------
CREATE TABLE lms.PaymentRecords (
    paymentID VARCHAR(50) PRIMARY KEY,
    amount DECIMAL(10, 2) NOT NULL,
    paymentDate DATE NOT NULL,
    paymentMethod VARCHAR(100) NOT NULL,
    transactionID VARCHAR(255),
    status VARCHAR(50)
);

-- -----------------------------------------------------
-- Table: CourseRegistrations
-- -----------------------------------------------------
CREATE TABLE lms.CourseRegistrations (
    registrationID VARCHAR(50) PRIMARY KEY,
    studentID VARCHAR(50) NOT NULL,
    courseID VARCHAR(50) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    status VARCHAR(50),
    paymentID VARCHAR(50),
    type VARCHAR(20) NOT NULL CHECK (type IN ('enrollment', 'subscription')),
    FOREIGN KEY (studentID)
        REFERENCES lms.Students(studentID)
        ON DELETE CASCADE,
    FOREIGN KEY (courseID)
        REFERENCES lms.Courses(courseID)
        ON DELETE CASCADE,
    FOREIGN KEY (paymentID)
        REFERENCES lms.PaymentRecords(paymentID)
        ON DELETE SET NULL
);

-- -----------------------------------------------------
-- Table: Reviews
-- -----------------------------------------------------
CREATE TABLE lms.Reviews (
    reviewID VARCHAR(50) PRIMARY KEY,
    studentID VARCHAR(50) NOT NULL,
    courseID VARCHAR(50) NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    reviewDate DATE NOT NULL,
    FOREIGN KEY (studentID)
        REFERENCES lms.Students(studentID)
        ON DELETE CASCADE,
    FOREIGN KEY (courseID)
        REFERENCES lms.Courses(courseID)
        ON DELETE CASCADE
);