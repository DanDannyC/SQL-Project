DELIMITER $$ 
CREATE PROCEDURE crime_p()
BEGIN
	INSERT INTO crime.crime_t (
Report_No,
Incident_time,
Complaint_type,
Cctv_flag,
Precinct_code, 
Area_code, 
Area_name,
Cctv_count,
Population_density,
Rounds_per_day,
Crime_code, 
Crime_type, 
Weapon_code,
Weapon_desc,
Case_status_code, 
Case_status_desc, 
Victim_code,
Victim_name,
Victim_sex, 
Victim_age,
Was_victim_alone,
Is_victim_insured,
Offender_code,
Offender_name,
Offender_sex,
Offender_age,
Repeated_offender,
No_of_offences,
Offender_relation,
Officer_code,
Officer_name,
Officer_sex,
Avg_close_days,
Week_number	
	) SELECT * FROM crime.temp_t;
END;


DELIMITER $$
CREATE PROCEDURE location_t_p()
BEGIN
	INSERT INTO location_t (
Area_Code,
Area_Name, 
CCTV_Count,
Population_Density, 
Rounds_per_Day
    )
    SELECT DISTINCT 
Area_Code,
Area_Name, 
CCTV_Count,
Population_Density, 
Rounds_per_Day
	FROM crime_t WHERE Area_code
    NOT IN (SELECT DISTINCT Area_Code FROM location_t);
END;

DELIMITER $$
CREATE PROCEDURE officer_t_p()
BEGIN
	INSERT INTO officer_t (
Officer_Code,
Officer_Name, 
Officer_Sex,
Avg_Close_Days,
Precinct_Code
    )
    SELECT DISTINCT 
Officer_Code,
Officer_Name, 
Officer_Sex,
Avg_Close_Days,
Precinct_Code
	FROM crime_t WHERE Officer_code
    NOT IN (SELECT DISTINCT Officer_Code FROM officer_t);
END;


DELIMITER $$

CREATE PROCEDURE victim_t_p()
BEGIN
	INSERT INTO victim_t (
Victim_Code, 
Victim_Name,
Victim_Age,
Victim_Sex, 
Was_Victim_Alone,
Is_Victim_Insured
    )
    SELECT DISTINCT 
Victim_Code, 
Victim_Name,
Victim_Age,
Victim_Sex, 
Was_Victim_Alone,
Is_Victim_Insured
	FROM crime_t WHERE victim_code
    NOT IN (SELECT DISTINCT victim_Code FROM victim_t);
END;

DELIMITER $$

CREATE PROCEDURE report_t_p(weeknum INTEGER)
BEGIN
	INSERT INTO report_t (
Report_No,
Incident_Time,
Complaint_Type,
CCTV_Flag,
Area_Code,
Victim_Code,
Officer_Code,
Offender_Code,
Offender_Name,
Offender_Age,
Offender_Sex,
Repeated_Offender,
No_Of_Offences,
Offender_Relation,
Crime_Code,
Crime_Type,
Weapon_Code,
Weapon_Desc,
Case_Status_Code,
Case_Status_Desc,
Week_Number
	) 
    SELECT DISTINCT
Report_No,
Incident_Time,
Complaint_Type,
CCTV_Flag,
Area_Code,
Victim_Code,
Officer_Code,
Offender_Code,
Offender_Name,
Offender_Age,
Offender_Sex,
Repeated_Offender,
No_Of_Offences,
Offender_Relation,
Crime_Code,
Crime_Type,
Weapon_Code,
Weapon_Desc,
Case_Status_Code,
Case_Status_Desc,
Week_Number
	FROM crime_t WHERE WEEK_NUMBER = weeknum;
END;
DELIMITER $$
DROP PROCEDURE report_t_p;