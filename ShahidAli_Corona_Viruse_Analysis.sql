-- Creating Table
CREATE TABLE corona_virus_dataset (
    Province VARCHAR(60),
    Country_Region VARCHAR(60),
    Latitude FLOAT,
    Longitude FLOAT,
    Date_s DATE,
    Confirmed INT,
    Deaths INT,
    Recovered INT
);

-- Importing Data
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\MySQL Server 8.0\\Uploads\\Corona_Dataset.csv'
INTO TABLE corona_virus_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(Province, `Country_Region`, Latitude, Longitude, @Date_s, Confirmed, Deaths, Recovered) 
SET Date_s = 
    CASE
        WHEN @Date_s REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(@Date_s, '%d-%m-%Y')
        ELSE STR_TO_DATE(@Date_s, '%m/%d/%Y')
    END;


SELECT * FROM corona_virus_dataset;

-- ---------------------------------------------------------------------------------------------------------------
-- Q1. Write a code to check NULL values
SELECT 
    *
FROM
    corona_virus_dataset
WHERE
    Province IS NULL
        OR Country_Region IS NULL
        OR Latitude IS NULL
        OR Longitude IS NULL
        OR Date_s IS NULL
        OR Confirmed IS NULL
        OR Deaths IS NULL
        OR Recovered IS NULL;

-- ---------------------------------------------------------------------------------------------------------------
-- Q2. If NULL values are present, update them with zeros for all columns
UPDATE corona_virus_dataset 
SET 
    Province = COALESCE(Province, ''),
    Country_Region = COALESCE(Country_Region, ''),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Date_s = COALESCE(Date_s, '0000-00-00'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);

-- ---------------------------------------------------------------------------------------------------------------
-- Q3. Check total number of rows
SELECT 
    COUNT(*) AS total_rows
FROM
    corona_virus_dataset;
    
-- ---------------------------------------------------------------------------------------------------------------
-- Q4. Check start_date and end_date
SELECT 
    MIN(Date_s) AS start_date, MAX(Date_s) AS end_date
FROM
    corona_virus_dataset;

-- ---------------------------------------------------------------------------------------------------------------
-- Q5. Number of months present in dataset
SELECT 
    COUNT(DISTINCT DATE_FORMAT(Date_s, '%Y-%m')) AS num_months
FROM
    corona_virus_dataset;

-- ---------------------------------------------------------------------------------------------------------------
-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    DATE_FORMAT(Date_s, '%Y-%m') AS month,
    AVG(Confirmed) AS avg_confirmed,
    AVG(Deaths) AS avg_deaths,
    AVG(Recovered) AS avg_recovered
FROM
    corona_virus_dataset
GROUP BY DATE_FORMAT(Date_s, '%Y-%m');

-- ---------------------------------------------------------------------------------------------------------------
-- Q7. Find most frequent value for confirmed, deaths, recovered each month
SELECT 
    month,
    (SELECT 
            Confirmed
        FROM
            corona_virus_dataset
        WHERE
            MONTH(Date_s) = month
        GROUP BY Confirmed
        ORDER BY COUNT(*) DESC
        LIMIT 1) AS most_freq_confirmed,
    (SELECT 
            Deaths
        FROM
            corona_analysis
        WHERE
            MONTH(Date_s) = month
        GROUP BY Deaths
        ORDER BY COUNT(*) DESC
        LIMIT 1) AS most_freq_deaths,
    (SELECT 
            Recovered
        FROM
            corona_analysis
        WHERE
            MONTH(Date_s) = month
        GROUP BY Recovered
        ORDER BY COUNT(*) DESC
        LIMIT 1) AS most_freq_recovered
FROM
    (SELECT DISTINCT
        EXTRACT(MONTH FROM Date_s) AS month
    FROM
        corona_analysis) AS months
ORDER BY month;

-- ---------------------------------------------------------------------------------------------------------------
-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(Date_s) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM
    corona_virus_dataset
GROUP BY YEAR(Date_s);

-- ---------------------------------------------------------------------------------------------------------------
-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(Date_s) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM
    corona_virus_dataset
GROUP BY YEAR(Date_s);

-- ---------------------------------------------------------------------------------------------------------------
-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    DATE_FORMAT(Date_s, '%Y-%m') AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM
    corona_virus_dataset
GROUP BY DATE_FORMAT(Date_s, '%Y-%m');

-- ---------------------------------------------------------------------------------------------------------------
-- Q11. Check how corona virus spread out with respect to confirmed case
SELECT 
    COUNT(*) AS total_cases,
    AVG(Confirmed) AS avg_confirmed,
    VARIANCE(Confirmed) AS variance_confirmed,
    STDDEV(Confirmed) AS stddev_confirmed
FROM
    corona_virus_dataset;

-- ---------------------------------------------------------------------------------------------------------------
-- Q12. Check how corona virus spread out with respect to death case per month
SELECT 
    DATE_FORMAT(Date_s, '%Y-%m') AS month,
    COUNT(*) AS total_cases,
    AVG(Deaths) AS avg_deaths,
    VARIANCE(Deaths) AS variance_deaths,
    STDDEV(Deaths) AS stddev_deaths
FROM
    corona_virus_dataset
GROUP BY DATE_FORMAT(Date_s, '%Y-%m');

-- ---------------------------------------------------------------------------------------------------------------
-- Q13. Check how corona virus spread out with respect to recovered case
SELECT 
    COUNT(*) AS total_cases,
    AVG(Recovered) AS avg_recovered,
    VARIANCE(Recovered) AS variance_recovered,
    STDDEV(Recovered) AS stddev_recovered
FROM
    corona_virus_dataset;

-- ---------------------------------------------------------------------------------------------------------------
-- Q14. Find Country having highest number of the Confirmed case
SELECT 
    Country_Region, MAX(Confirmed) AS max_confirmed
FROM
    corona_virus_dataset
GROUP BY Country_Region
ORDER BY max_confirmed DESC
LIMIT 1;

-- ---------------------------------------------------------------------------------------------------------------
-- Q15. Find Country having lowest number of death case
SELECT 
    Country_Region, MIN(Deaths) AS min_deaths
FROM
    corona_virus_dataset
GROUP BY Country_Region
ORDER BY min_deaths ASC
LIMIT 1;

-- ---------------------------------------------------------------------------------------------------------------
-- Q16. Find top 5 countries having highest recovered case
SELECT 
    Country_Region, SUM(Recovered) AS total_recovered
FROM
    corona_virus_dataset
GROUP BY Country_Region
ORDER BY total_recovered DESC
LIMIT 5;

-- ---------------------------------------------------------------------------------------------------------------













