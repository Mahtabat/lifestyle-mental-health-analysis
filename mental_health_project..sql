#1.Total records
SELECT 
	COUNT(*) AS total_records
FROM 
	mental_health;
    
#2.Count by mental health condition

SELECT 
	mental_health_condition,
	COUNT(*) AS n
FROM 
	mental_health
GROUP BY mental_health_condition
ORDER BY n DESC;

#3.Percent distribution by mental health condition
SELECT 
	mental_health_condition,
	COUNT(*) AS n,
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM	
	mental_health
GROUP BY mental_health_condition
ORDER BY pct DESC;

#4.Avg happiness by mental health condition
SELECT 
	mental_health_condition,
	ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM mental_health
GROUP BY mental_health_condition
ORDER BY avg_happiness DESC;

#5.Avg happiness, sample size by condition
SELECT 
	mental_health_condition,
	COUNT(*) AS n,
	ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM mental_health
GROUP BY mental_health_condition
ORDER BY avg_happiness DESC;

#6.Condition ranking by happiness
SELECT 
	mental_health_condition,
	ROUND(AVG(happiness_rating), 2) AS avg_happiness,
	DENSE_RANK() OVER (ORDER BY AVG(happiness_rating) DESC) AS happiness_rank
FROM mental_health
GROUP BY mental_health_condition;

#7.Avg happiness by gender

SELECT 
	gender,
	COUNT(*) AS n,
	ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM mental_health
GROUP BY gender
ORDER BY avg_happiness DESC;

#8.Avg happiness by condition AND gender
SELECT 
	mental_health_condition,
	gender,
	COUNT(*) AS n,
	ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM 
	mental_health
GROUP BY mental_health_condition, gender
ORDER BY mental_health_condition, avg_happiness DESC;

#Gender gap in happiness within each condition
SELECT 
	mental_health_condition,
       ROUND(AVG(CASE WHEN gender = 'Male' THEN happiness_rating END), 2) AS male_avg,
       ROUND(AVG(CASE WHEN gender = 'Female' THEN happiness_rating END), 2) AS female_avg,
       ROUND(
         AVG(CASE WHEN gender = 'Male' THEN happiness_rating END) -
         AVG(CASE WHEN gender = 'Female' THEN happiness_rating END)
       , 2) AS male_minus_female
FROM mental_health
GROUP BY mental_health_condition
ORDER BY male_minus_female DESC;

#10.Avg happiness by age group
SELECT 
	age_group,
	COUNT(*) AS n,
	ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM 
	mental_health
GROUP BY age_group
ORDER BY avg_happiness DESC;

#11.Avg happiness by condition AND age group
SELECT 
	age_group,
	mental_health_condition,
	COUNT(*) AS n,
	ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM 
	mental_health
GROUP BY age_group, mental_health_condition
ORDER BY age_group, avg_happiness DESC;

#12.Country-level happiness
SELECT 
	country,
	COUNT(*) AS n,
	ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM 
	mental_health
GROUP BY country
HAVING COUNT(*) >= 30
ORDER BY avg_happiness DESC
LIMIT 10;

#13.Avg lifestyle metrics by mental health condition
SELECT mental_health_condition,
       ROUND(AVG(avg_sleep_hours_per_day), 2) AS avg_sleep,
       ROUND(AVG(screen_time_hours_per_day), 2) AS avg_screen_time,
       ROUND(AVG(work_hours_per_week), 2) AS avg_work_hours,
       ROUND(AVG(social_interaction_score), 2) AS avg_social
FROM 
	mental_health
GROUP BY mental_health_condition
ORDER BY mental_health_condition;

#14.Sleep category distribution
SELECT
  CASE
    WHEN avg_sleep_hours_per_day < 6 THEN 'Low Sleep'
    WHEN avg_sleep_hours_per_day BETWEEN 6 AND 8 THEN 'Adequate Sleep'
    ELSE 'High Sleep'
  END AS sleep_category,
  COUNT(*) AS n,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM 
	mental_health
GROUP BY sleep_category
ORDER BY n DESC;

#15.Avg happiness by sleep category
SELECT
  CASE
    WHEN avg_sleep_hours_per_day < 6 THEN 'Low Sleep'
    WHEN avg_sleep_hours_per_day BETWEEN 6 AND 8 THEN 'Adequate Sleep'
    ELSE 'High Sleep'
  END AS sleep_category,
  COUNT(*) AS n,
  ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM mental_health
GROUP BY sleep_category
ORDER BY avg_happiness DESC;

#16.Avg happiness by screen time category
SELECT
  CASE
    WHEN screen_time_hours_per_day < 3 THEN 'Low Screen Time'
    WHEN screen_time_hours_per_day BETWEEN 3 AND 6 THEN 'Moderate Screen Time'
    ELSE 'High Screen Time'
  END AS screen_category,
  COUNT(*) AS n,
  ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM 
	mental_health
GROUP BY screen_category
ORDER BY avg_happiness DESC;


#17.Avg happiness by work hours per week category
SELECT
  CASE
    WHEN work_hours_per_week < 35 THEN 'Short Work Week'
    WHEN work_hours_per_week BETWEEN 35 AND 45 THEN 'Moderate Work Week'
    ELSE 'Long Work Week'
  END AS work_category,
  COUNT(*) AS n,
  ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM 
	mental_health
GROUP BY work_category
ORDER BY avg_happiness DESC;

#18.Combined lifestyle imbalance
WITH categorized AS (
  SELECT *,
    CASE
      WHEN avg_sleep_hours_per_day < 6 THEN 'Low Sleep'
      WHEN avg_sleep_hours_per_day BETWEEN 6 AND 8 THEN 'Adequate Sleep'
      ELSE 'High Sleep'
    END AS sleep_cat,
    CASE
      WHEN screen_time_hours_per_day < 3 THEN 'Low Screen Time'
      WHEN screen_time_hours_per_day BETWEEN 3 AND 6 THEN 'Moderate Screen Time'
      ELSE 'High Screen Time'
    END AS screen_cat,
    CASE
      WHEN work_hours_per_week < 35 THEN 'Short Work Week'
      WHEN work_hours_per_week BETWEEN 35 AND 45 THEN 'Moderate Work Week'
      ELSE 'Long Work Week'
    END AS work_cat
  FROM mental_health
)
SELECT sleep_cat, screen_cat, work_cat,
       COUNT(*) AS n,
       ROUND(AVG(happiness_rating), 2) AS avg_happiness
FROM 
	categorized
GROUP BY sleep_cat, screen_cat, work_cat
HAVING COUNT(*) >= 20
ORDER BY avg_happiness ASC;

#19.Best vs worst lifestyle combinations
WITH combo AS (
  SELECT
    CASE
      WHEN avg_sleep_hours_per_day < 6 THEN 'Low Sleep'
      WHEN avg_sleep_hours_per_day BETWEEN 6 AND 8 THEN 'Adequate Sleep'
      ELSE 'High Sleep'
    END AS sleep_cat,
    CASE
      WHEN screen_time_hours_per_day < 3 THEN 'Low Screen Time'
      WHEN screen_time_hours_per_day BETWEEN 3 AND 6 THEN 'Moderate Screen Time'
      ELSE 'High Screen Time'
    END AS screen_cat,
    CASE
      WHEN work_hours_per_week < 35 THEN 'Short Work Week'
      WHEN work_hours_per_week BETWEEN 35 AND 45 THEN 'Moderate Work Week'
      ELSE 'Long Work Week'
    END AS work_cat,
    happiness_rating
  FROM mental_health
),
agg AS (
  SELECT sleep_cat, screen_cat, work_cat,
         COUNT(*) AS n,
         AVG(happiness_rating) AS avg_happiness
  FROM combo
  GROUP BY sleep_cat, screen_cat, work_cat
  HAVING COUNT(*) >= 20
)
SELECT sleep_cat, screen_cat, work_cat,
       n,
       ROUND(avg_happiness, 2) AS avg_happiness
FROM agg
ORDER BY avg_happiness DESC
LIMIT 5;



