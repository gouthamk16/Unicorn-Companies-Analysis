-- Creating the tabel for the dataset
-- The dataset contains the following columns
-- Company (varchar)
-- Valuation (varchar)
-- Date Joined (date(dd//mm/yyyy))
-- Industry (varchar)
-- City (varchar)
-- Country (varchar)
-- Continent (varchar)
-- Year Founded (int)
-- Funding (varchar)
-- Select Investors (varchar)

CREATE TABLE unicorn (
    Company varchar,
    Valuation varchar,
    Date_Joined date,
    Industry varchar,
    City varchar,
    Country varchar,
    Continent varchar,
    Year_Founded int,
    Funding varchar,
    Select_Investors varchar
);


COPY unicorn
FROM 'C:\Users\Goutham\Desktop\Goutham\VSC-Files\sql\unicorn_companies\data\unicorn.csv'
DELIMITER ','
CSV HEADER;