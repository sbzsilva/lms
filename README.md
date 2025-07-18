# Learning Management System (LMS) Assignment Project

This repository contains a comprehensive Learning Management System (LMS) assignment project, implementing a database solution for educational platform management.

## Key Components

- **Database Schema**: Defined in `lms_ddL.sql` with complete DDL statements
- **Entity Relationship Diagram**: Documented in `lmsERD.md`
- **Cardinality Documentation**: Detailed in `lmsCardinality.md` which describes the relationships between core entities such as:
  - Users and Courses
  - Students and Enrollments
  - Instructors and Courses
  - Assessments and Submissions
  - Modules and Lessons

  The system implements the following key relationships:
  ```mermaid
  erDiagram
      Students ||--o{ CourseRegistrations : "has"
      CourseRegistrations }o--|| Courses : "registers in"

      Instructors ||--o{ Courses : "teaches"
      Categories ||--o{ Courses : "has"

      Courses ||--o{ Modules : "contains"
      Courses ||--o{ Assessments : "has"

      Students ||--o{ Submissions : "submits"
      Assessments ||--o{ Submissions : "has"

      CourseRegistrations ||--o{ PaymentRecords : "references"

      Students ||--o{ Reviews : "writes"
      Reviews }o--|| Courses : "about"
  ```

- **Presentation Materials**: Available in `lms_presentation.md` covering system architecture and design decisions
- **Sample Data**: Provided in `lms_sample_data.sql` for demonstration purposes
- **Query Examples**: Demonstrated across two files (`lms_queries.sql` and `queries.md`) showcasing common operations and data retrieval patterns

The project demonstrates a well-structured relational database design for an educational platform, with proper normalization, relationship management, and query optimization.