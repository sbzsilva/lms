-- Add upgradeDate column if not exists
ALTER TABLE lms.CourseRegistrations ADD COLUMN IF NOT EXISTS upgradedate DATE;

-- Populate sample upgrade dates with explicit DATE casting
UPDATE lms.CourseRegistrations
SET upgradedate = 
CASE registrationID
    WHEN 'R2' THEN '2025-01-15'::DATE
    WHEN 'R4' THEN '2025-03-01'::DATE
    WHEN 'R5' THEN '2025-05-01'::DATE
    ELSE NULL
END
WHERE type = 'subscription';