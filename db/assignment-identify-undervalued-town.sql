-- Finding the top 5 largest flats in undervalued towns (average price < $500k)
SELECT * EXCLUDE (row_num) -- Shows all columns except the helper count
FROM 
(
    SELECT 
        town, 
        block, 
        street_name, 
        floor_area_sqm, 
        PRINTF('%,.2f', resale_price) as formatted_resale_price,
        -- Rounding to 2 decimal places and adding commas
        -- The % starts the format.
        -- The , tells DuckDB to add the thousand separator (commas).
        -- The .2f ensures exactly two decimal places.
        ROW_NUMBER() OVER                   -- This gives the biggest flat a "1", the next a "2", and so on.
        (                 
            PARTITION BY town               -- This tells DuckDB: "Start a new bucket for every town."
            ORDER BY floor_area_sqm DESC    -- Inside each town's bucket, put the biggest flats at the top.
        ) AS row_num
    FROM resale_flat_prices_2017
    -- 1. same inner querty to Find towns where the average price is < $500,000
    WHERE town IN 
    (
        SELECT town
        FROM resale_flat_prices_2017
        GROUP BY town
        HAVING AVG(resale_price) < 500000
    )
)
-- 2. Within those specific towns, find the top 5 largest flats and Only keep the top 5 of each town.
WHERE row_num <= 5 -- 
ORDER BY town, floor_area_sqm DESC;


-- Finding the town, with the lowest average price per square meter
SELECT 
    town, 
    printf('%,.2f', AVG(resale_price / floor_area_sqm)) AS avg_price_per_sqm
FROM resale_flat_prices_2017
GROUP BY town
ORDER BY avg_price_per_sqm ASC;