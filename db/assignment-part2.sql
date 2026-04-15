-- Question 1 - Select the minimum and maximum price per sqm of all the flats.

SELECT
printf('%,.2f', min(resale_price / floor_area_sqm)) as min_per_sqft,
printf('%,.2f', max(resale_price / floor_area_sqm)) as max_per_sqft
FROM resale_flat_prices_2017;


-- Question 2 - Select the average price per sqm for flats in each town.

SELECT
town,
printf('%,.2f', avg(resale_price / floor_area_sqm)) as avg_per_sqft,
FROM resale_flat_prices_2017
GROUP BY
town;


-- Question 3 - Categorize flats into price ranges and count how many flats fall into each category:
    -- Under $400,000: 'Budget'
    -- $400,000 to $700,000: 'Mid-Range'
    -- Above $700,000: 'Premium'
    -- Show the counts in descending order

SELECT
CASE
    when resale_price < 400000 then 'budget'
    when resale_price <= 700000 then 'mid-rage'
    else 'premium'
end as price_category,
count(*) as qty
FROM resale_flat_prices_2017
GROUP BY
price_category
ORDER BY
qty DESC;


-- Question 4 - Count the number of flats sold in each town during the first quarter of 2017 (January to March).
SELECT
town,
count(*) as qty
FROM resale_flat_prices_2017
WHERE
    month in ('2017-01', '2017-02', '2017,-03')
GROUP BY
town
ORDER BY
qty DESC;
