---
marp: true
---

# Learning Management System (LMS) Database Overview

---

## Slide 2: Introduction
- Database Name: lms
- Schema: lms
- Key Entities: Students, Instructors, Courses, Assessments, etc.
- Created by: ssilva

---

## Slide 3: Database Structure
- 10 core tables:
  - Students
  - Instructors
  - Categories
  - Courses
  - Modules
  - Assessments
  - Submissions
  - PaymentRecords
  - CourseRegistrations
  - Reviews

## Slide 4: Key Relationships
- Students enroll in courses through CourseRegistrations
- Courses belong to a category and have an instructor
- Courses contain modules and assessments
- Students submit submissions for assessments
- CourseRegistrations may be linked to payment records
- Students can leave reviews for courses

---

## Slide 5: Sample Data Highlights
- 120+ students with diverse names and enrollment dates
- 5 instructors across different departments
- 3 categories: Programming, Data Science, Business
- 7 courses with realistic start/end dates
- Various assessments with scores and feedback
- Payment records showing different methods and amounts

---

## Slide 6: Query Analysis
- 30 analytical queries provided
- Focus on business intelligence and reporting
- Covers key performance indicators for the LMS platform
- Includes revenue analysis, course performance, student engagement

---

## Slide 7: Enrollment Analysis Queries
**Query 1:** Courses with most students enrolled this month
```sql
SELECT c.courseID, c.title, COUNT(cr.studentID) AS studentCount
FROM lms.CourseRegistrations cr
JOIN lms.Courses c ON cr.courseID = c.courseID
WHERE cr.startDate >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY c.courseID, c.title
ORDER BY studentCount DESC;
```

---

## Slide 8: Trending Courses Analysis
**Query 2:** Top 5 trending courses based on enrollment growth
```sql
SELECT c.courseID, c.title, 
       COUNT(cr.studentID) AS studentCount,
       ROUND((COUNT(cr.studentID) * 100.0 / GREATEST(LAG(COUNT(cr.studentID)) 
       OVER (ORDER BY DATE_TRUNC('month', cr.startDate)), 1) - 100), 2) AS growthRate
FROM lms.CourseRegistrations cr
JOIN lms.Courses c ON cr.courseID = c.courseID
WHERE cr.startDate >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY c.courseID, c.title, DATE_TRUNC('month', cr.startDate)
ORDER BY growthRate DESC
LIMIT 5;
```

---

## Slide 9: Category Popularity
**Query 3:** Categories with highest enrollment
```sql
SELECT cat.name AS categoryName, COUNT(cr.studentID) AS studentCount
FROM lms.CourseRegistrations cr
JOIN lms.Courses c ON cr.courseID = c.courseID
JOIN lms.Categories cat ON c.categoryID = cat.categoryID
GROUP BY cat.name
ORDER BY studentCount DESC;
```

---

## Slide 10: Revenue Analysis
**Query 4:** Premium subscription revenue last quarter
```sql
SELECT SUM(p.amount) AS totalRevenue
FROM lms.PaymentRecords p
JOIN lms.CourseRegistrations cr ON p.paymentID = cr.paymentID
WHERE p.paymentDate >= CURRENT_DATE - INTERVAL '3 months'
  AND cr.type = 'subscription';
```

---

## Slide 11: Revenue Sources Comparison
**Query 5:** Subscription vs one-time purchases
```sql
WITH revenue_sources AS (
    SELECT 
        CASE WHEN cr.type = 'subscription' THEN 'subscription' ELSE 'one-time' END AS paymentType,
        SUM(p.amount) AS amount
    FROM lms.PaymentRecords p
    JOIN lms.CourseRegistrations cr ON p.paymentID = cr.paymentID
    GROUP BY CASE WHEN cr.type = 'subscription' THEN 'subscription' ELSE 'one-time' END
)
SELECT paymentType, 
       ROUND((amount * 100.0 / SUM(amount) OVER ()), 2) AS percentage
FROM revenue_sources;
```

---

## Slide 12: Top Revenue Contributors
**Query 6:** Students contributing highest revenue
```sql
SELECT s.studentID, s.firstName, s.lastName, 
       SUM(p.amount) AS totalRevenue
FROM lms.PaymentRecords p
JOIN lms.CourseRegistrations cr ON p.paymentID = cr.paymentID
JOIN lms.Students s ON cr.studentID = s.studentID
WHERE p.paymentDate >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY s.studentID, s.firstName, s.lastName
ORDER BY totalRevenue DESC;
```

---

## Slide 13: Instructor Performance
**Query 7:** Instructors with highest rated courses
```sql
SELECT i.instructorID, i.firstName, i.lastName, 
       c.title AS courseTitle, AVG(r.rating) AS averageRating
FROM lms.Reviews r
JOIN lms.Courses c ON r.courseID = c.courseID
JOIN lms.Instructors i ON c.instructorID = i.instructorID
GROUP BY i.instructorID, i.firstName, i.lastName, c.title
ORDER BY averageRating DESC;
```

---

## Slide 14: Student Progress Tracking
**Query 10:** Students who completed all modules
```sql
SELECT s.studentID, s.firstName, s.lastName, s.courseID, c.title AS courseTitle
FROM (
    SELECT studentID, courseID, COUNT(*) AS submittedAssessments
    FROM lms.Submissions
    GROUP BY studentID, courseID
) s
JOIN (
    SELECT courseID, COUNT(*) AS totalAssessments
    FROM lms.Assessments
    GROUP BY courseID
) a ON s.courseID = a.courseID
JOIN lms.Students st ON s.studentID = st.studentID
JOIN lms.Courses c ON s.courseID = c.courseID
WHERE s.submittedAssessments >= a.totalAssessments
ORDER BY s.studentID, c.title;
```

---

## Slide 15: Conclusion & Key Takeaways
- Comprehensive LMS database design
- Rich set of analytical queries for business insights
- Well-normalized schema with appropriate relationships
- Sample data that reflects realistic usage patterns
- Queries cover all aspects of the LMS business: enrollment, revenue, performance, engagement
- Excellent foundation for building reporting and analytics capabilities