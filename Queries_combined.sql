--1. How many unique IDS are in each table
Select COUNT (DISTINCT daily_activity.id) as act_id,COUNT(Distinct sleep_day.id) as slp_id, Count(Distinct weight_log.id) AS weight_id
From daily_activity
FULL JOIN sleep_day ON daily_activity.id = sleep_day.id
FULL JOIN weight_log ON daily_activity.id = weight_log.id

--2. How many users overlap in each table
Select COUNT (DISTINCT daily_activity.id) as act_id,COUNT(Distinct sleep_day.id) as slp_id, Count(Distinct weight_log.id) AS weight_id
From daily_activity
JOIN sleep_day ON daily_activity.id = sleep_day.id
JOIN weight_log ON daily_activity.id = weight_log.id

--3. Which ID's overlap in all weight,sleep and daily acitivity
Select DISTINCT daily_activity.id as act_id, sleep_day.id as slp_id, weight_log.id
From daily_activity
JOIN sleep_day ON daily_activity.id = sleep_day.id
JOIN weight_log ON daily_activity.id = weight_log.id

--4.Average Activity for each attribute grouped by ID
--Created Table named "Activity_Avg_by_id"
Create TABLE Activity_Avg_by_id AS (
SELECT DISTINCT Id,
 COUNT(Id) AS logs,
 AVG(totalsteps) AS avg_steps,
 AVG(totaldistance) AS avg_total_distance, 
 AVG(veryactivedistance) AS avg_very_min,
 AVG(moderatelyactivedistance) AS avg_fair_min,
 AVG(lightactivedistance) AS avg_light_min,
 AVG(sedentaryminutes) AS avg_sedentary_min,
 AVG(calories) AS avg_calories_burned
FROM daily_activity
GROUP BY Id
ORDER BY Id
	)

--5.How much sleep do users get on average?
--Created Table named "Sleep_Avg_by_id"
Create TABLE Sleep_Avg_by_id AS (
SELECT *,
(avg_min_asleep/60) AS avg_hour_asleep     
FROM (      
   SELECT DISTINCT id,      
    COUNT(id) AS total_logs,           
    SUM(totalminutesasleep) AS total_min_asleep,      
    AVG(totalminutesasleep) AS avg_min_asleep     
 FROM sleep_day     
 GROUP BY Id      
 ORDER BY Id ) AS Sleep_Totals_id
	)

--6.Are there any correlation between user sleep habits with activity habits?
--Created Table named "merge_sleep_activity_id"
Create Table merge_sleep_activity_id AS (
SELECT ACTIVITY_AVG_BY_ID.ID,
	ACTIVITY_AVG_BY_ID.LOGS,
	ACTIVITY_AVG_BY_ID.AVG_STEPS,
	activity_avg_by_id.avg_total_distance,
	activity_avg_by_id.avg_fair_min,
	activity_avg_by_id.avg_light_min,
	ACTIVITY_AVG_BY_ID.avg_sedentary_min,
	ACTIVITY_AVG_BY_ID.avg_calories_burned,
	SLEEP_AVG_BY_ID.total_logs,
	SLEEP_AVG_BY_ID.total_min_asleep,
	SLEEP_AVG_BY_ID.avg_min_asleep,
	SLEEP_AVG_BY_ID.avg_hour_asleep
FROM ACTIVITY_AVG_BY_ID
JOIN SLEEP_AVG_BY_ID ON ACTIVITY_AVG_BY_ID.ID = SLEEP_AVG_BY_ID.ID
ORDER BY SLEEP_AVG_BY_ID.ID
	)

--7.Are there differences in user activities throughout the week?
--Created Table named "avg_activity_by_day"
Create Table avg_activity_by_day AS (
SELECT to_char(activitydate, 'Day') AS day_week, Count(*) as Logs,
 AVG(totalsteps) AS avg_steps,
 AVG(veryactiveminutes) AS avg_very_act_min,
 AVG(fairlyactiveminutes) AS avg_fairly_act_min,
 AVG(lightlyactiveminutes) AS avg_lightly_act_min,
 AVG(sedentaryminutes) AS avg_sedentary_min,
 AVG(totaldistance) AS avg_total_dist,
 AVG(calories) AS avg_calories_burned
FROM daily_activity
GROUP BY day_week
	)

--8.Are users getting a good amount of sleep throughout the week and are there days where users get less sleep?
--Created Table named "Avg_sleep_by_day"
Create TABLE Avg_sleep_by_day AS (
SELECT *,
(avg_min_asleep/60) AS avg_hour_asleep 
FROM (
SELECT to_char(sleepday, 'Day') AS day_week, Count(*) as number_of_day,
 AVG(totalminutesasleep) AS avg_min_asleep
FROM sleep_day
GROUP BY day_week
	) as sub
	)

--9.Any trends between activity and sleep within the days of the week?
--Created Table named "merged_avg_sleep_activity_day"
Create TABLE merged_avg_sleep_activity_day AS (
SELECT 
 avg_sleep_by_day.day_week,
 avg_sleep_by_day.number_of_day AS sleep_logs,
 avg_activity_by_day.logs AS activity_logs,
 avg_min_asleep,
 avg_hour_asleep, avg_very_act_min,
 avg_fairly_act_min, avg_lightly_act_min, avg_sedentary_min
FROM avg_sleep_by_day
JOIN avg_activity_by_day ON avg_activity_by_day.day_week = avg_sleep_by_day.day_week
	)

--10.Were users consistent throughout the month or did they increase or decrease activity during the month?
--Created Table named "avg_activity_by_dates"
Create table avg_activity_by_dates AS (
SELECT DISTINCT activitydate,
 COUNT(Id) AS logs,
 AVG(totalsteps) AS avg_steps,
 AVG(totaldistance) AS avg_total_distance, 
 AVG(veryactiveminutes) AS avg_very_act_min,
 AVG(fairlyactiveminutes) AS avg_fairly_act_min,
 AVG(lightlyactiveminutes) AS avg_light_min,
 AVG(sedentaryminutes) AS avg_sedentary_min,
 AVG(Calories) AS avg_calories_burned
FROM daily_activity
GROUP BY activitydate
ORDER BY activitydate
	)

--11.Were users consistent throughout the month or did they increase or decrease sleep during the month?
--Created Table named "sleep_avg_by_date"
Create Table sleep_avg_by_date AS (
SELECT *,
(avg_min_asleep/60) AS avg_hour_asleep
FROM (
 SELECT DISTINCT sleepday,      
 COUNT(sleepday) AS logs,          
 SUM(totalminutesasleep) AS total_min_asleep,      
 AVG(totalminutesasleep) AS avg_min_asleep     
 FROM sleep_day     
 GROUP BY sleepday  
 ORDER BY sleepday ) AS subquery
	)

--12.Any trends between activity and sleep within the the month?
--Created Table named "merged_avg_sleep_activity_date"
Create table merged_avg_sleep_activity_date as (
SELECT sleep_avg_by_date.sleepday, avg_steps, avg_total_distance, avg_very_act_min, avg_fairly_act_min, avg_light_min, avg_sedentary_min, avg_calories_burned, avg_min_asleep, avg_hour_asleep
FROM avg_activity_by_dates
JOIN sleep_avg_by_date ON avg_activity_by_dates.activitydate = sleep_avg_by_date.sleepday
ORDER BY sleepday
	)

--13.What was the average weight and BMI and how often did users log data?
--Created Table named "weight_avg"
Create table weight_avg AS (
SELECT 
 DISTINCT Id,
 COUNT(Id) AS total_logs,
 AVG(weightpounds) AS avg_weight_lbs,
 AVG(bmi) AS avg_BMI
FROM weight_log
GROUP BY Id
ORDER BY Id
	)

--14. Created table to make visualization for how steps vary by week
Create Table avg_step_day AS (
SELECT day_week, avg_steps                     
FROM avg_activity_by_day
GROUP BY day_week, avg_step
)

--15.Any differences between users who track weight, sleep, and activity?
--Created Table named "weight_avg"
Create Table overlap_id_avg_logs AS (
SELECT DISTINCT sleep_avg_by_id.Id,          
 logs AS activity_logs,         
 sleep_avg_by_id.total_logs AS sleep_logs,           
 weight_avg.total_logged AS weight_logs,         
 avg_steps, avg_total_distance, avg_very_min,
 avg_fair_min, avg_light_min, avg_sedentary_min,
 avg_calories_burned, avg_min_asleep         
 FROM activity_avg_by_id         
 JOIN sleep_avg_by_id ON sleep_avg_by_id.Id = activity_avg_by_id.Id            
 JOIN weight_avg ON weight_avg.Id = sleep_avg_by_id.Id     
 WHERE sleep_avg_by_id.Id = weight_avg.Id           
 ORDER BY Id
	)

--16.Any differences between users who track weight, sleep, and activity during the days of the week?
--Created  temp table named "overlap_daily_avg"
Create TEMP TABLE overlap_daily_avg AS (
SELECT to_char(activitydate, 'Day') AS day_week,
 AVG(totalsteps) AS avg_steps,   
 AVG(totaldistance) AS avg_total_distance,     
 AVG(veryactiveminutes) AS avg_very_min,  
 AVG(fairlyactiveminutes) AS avg_fair_min,    
 AVG(lightlyactiveminutes) AS avg_light_min,  
 AVG(sedentaryminutes) AS avg_sedentary_min,   
 AVG(calories) AS avg_calories_burned
FROM daily_activity
JOIN overlap_id_avg_logs ON overlap_id_avg_logs.overlap_id = daily_activity.Id
WHERE daily_activity.Id = overlap_id_avg_logs.overlap_id
GROUP BY day_week
	)
--Created temp table named "overlap_sleep_avg"
Create TEMP TABLE overlap_sleep_avg AS (
SELECT to_char(sleepday, 'Day') AS day_week,
 AVG(totalminutesasleep) AS avg_min_asleep
FROM sleep_day 
JOIN overlap_id_avg_logs ON overlap_id_avg_logs.overlap_id = sleep_day.Id
WHERE sleep_day.Id = overlap_id_avg_logs.overlap_id
GROUP BY day_week
	)
--Created table named "Overlap_id_avg_by_day"
Create Table Overlap_id_avg_by_day AS (
SELECT overlap_daily_avg.*, avg_min_asleep               
FROM overlap_daily_avg               
JOIN overlap_sleep_avg ON overlap_daily_avg.day_week = overlap_sleep_avg.day_week
)