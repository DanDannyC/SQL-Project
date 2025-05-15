-- No: 1 Which was the most frequent crime committed each week? 
SELECT
crime_type,
week_number,
crime_count
FROM ( SELECT crime_type,
              week_number,
              crime_count,
RANK() OVER(PARTITION BY week_number ORDER BY crime_count DESC) count_rnk
FROM (SELECT crime_type,week_number, COUNT(*) crime_count
FROM crime.rep_loc_off_v
GROUP BY 1,2) weekly_crime) ranked_crime
WHERE count_rnk = 1;


-- No 2: Is crime more prevalent in areas with a higher population density, fewer police personnel, and a larger precinct area? 
SELECT area_name,population_density,
COUNT(DISTINCT officer_code) OFFICER_NUM,
COUNT(DISTINCT crime_code) NUM_OF_CRIMES,
RANK()OVER(order by population_density desc) POP_DENSE_RNK,
RANK()OVER(order by COUNT(DISTINCT officer_code) desc) OFFICER_RNK,
RANK()OVER(order by COUNT(DISTINCT crime_code) desc) CRIME_RNK
FROM crime.rep_loc_off_v
GROUP BY area_name,population_density
ORDER BY crime_rnk;

-- No 3: At what points of the day is the crime rate at its peak? Group this by the type of crime.
SELECT
        week_number,daypart_time,crime_cnt
FROM (
SELECT week_number,time_f(incident_time) daypart_time,
COUNT(*) crime_cnt,
RANK() OVER(PARTITION BY week_number ORDER BY COUNT(*) DESC) count_rnk
FROM rep_loc_off_v
GROUP BY 1,2
) crime_cnt
WHERE count_rnk = 1;

-- No. 4: At what point in the day do more crimes occur in a different locality?
SELECT area_name,time_of_day,crime_count
FROM (SELECT area_name,time_of_day,crime_count,
RANK() OVER(PARTITION BY area_name ORDER BY crime_count DESC) count_rnk
FROM (SELECT area_name, 
      COUNT(*) crime_count,time_f(incident_time) time_of_day
      FROM rep_loc_off_v
      GROUP BY 1,3) crime_count) crimes
      WHERE count_rnk = 1;
      
      -- NO: 5 Which age group of people is more likely to fall victim to crimes at certain points in the day?
      SELECT age_group,time_of_day,no_of_victims
      FROM (SELECT age_group,time_of_day,no_of_victims,
      RANK() OVER(PARTITION BY age_group ORDER BY no_of_victims DESC) count_rnk
      FROM (SELECT age_f(victim_age) age_group,time_f(incident_time) time_of_day,
      COUNT(*) no_of_victims
      FROM rep_vic_v
      GROUP BY 1,2) crime) rank_crime
      WHERE count_rnk = 1;
      
      -- No: 6 What is the status of reported crimes?
      SELECT case_status_desc,
      COUNT(crime_type) crime_number
      FROM rep_loc_off_v
      GROUP BY case_status_desc;
      
      -- No: 7 Does the existence of CCTV cameras deter crimes from happening?
      SELECT area_name,cctv_count,crime_type,
      COUNT(*)crime_num,
      SUM(cctv_count) OVER(PARTITION BY area_name) cctv_num,
      COUNT(*)OVER(PARTITION BY area_name) crimes_num_per_area
      FROM rep_loc_off_v
      GROUP BY 1,2,3
      ORDER BY area_name;
      
      -- OR
      
      SELECT area_name,
      cctv_count as cctv_num,
      COUNT(*) crime_rate
      FROM rep_loc_off_v
      GROUP BY 1,2
      ORDER BY 1,2 DESC;
      
       -- No: 8 How much footage has been recovered from the CCTV at the crime scene?
      SELECT area_name,
      SUM(CASE WHEN cctv_flag = 'TRUE' THEN 1 
      ELSE 0 END) FOOTAGE_NUM,
      SUM(CASE WHEN cctv_flag = 'FALSE' THEN 1 ELSE 0
      END) UNAVAILABLE_FOOTAGE
      FROM rep_loc_off_v
      GROUP BY area_name
      ORDER BY area_name;
      
      SELECT
      SUM(FOOTAGE_NUM) RECOVERED_FOOTAGE
      FROM (
       SELECT area_name,
      SUM(CASE WHEN cctv_flag = 'TRUE' THEN 1 
      ELSE 0 END) FOOTAGE_NUM,
      SUM(CASE WHEN cctv_flag = 'FALSE' THEN 1 ELSE 0
      END) UNAVAILABLE_FOOTAGE
      FROM rep_loc_off_v
      GROUP BY area_name
      ORDER BY area_name) HDNKRH;
      
      -- No 9 Is crime more likely to be committed by relation of victims than strangers?
SELECT DISTINCT crime_type,
SUM(Offender_Relation = 'YES') crime_by_relation,
SUM(Offender_Relation = 'NO') crime_by_stranger,
IF(SUM(Offender_relation = 'YES') > SUM(Offender_relation = 'NO'),
"LIKELY BY RELATION","LIKELY BY STRANGERS") CrimePossibility
FROM rep_vic_v
GROUP BY crime_type;
      
-- No 10: What are the methods used by the public to report a crime? 
SELECT
DISTINCT complaint_type,
crime_type,
COUNT(crime_type) crime_count
FROM rep_loc_off_v
GROUP BY 1,2
ORDER BY crime_count DESC;