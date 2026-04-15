-- Task 1: Basic Retrieval & Sorting
SELECT
  *
FROM
    resale_flat_prices_2017;
    
    
SELECT
  town, flat_type, resale_price
FROM
  resale_flat_prices_2017
ORDER BY
  resale_price;
  
  
 SELECT
  town, street_name, resale_price
FROM
  resale_flat_prices_2017
ORDER BY
  town ASC,
  resale_price DESC;
  
 
-- Exercise - Select any 3 columns from the table, and sort them from highest to lowest resale price in Punggol.
 SELECT
  town, flat_type, resale_price
FROM
  resale_flat_prices_2017
WHERE
    town = 'PUNGGOL'
ORDER BY
    resale_price DESC;
    
    
-- Task 2: Transformations & Filtering
-- Example — calculate price in thousands and rename for clarity:
SELECT
  street_name,
  flat_type,
  floor_area_sqm,
  resale_price / 1000 AS price_k  -- Use command 'AS' to rename the column
FROM
  resale_flat_prices_2017
WHERE
  town = 'PUNGGOL'
  AND resale_price > 500000
ORDER BY
  resale_price DESC;
  
  
SELECT
  street_name,
  flat_type,
  floor_area_sqm,
  resale_price / 1000 AS price_k  -- Use AS to rename the column
FROM
  resale_flat_prices_2017
WHERE
  town = 'BEDOK' -- see only from BEDOK
AND floor_area_sqm > 100 -- flats with floor area greater than 100 sqm.
AND resale_price BETWEEN 400000 AND 600000 -- flats with resale price between 400,000 and 600,000.
AND lease_commence_date > 2000 -- Select flats with lease commence date later than year 2000
ORDER BY
  resale_price DESC;
  
  
-- DISTINCT – remove duplicates
SELECT DISTINCT town FROM resale_flat_prices_2017;


-- LIKE – pattern matching
SELECT * FROM resale_flat_prices_2017
WHERE town LIKE 'BEDOK';


-- Task 3: Basic Aggregates
-- How many transactions happened?
SELECT
  COUNT(*)
FROM
    resale_flat_prices_2017;
    

-- What is the most expensive flat ever sold in this dataset?
SELECT
  MAX(resale_price)
FROM
    resale_flat_prices_2017;
    
    
-- Task 4: GROUP BY & HAVING
-- Average price per town:
SELECT
  town,
  round(AVG(resale_price),2) AS avg_price
FROM
  resale_flat_prices_2017
GROUP BY
  town
HAVING town = 'TAMPINES'; -- to show just TAMPINES


SELECT
  town,
  sum(resale_price) -- total resale value (price) of flats
FROM
  resale_flat_prices_2017
GROUP BY
  town
HAVING town = 'BISHAN'; -- to show just BISHAN


-- Filter on individual rows BEFORE grouping
SELECT
    town,
  AVG(resale_price) AS avg_price
FROM
  resale_flat_prices_2017
WHERE
  resale_price > 600000
GROUP BY
  town;
  
  
 -- Filter on the aggregated result AFTER grouping
SELECT
    town,
  AVG(resale_price) AS avg_price
FROM
  resale_flat_prices_2017
GROUP BY
  town
HAVING
  AVG(resale_price) > 600000
ORDER BY
    avg_price DESC;
    

-- Group by multiple columns
SELECT
    town,
    flat_type,
    flat_model,
    AVG(resale_price) as avg_price,
FROM
    resale_flat_prices_2017
GROUP BY
    town,
    flat_type,
    flat_model
ORDER BY
    avg_price DESC;
    

-- Task 5: Categorizing with CASE
-- categorise the price
SELECT
  town,
  resale_price,
  flat_type,
  CASE
    WHEN resale_price > 1000000 THEN 'Million Dollar Club'
    WHEN resale_price > 500000 THEN 'Mid-Range'
    ELSE 'Entry-Level'
  END AS price_category
FROM
  resale_flat_prices_2017;


-- categorise the flat size
SELECT
  town,
  resale_price,
  flat_type,
    CASE
    WHEN flat_type IN ('1 ROOM', '2 ROOM', '3 ROOM') THEN 'Small'
    WHEN flat_type = '4 ROOM' THEN 'Medium'
    ELSE 'Large'
  END AS flat_size
FROM
  resale_flat_prices_2017;


-- categorise the lease dates
SELECT
  town,
  resale_price,
  flat_type,
  lease_commence_date,
    CASE
    WHEN lease_commence_date < 1990 THEN 'Old'
    WHEN lease_commence_date >= 1990 THEN 'New'
  END AS oldvsnew
FROM
  resale_flat_prices_2017
ORDER BY
    town DESC;


-- Task 6: Dates and Casting
-- Convert text to a real date and extract the year:
SELECT
    month,
    (month || '-01')::DATE AS transaction_date,     -- ANSI SQL style (maximum portability) of the CAST function
    EXTRACT (year FROM (month || '-01')::DATE) AS sale_year
FROM resale_flat_prices_2017;


-- Step 1: Add a new column
ALTER TABLE resale_flat_prices_2017
ADD COLUMN transaction_date DATE;
-- Step 2: Fill the new column with data as a generated column (auto-fills)
ALTER TABLE resale_flat_prices_2017
ADD COLUMN transaction_date DATE
SET transaction_date = CAST(month || '-01' AS DATE);

-- Alternative: Recreate the Table (The "True" One-Step)
CREATE OR REPLACE TABLE resale_flat_prices_2017 AS 
SELECT 
    *, 
    CAST(month || '-01' AS DATE) AS transaction_date
FROM resale_flat_prices_2017;


-- Extract the transaction year:
SELECT
  *,
  date_part('year', transaction_date) AS transaction_year
FROM
  resale_flat_prices_2017;