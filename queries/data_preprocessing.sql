/*
DATA PREPROCESSING AND CLEANING
*/

----------------------------------------------------------

-- 1. Handling NULL Values

-- Number of NULL values in each column of the dataset
SELECT 
    SUM(CASE WHEN company IS NULL THEN 1 ELSE 0 END) AS null_count_company,
    SUM(CASE WHEN valuation IS NULL THEN 1 ELSE 0 END) AS null_count_valuation,
    SUM(CASE WHEN date_joined IS NULL THEN 1 ELSE 0 END) AS null_count_date_joined,
    SUM(CASE WHEN industry IS NULL THEN 1 ELSE 0 END) AS null_count_industry,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_count_city,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_count_country,
    SUM(CASE WHEN continent IS NULL THEN 1 ELSE 0 END) AS null_count_continent,
    SUM(CASE WHEN year_founded IS NULL THEN 1 ELSE 0 END) AS null_count_year_founded,
    SUM(CASE WHEN funding IS NULL THEN 1 ELSE 0 END) AS null_count_funding,
    SUM(CASE WHEN select_investors IS NULL THEN 1 ELSE 0 END) AS null_count_select_investors
FROM 
    unicorn;

-- There are 16 values in city that is NULL
-- We can impute those values with the mode of the column with the same country
-- For example, if the country is USA, we can impute the city with the mode of the city column where the country is USA

-- Imputing the missing values in the city column
WITH city_mode AS (
    SELECT 
        country,
        mode() WITHIN GROUP (ORDER BY city) AS mode_city
    FROM 
        unicorn
    WHERE 
        city IS NOT NULL
    GROUP BY 
        country
)
UPDATE 
    unicorn
SET
    city = (
        SELECT 
            mode_city
        FROM 
            city_mode
        WHERE 
            unicorn.country = city_mode.country
    )
WHERE 
    city IS NULL;

-- Check the number of null values again to make sure that the imputation was successful

----------------------------------------------------------

-- 2. Reformat currency value

-- "Valuation" and "Funding" columns contains currency in the form of '$xB' (string)

-- Remove the first character from Valuation
UPDATE unicorn
SET Valuation = SUBSTRING(Valuation FROM 2);

-- Replace 'B' with '000000000' and 'M' with '000000' in Valuation
UPDATE unicorn
SET Valuation = REPLACE(REPLACE(Valuation, 'B', '000000000'), 'M', '000000');

-- Remove the first character from Funding
UPDATE unicorn
SET Funding = SUBSTRING(Funding FROM 2);

-- Replace 'B' with '000000000' and 'M' with '000000' in Funding
UPDATE unicorn
SET Funding = REPLACE(REPLACE(Funding, 'B', '000000000'), 'M', '000000');

-- Select all records to verify the updates
SELECT * FROM unicorn;


----------------------------------------------------------

--3. Convert Date_Joined to just the year

-- Extract the year from the Date_Joined column
ALTER TABLE unicorn ADD COLUMN Year_Joined INTEGER;

-- Update the new column with the year extracted from Date_Joined
UPDATE unicorn
SET Year_Joined = EXTRACT(YEAR FROM Date_Joined);

-- Drop the Date_Joined column
ALTER TABLE unicorn DROP COLUMN Date_Joined;

-- Select all records to verify the updates
SELECT * FROM unicorn;

----------------------------------------------------------

-- 4. Convert Valuation and Funding to numeric

-- Update 'nknown' to NULL for Valuation
UPDATE unicorn SET Valuation = NULL WHERE Valuation = 'nknown';

-- Update 'nknown' to NULL for Funding
UPDATE unicorn SET Funding = NULL WHERE Funding = 'nknown';

-- Convert Valuation and Funding columns to numeric
ALTER TABLE unicorn ALTER COLUMN Valuation TYPE NUMERIC USING Valuation::NUMERIC;
ALTER TABLE unicorn ALTER COLUMN Funding TYPE NUMERIC USING Funding::NUMERIC;

-- Select all records to verify the updates
SELECT * FROM unicorn;
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'unicorn';

----------------------------------------------------------

-- 5. Export the cleaned dataset to a new CSV file

COPY unicorn TO 'C:\Users\Goutham\Desktop\Goutham\VSC-Files\sql\unicorn_companies\data\unicorn_cleaned.csv' DELIMITER ',' CSV HEADER;