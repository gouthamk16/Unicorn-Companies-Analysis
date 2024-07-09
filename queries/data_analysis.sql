/*
DATA ANALYSIS

Research Questions:

Funding and Valuation Analysis:

    What is the relationship between the amount of funding a unicorn company has received and its valuation?
    Are there any noticeable trends or patterns in the funding amounts across different years?
    Which companies have the biggest return on investment

Temporal Trends:

    How has the number of unicorn companies changed over the years?
    Which year saw the highest number of unicorn companies being founded?
    What are the average funding and valuation trends over the years?

Geographical Distribution:

    Which countries and cities have the highest number of unicorn companies?
    How does the average funding and valuation of unicorn companies vary across different continents and countries?

Industry Analysis:

    Which industries have the highest number of unicorn companies?
    How do funding and valuation differ across various industries?

Investor Insights:

    Who are the most common investors in unicorn companies?
    Is there any correlation between specific investors and higher funding or valuation?

Company Longevity:

    Is there any relationship between the year a company was founded and the year it joined the unicorn club?
    Do older companies tend to have higher valuations compared to newer ones?
    On an average, how long does a company take to become a unicorn after being founded?

Regional Performance:

    How do unicorn companies in different continents perform in terms of funding and valuation?
    Are there specific cities or regions that are emerging as new hubs for unicorn companies?

Sector and Regional Interaction:

    Are there certain industries that dominate in specific regions or countries?
    How does the industry distribution of unicorn companies vary across different continents?

Investor Distribution:

    Are there particular investors who are more prominent in certain industries or regions?
    What is the geographic spread of the top investors in unicorn companies?

*/

--------------------------------------------------------------

-- 1. Funding and Valuation Analysis

-- Relationship between funding and valuation
SELECT 
    AVG(funding) AS avg_funding,
    AVG(valuation) AS avg_valuation,
    CORR(funding, valuation) AS correlation_funding_valuation
FROM unicorn;

-- Funding trends over the years
SELECT 
    year_founded,
    AVG(funding) AS avg_funding
FROM unicorn
GROUP BY year_founded
ORDER BY year_founded;

-- Companies with the highest return on investment (skip cases where funcind has value 0)
SELECT 
    company,
    funding,
    valuation,
    valuation / funding AS roi
FROM unicorn
WHERE funding > 0
ORDER BY roi DESC
LIMIT 10;

-- 2. Temporal Trends

-- Number of unicorn companies over the years
SELECT 
    year_founded,
    COUNT(*) AS num_companies
FROM unicorn
GROUP BY year_founded
ORDER BY year_founded;

-- Year with the highest number of unicorn companies
SELECT 
    year_founded,
    COUNT(*) AS num_companies
FROM unicorn
GROUP BY year_founded
ORDER BY num_companies DESC
LIMIT 1;

-- Average funding and valuation trends over the years
SELECT 
    year_founded,
    AVG(funding) AS avg_funding,
    AVG(valuation) AS avg_valuation
FROM unicorn
GROUP BY year_founded
ORDER BY year_founded;

-- 3. Geographical Distribution