CREATE DATABASE mental_health_project;
USE mental_health_project;
CREATE TABLE mental_health (
    country                   VARCHAR(50),
    age                       INT,
    gender                    VARCHAR(20),
    exercise_level            VARCHAR(50),
    diet_type                 VARCHAR(50),
    avg_sleep_hours_per_day   DECIMAL(4,2),
    stress_level              VARCHAR(20),
    mental_health_condition   VARCHAR(50),
    work_hours_per_week       INT,
    screen_time_hours_per_day DECIMAL(4,2),
    social_interaction_score  DECIMAL(4,2),
    happiness_rating          DECIMAL(4,2),
    age_group                 VARCHAR(20)
);


