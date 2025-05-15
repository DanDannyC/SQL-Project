DELIMITER $$ 
CREATE FUNCTION age_f (victim_age INT)
RETURNS VARCHAR(15)
DETERMINISTIC  
BEGIN  
DECLARE age_category VARCHAR(15);
IF victim_age > 0 AND victim_age < 12 THEN
SET age_category = 'KIDS';
ELSEIF (victim_age >= 13 AND victim_age <= 23 ) THEN
SET age_category = 'TEENAGER';
ELSEIF (victim_age >= 24 AND victim_age <= 35 ) THEN
SET age_category = 'MIDDLE AGE';
ELSEIF (victim_age >= 36 AND victim_age <= 55) THEN
SET age_category = 'ADULT';
ELSEIF (victim_age >= 56 AND victim_age <= 120) THEN
SET age_category = 'OLD';
END IF;
RETURN (age_category);

END;

DELIMITER $$
CREATE FUNCTION time_f (incident_time varchar(15))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN  
DECLARE Daypart VARCHAR(15);
IF incident_time >= '00:00' AND incident_time <= '05:00' THEN
SET Daypart = 'MIDNIGHT';
ELSEIF (incident_time >= '05:01' AND incident_time <= '12:00') THEN 
SET Daypart = 'MORNING';
ELSEIF (incident_time >= '12:01' AND incident_time <= '18:00') THEN 
SET Daypart = 'AFTERNOON';
ELSEIF (incident_time >= '18:01' AND incident_time <= '21:00') THEN 
SET Daypart = 'EVENING';
ELSEIF (incident_time >= '21:01' AND incident_time <= '24:00') THEN 
SET Daypart = 'NIGHT';
END IF;
RETURN (Daypart);

END;