--------------------- A- DATA PREPARATION AND CLEANING ---------------------
-- Create the HR  table


CREATE TABLE dataHR(
    id VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    birthdate VARCHAR,
    gender VARCHAR,
    race VARCHAR,
    department VARCHAR,
    jobtitle VARCHAR, error: could not open file "C:\Users\hafsa\Downloads\hr.csv" for reading: Permission denied
    location VARCHAR,
    hire_date VARCHAR,
    termdate VARCHAR,
    location_city VARCHAR,
    location_state VARCHAR
);

--Get the data from the csv file

COPY public.datahr 
FROM 'C:\Users\hafsa\\Downloads\hr.csv'
DELIMITER ',' CSV HEADER;

--Explore the data
SELECT * FROM datahr;

--Clean the data 

------- Stating with the birth_date
Alter TABLE datahr
ADD COLUMN temp DATE;

UPDATE  datahr
SET temp = 
        CASE
            WHEN birthdate LIKE '%/%' THEN TO_DATE(birthdate,'MM/DD/YYYY')
            WHEN birthdate LIKE '%-%'THEN TO_DATE(birthdate,'MM-SS-YY')
            ELSE NULL
        END;
DELETE FROM datahr
WHERE EXTRACT (YEAR FROM temp ) > EXtract(YEAR FROM CURRENT_DATE);

ALTER TABLE datahr
DROP COLUMN birthdate;

ALTER TABLE datahr
RENAME COLUMN temp TO birth_date;

---------- hire_date
Alter TABLE datahr
ADD COLUMN temp DATE;

UPDATE  datahr
SET temp = 
        CASE
            WHEN hire_date LIKE '%/%' THEN TO_DATE(hire_date,'MM/DD/YYYY')
            WHEN hire_date LIKE '%-%'THEN TO_DATE(hire_date,'DD-MM-YY')
            ELSE NULL
        END;


DELETE FROM datahr
WHERE EXTRACT (YEAR FROM temp ) > EXtract(YEAR FROM CURRENT_DATE);

ALTER TABLE datahr
DROP COLUMN hire_date;


ALTER TABLE datahr
RENAME COLUMN temp TO hire_date;

SELECT * FROM datahr;


---------- term_date
ALTER TABLE datahr
ADD COLUMN temp DATE;

UPDATE datahr
SET temp =TO_DATE(termdate, 'YYYY-MM-DD HH24:MI:SS "UTC"');

ALTER TABLE datahr
DROP COLUMN termdate; 

ALTER TABLE datahr
RENAME COLUMN temp TO term_date;

SELECT * FROM datahr;

--------------------- B- DATA ANALYSIS ---------------------

------ After cleaning the data let's answer the most relevent questions


--What is the gender breakdown of employees in the company?
SELECT gender , COUNT(*) AS gender_count,
ROUND((COUNT(*) *100)/(SELECT COUNT(*) from datahr),2)AS percentage 
from datahr
GROUP BY gender
--What is the race/ethnicity breakdown of employees in the company?
SELECT race , COUNT(*) AS race_count,
ROUND((COUNT(*) *100)/(SELECT COUNT(*) from datahr),2)AS percentage 
from datahr
GROUP BY race
--What is the age distribution of employees in the company?

SELECT 
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(NOW(),birth_date)) BETWEEN 18 AND 25 THEN '18-25'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), birth_date)) BETWEEN 26 AND 35 THEN '26-35'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), birth_date)) BETWEEN 36 AND 45 THEN '36-45'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), birth_date)) BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_range,
    COUNT(*) AS employee_count
    FROM datahr
    GROUP BY age_range
    ORDER BY age_range;
--How many employees work at headquarters versus remote locations?
SELECT location , COUNT(*) AS remote_or_onSite,
ROUND((COUNT(*) *100)/(SELECT COUNT(*) from datahr),2)AS percentage 
from datahr
GROUP BY location;

--What is the average length of employment for employees who have been terminated?
SELECT gender,avg(
    EXTRACT(YEAR FROM AGE(term_date,hire_date))
) as avrg_year_gender 
FROM datahr
GROUP BY gender;
SELECT avg(
    EXTRACT(YEAR FROM AGE(term_date,hire_date))
) as avrg_year 
FROM datahr
--How does the gender distribution vary across departments and job titles?
SELECT department,
        gender,
        COUNT(*) AS employee_count,
        ROUND(COUNT(*) * 100/SUM(COUNT(*)) OVER (PARTITION BY department),2)AS percentage
    FROM datahr
    GROUP BY department,gender
    ORDER BY department,gender;
SELECT jobtitle,
        gender,
        COUNT(*) AS employee_count,
        ROUND(COUNT(*) * 100/SUM(COUNT(*)) OVER (PARTITION BY jobtitle),2)AS percentage
    FROM datahr
    GROUP BY jobtitle,gender
    ORDER BY jobtitle,gender;

--What is the distribution of job titles across the company?
SELECT jobtitle ,COUNT(*) AS job_title_count,
        ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM datahr),2)
        FROM datahr
    GROUP BY jobtitle
    ORDER BY jobtitle;
--Which department has the highest turnover rate?
SELECT
  department,
  jobtitle,
  COUNT(*) AS total_employees,
  COUNT(term_date) AS employees_left,
  ROUND(COUNT(term_date) * 100.0 / COUNT(*), 2) AS turnover_rate
FROM datahr
GROUP BY department, jobtitle
ORDER BY turnover_rate DESC
LIMIT 10;

--What is the distribution of employees across locations by state?
SELECT
  location_state,
  COUNT(*) AS employee_count,
  ROUND(COUNT(*)*100/(SELECT COUNT(*) from datahr),2 ) AS percent
FROM datahr
GROUP BY location_state
ORDER BY location_state;

--How has the company's employee count changed over time based on hire and term dates?
SELECT
  date_trunc('month', hire_date) AS period,
  COUNT(*) AS hired_count,
  SUM(CASE WHEN term_date IS NOT NULL THEN 1 ELSE 0 END) AS terminated_count,
  COUNT(*) - SUM(CASE WHEN term_date IS NOT NULL THEN 1 ELSE 0 END) AS net_change
FROM datahr
GROUP BY period
ORDER BY period;


--What is the tenure distribution for each department?
SELECT
  department,
  ROUND(AVG(EXTRACT(YEAR FROM AGE(term_date, hire_date))), 2) AS avg_tenure_years,
  MIN(EXTRACT(YEAR FROM AGE(term_date, hire_date))) AS min_tenure_years,
  MAX(EXTRACT(YEAR FROM AGE(term_date, hire_date))) AS max_tenure_years,
  COUNT(*) AS total_employees
FROM datahr
GROUP BY department
ORDER BY department;
