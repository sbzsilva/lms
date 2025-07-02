-- -----------------------------------------------------
-- Product Manager Query Solutions
-- -----------------------------------------------------

-- 1. Which courses have the most students enrolled last month?
SELECT c.courseid, c.title, COUNT(cr.studentid) AS studentcount
FROM lms.courseregistrations cr
JOIN lms.courses c ON cr.courseid = c.courseid
WHERE cr.startdate >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
  AND cr.startdate < DATE_TRUNC('month', CURRENT_DATE)
GROUP BY c.courseid, c.title
ORDER BY studentcount DESC;

-- 2. What are the top 5 trending courses based on enrollment growth over the last 3 months?
SELECT c.courseid, c.title, 
       COUNT(cr.studentid) AS studentcount,
       ROUND((COUNT(cr.studentid) * 100.0 / GREATEST(LAG(COUNT(cr.studentid)) OVER (ORDER BY DATE_TRUNC('month', cr.startdate)), 1) - 100), 2) AS growthrate
FROM lms.courseregistrations cr
JOIN lms.courses c ON cr.courseid = c.courseid
WHERE cr.startdate >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY c.courseid, c.title, DATE_TRUNC('month', cr.startdate)
ORDER BY growthrate DESC
LIMIT 5;

-- 3. Which categories have the highest number of enrolled students?
SELECT cat.name AS categoryname, COUNT(cr.studentid) AS studentcount
FROM lms.courseregistrations cr
JOIN lms.courses c ON cr.courseid = c.courseid
JOIN lms.categories cat ON c.categoryid = cat.categoryid
GROUP BY cat.name
ORDER BY studentcount DESC;

-- 4. What is the total revenue from Premium subscriptions in the last quarter? (last 3 months)
SELECT SUM(p.amount) AS totalrevenue
FROM lms.paymentrecords p
JOIN lms.courseregistrations cr ON p.paymentid = cr.paymentid
WHERE p.paymentdate >= CURRENT_DATE - INTERVAL '3 months'
  AND cr.type = 'subscription';

-- 5. What percentage of total revenue comes from subscription payments versus one-time course purchases?
WITH revenue_sources AS (
    SELECT 
        CASE WHEN cr.type = 'subscription' THEN 'subscription' ELSE 'one-time' END AS paymenttype,
        SUM(p.amount) AS amount
    FROM lms.paymentrecords p
    JOIN lms.courseregistrations cr ON p.paymentid = cr.paymentid
    GROUP BY CASE WHEN cr.type = 'subscription' THEN 'subscription' ELSE 'one-time' END
)
SELECT paymenttype, 
       ROUND((amount * 100.0 / SUM(amount) OVER ()), 2) AS percentage
FROM revenue_sources;

-- 6. Identify the students contributing the highest revenue in the last year.
SELECT s.studentID, s.firstName, s.lastName, 
       SUM(p.amount) AS totalRevenue
FROM lms.PaymentRecords p
JOIN lms.CourseRegistrations cr ON p.paymentID = cr.paymentID
JOIN lms.Students s ON cr.studentID = s.studentID
WHERE p.paymentDate >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY s.studentID, s.firstName, s.lastName
ORDER BY totalRevenue DESC;

-- 7. Which instructors have the highest-rated courses, based on average review scores?
SELECT i.instructorID, i.firstName, i.lastName, 
       c.title AS courseTitle, AVG(r.rating) AS averageRating
FROM lms.Reviews r
JOIN lms.Courses c ON r.courseID = c.courseID
JOIN lms.Instructors i ON c.instructorID = i.instructorID
GROUP BY i.instructorID, i.firstName, i.lastName, c.title
ORDER BY averageRating DESC;

-- 8. What is the average number of courses taught per instructor in the Programming category?
SELECT AVG(courseCount) AS avgCoursesPerInstructor
FROM (
    SELECT i.instructorID, COUNT(c.courseID) AS courseCount
    FROM lms.Instructors i
    JOIN lms.Courses c ON i.instructorID = c.instructorID
    JOIN lms.Categories cat ON c.categoryID = cat.categoryID
    WHERE cat.name = 'Programming'
    GROUP BY i.instructorID
) AS subquery;

-- 9. Which instructors have the most students enrolled across all their courses?
SELECT i.instructorID, i.firstName, i.lastName, 
       COUNT(DISTINCT cr.studentID) AS studentCount
FROM lms.CourseRegistrations cr
JOIN lms.Courses c ON cr.courseID = c.courseID
JOIN lms.Instructors i ON c.instructorID = i.instructorID
GROUP BY i.instructorID, i.firstName, i.lastName
ORDER BY studentCount DESC;

-- 10. Which students have completed all modules in a course?
-- Note: Assuming completion means submitting all assessments in a course
SELECT st.studentid, st.firstname, st.lastname, c.courseid, c.title AS coursetitle
FROM (
    SELECT studentid, assessmentid, COUNT(*) AS submittedassessments
    FROM lms.submissions
    GROUP BY studentid, assessmentid
) s
JOIN (
    SELECT assessmentid, courseid, COUNT(*) AS totalassessments
    FROM lms.assessments
    GROUP BY assessmentid, courseid
) a ON s.assessmentid = a.assessmentid
JOIN lms.courses c ON a.courseid = c.courseid
JOIN lms.students st ON s.studentid = st.studentid
WHERE s.submittedassessments >= a.totalassessments
ORDER BY st.lastname, st.firstname, c.title;

-- 11. List students who are at least 75% complete with their enrolled courses.
WITH CourseAssessmentCounts AS (
    SELECT courseid, COUNT(*) AS totalassessments
    FROM lms.assessments
    GROUP BY courseid
),
StudentAssessmentCompletion AS (
    SELECT s.studentid, a.courseid, 
           COUNT(sa.assessmentid) AS completedassessments,
           MAX(ca.totalassessments) AS totalassessments
    FROM lms.courseregistrations s
    JOIN lms.submissions sa ON s.studentid = sa.studentid
    JOIN lms.assessments a ON sa.assessmentid = a.assessmentid
    JOIN courseassessmentcounts ca ON a.courseid = ca.courseid
    GROUP BY s.studentid, a.courseid
)
SELECT st.studentid, st.firstname, st.lastname, 
       sac.courseid, c.title AS coursetitle,
       ROUND((sac.completedassessments * 100.0 / sac.totalassessments), 2) AS completionpercentage
FROM studentassessmentcompletion sac
JOIN lms.students st ON sac.studentid = st.studentid
JOIN lms.courses c ON sac.courseid = c.courseid
WHERE sac.totalassessments > 0
  AND (sac.completedassessments * 100.0 / sac.totalassessments) >= 75
ORDER BY completionpercentage DESC;

-- 12. How many students dropped out of courses before completing any module?
-- Note: Assuming 'dropped out' means enrollment ended and no assessments were submitted
SELECT COUNT(DISTINCT cr.studentid) AS droppedoutcount
FROM lms.courseregistrations cr
LEFT JOIN (
    SELECT DISTINCT sa.studentid, a.courseid
    FROM lms.submissions sa
    JOIN lms.assessments a ON sa.assessmentid = a.assessmentid
) s ON cr.studentid = s.studentid AND cr.courseid = s.courseid
WHERE cr.enddate < CURRENT_DATE
  AND s.courseid IS NULL;

-- 13. What is the average score for each assessment in the 'Introduction to Data Science' course?
SELECT a.title AS assessmentTitle, AVG(s.score) AS averageScore
FROM lms.Submissions s
JOIN lms.Assessments a ON s.assessmentID = a.assessmentID
JOIN lms.Courses c ON a.courseID = c.courseID
WHERE c.title = 'Data Science Fundamentals'
GROUP BY a.assessmentID, a.title
ORDER BY averageScore DESC;

-- 14. Identify the top 10 assessments with the lowest average scores.
SELECT a.title AS assessmentTitle, c.title AS courseTitle, 
       AVG(s.score) AS averageScore
FROM lms.Submissions s
JOIN lms.Assessments a ON s.assessmentID = a.assessmentID
JOIN lms.Courses c ON a.courseID = c.courseID
GROUP BY a.assessmentID, a.title, c.title
ORDER BY averageScore ASC
LIMIT 10;

-- 15. How many students submitted assessments after the deadline in the last month?
SELECT COUNT(DISTINCT s.studentID) AS lateSubmitters
FROM lms.Submissions s
JOIN lms.Assessments a ON s.assessmentID = a.assessmentID
WHERE s.submissionDate > a.duedate
  AND s.submissionDate >= CURRENT_DATE - INTERVAL '1 month';

-- 16. How many students have active Free vs. Premium subscriptions?
SELECT type AS subscriptionType, COUNT(*) AS studentCount
FROM lms.CourseRegistrations
WHERE status = 'Active'
  AND type IN ('enrollment', 'subscription')
GROUP BY type;

-- 17. What is the average duration (in days) of Free subscriptions before students upgrade to Premium?
-- Note: Using payment records to identify upgrades from Free (enrollment) to Premium (subscription)
WITH UpgradeDurations AS (
    SELECT cr_enroll.studentID,
           (ps.paymentDate - pe.paymentDate) AS durationDays
    FROM lms.PaymentRecords pe
    JOIN lms.CourseRegistrations cr_enroll ON pe.paymentID = cr_enroll.paymentID AND cr_enroll.type = 'enrollment'
    JOIN lms.PaymentRecords ps ON ps.paymentID = cr_enroll.paymentID
    JOIN lms.CourseRegistrations cr_sub ON ps.paymentID = cr_sub.paymentID AND cr_sub.type = 'subscription'
    WHERE pe.paymentDate < ps.paymentDate
)
SELECT AVG(durationDays) AS averageUpgradeDuration
FROM UpgradeDurations;

-- 18. List students with expired subscriptions who haven’t renewed in the last 6 months.
SELECT DISTINCT s.studentID, s.firstName, s.lastName
FROM lms.CourseRegistrations cr
JOIN lms.Students s ON cr.studentID = s.studentID
WHERE cr.status = 'Completed'
  AND cr.endDate < CURRENT_DATE
  AND cr.endDate > CURRENT_DATE - INTERVAL '6 months'
  AND NOT EXISTS (
      SELECT 1 FROM lms.CourseRegistrations cr2
      WHERE cr2.studentID = cr.studentID
        AND cr2.startDate > cr.endDate
);

-- 19. List courses with no reviews yet.
SELECT c.courseID, c.title
FROM lms.Courses c
LEFT JOIN lms.Reviews r ON c.courseID = r.courseID
WHERE r.reviewID IS NULL;

-- 20. Which payment methods (e.g., credit card, PayPal) are most frequently used by students?
SELECT paymentMethod, COUNT(*) AS usageCount
FROM lms.PaymentRecords
GROUP BY paymentMethod
ORDER BY usageCount DESC;

-- 21. List students who failed any assessment
-- Note: Assuming failing score is below 60%
SELECT DISTINCT st.studentID, st.firstName, st.lastName, 
       CAST(ROUND((s.score * 100.0 / a.maxscore)) AS numeric(10,2)) AS percentageScore,
       a.title AS assessmentTitle, c.title AS courseTitle
FROM lms.Submissions s
JOIN lms.Assessments a ON s.assessmentID = a.assessmentID
JOIN lms.Courses c ON a.courseID = c.courseID
JOIN lms.Students st ON s.studentID = st.studentID
WHERE (s.score * 100.0 / a.maxscore) < 60
ORDER BY st.lastName, st.firstName;

-- 22. Courses with the most modules?
SELECT c.courseID, c.title AS courseTitle, COUNT(m.moduleID) AS moduleCount
FROM lms.Courses c
JOIN lms.Modules m ON c.courseID = m.courseID
GROUP BY c.courseID, c.title
ORDER BY moduleCount DESC;

-- 23. Which courses have the highest number of reviews in the last quarter?
SELECT c.courseID, c.title AS courseTitle, COUNT(r.reviewID) AS reviewCount
FROM lms.Reviews r
JOIN lms.Courses c ON r.courseID = c.courseID
WHERE r.reviewDate >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY c.courseID, c.title
ORDER BY reviewCount DESC;

-- 24. What is the average review rating for each course category?
SELECT cat.name AS categoryName, AVG(r.rating) AS averageRating
FROM lms.Reviews r
JOIN lms.Courses c ON r.courseID = c.courseID
JOIN lms.Categories cat ON c.categoryID = cat.categoryID
GROUP BY cat.name
ORDER BY averageRating DESC;

-- 25. Which modules have the lowest completion rates across all courses?
-- Note: Completion rate approximated by submission coverage per module
WITH CourseStartDate AS (
    -- Get the earliest duedate per course as proxy for course start date
    SELECT courseID, MIN(duedate) AS courseStartDate
    FROM lms.Assessments
    GROUP BY courseID
),
ModuleAssessmentStats AS (
    SELECT m.moduleID, m.title AS moduleTitle, m.courseID,
           COUNT(DISTINCT sa.assessmentID) AS assessmentsSubmitted,
           COUNT(a.assessmentID) AS totalAssessments,
           (COUNT(DISTINCT sa.assessmentID) * 100.0 / GREATEST(COUNT(a.assessmentID), 1)) AS completionRate
    FROM lms.Modules m
    JOIN lms.Assessments a ON m.courseID = a.courseID
    JOIN CourseStartDate cs ON a.courseID = cs.courseID
    LEFT JOIN lms.Submissions sa ON a.assessmentID = sa.assessmentID
    WHERE m.moduleOrder <= (a.duedate - cs.courseStartDate) / 7 + 1
    GROUP BY m.moduleID, m.title, m.courseID
)
SELECT ma.moduleID, ma.moduleTitle, c.title AS courseTitle, 
       ROUND(ma.completionRate, 2) AS completionRatePercentage
FROM ModuleAssessmentStats ma
JOIN lms.Courses c ON ma.courseID = c.courseID
ORDER BY ma.completionRate ASC
LIMIT 10;

-- 26. Revenue by category of courses?
SELECT cat.name AS categoryName, SUM(p.amount) AS totalRevenue
FROM lms.PaymentRecords p
JOIN lms.CourseRegistrations cr ON p.paymentID = cr.paymentID
JOIN lms.Courses c ON cr.courseID = c.courseID
JOIN lms.Categories cat ON c.categoryID = cat.categoryID
GROUP BY cat.name
ORDER BY totalRevenue DESC;

-- 27. List courses with fewer than 10% of students completing the final assessment.
WITH FinalAssessmentCompletion AS (
    SELECT a.courseID, COUNT(DISTINCT s.studentID) AS studentsCompleted
    FROM lms.Assessments a
    JOIN lms.Submissions s ON a.assessmentID = s.assessmentID
    WHERE a.type = 'Exam' OR a.maxscore = (SELECT MAX(maxscore) FROM lms.Assessments WHERE courseID = a.courseID)
    GROUP BY a.courseID
), TotalEnrollments AS (
    SELECT courseID, COUNT(studentID) AS totalStudents
    FROM lms.CourseRegistrations
    GROUP BY courseID
)
SELECT c.courseID, c.title AS courseTitle,
       COALESCE(f.studentsCompleted, 0) AS studentsCompletedFinal,
       t.totalStudents,
       ROUND((COALESCE(f.studentsCompleted, 0) * 100.0 / GREATEST(t.totalStudents, 1)), 2) AS completionPercentage
FROM TotalEnrollments t
JOIN lms.Courses c ON t.courseID = c.courseID
LEFT JOIN FinalAssessmentCompletion f ON t.courseID = f.courseID
WHERE COALESCE(f.studentsCompleted, 0) * 100.0 / GREATEST(t.totalStudents, 1) < 10
  AND t.totalStudents > 0
ORDER BY completionPercentage ASC;

-- 28. Students with multiple premium subscriptions?
SELECT s.studentID, s.firstName, s.lastName, COUNT(*) AS subscriptionCount
FROM lms.CourseRegistrations cr
JOIN lms.Students s ON cr.studentID = s.studentID
WHERE cr.type = 'subscription'
GROUP BY s.studentID, s.firstName, s.lastName
HAVING COUNT(*) > 1
ORDER BY subscriptionCount DESC;

-- 29. Assessments without any submissions?
SELECT a.assessmentID, a.title AS assessmentTitle, c.title AS courseTitle
FROM lms.Assessments a
JOIN lms.Courses c ON a.courseID = c.courseID
LEFT JOIN lms.Submissions s ON a.assessmentID = s.assessmentID
WHERE s.submissionID IS NULL
ORDER BY c.title, a.title;

-- 30. Students with the highest average rating for reviewed courses
SELECT s.studentID, s.firstName, s.lastName, 
       AVG(r.rating) AS averageRating
FROM lms.Reviews r
JOIN lms.Students s ON r.studentID = s.studentID
GROUP BY s.studentID, s.firstName, s.lastName
ORDER BY averageRating DESC;