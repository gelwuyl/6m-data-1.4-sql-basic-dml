# **Project Assignment: "The Property Analyst"**

**Goal:** Identify the most "undervalued" town.

1. Find the average resale\_price per town.  
2. Filter for towns where the average price is less than $450,000.  
3. Within those towns, find the top 5 largest flats (by floor\_area\_sqm) currently available.  
4. **Level Up:** Create a new column called price\_per\_sqm and find which town has the lowest average price per square meter.


---

**Post-class Materials**

* **Deep Dive:** [DuckDB Documentation on Aggregate Functions](https://duckdb.org/docs/sql/aggregates).  
* **Optional Reading:** "SQL Performance Tuning for Beginners" – Why SELECT \* is often avoided in production.


---

Write the SQL DML statements for the following questions.

## Instructions

Paste the answer as SQL in Discord Peer-Review channel. https://discord.com/channels/1165846570177150996/1457586759667028094

### Question 1

Select the minimum and maximum price per sqm of all the flats.

```sql

```

### Question 2

Select the average price per sqm for flats in each town.

```sql

```

### Question 3

Categorize flats into price ranges and count how many flats fall into each category:

- Under $400,000: 'Budget'
- $400,000 to $700,000: 'Mid-Range'
- Above $700,000: 'Premium'
  Show the counts in descending order.

```sql

```

### Question 4

Count the number of flats sold in each town during the first quarter of 2017 (January to March).

```sql

```

---
## **🛑 STOP\! Solutions Below**

*Try to solve the problems above before scrolling down.*

## **✅ Solutions**


### Part 1: The Core Solution
To find the top 5 largest flats in undervalued towns (average price < $450k), we use a Subquery. This allows us to first identify the "undervalued" list and then look inside that list for the biggest homes.

```sql
-- The Solution Query
SELECT 
    town, 
    block, 
    street_name, 
    floor_area_sqm, 
    resale_price
FROM resale_flat_prices_2017
WHERE town IN (
    -- This 'Inner Query' finds our undervalued towns
    SELECT town
    FROM resale_flat_prices_2017
    GROUP BY town
    HAVING AVG(resale_price) < 450000
)
ORDER BY floor_area_sqm DESC
LIMIT 5;
```
The Breakdown:

- The Inner Query (The "Filter"): We use GROUP BY town and HAVING to find which towns have an average price below $450k. These are our "undervalued" targets (e.g., Woodlands, Choa Chu Kang).

- The Outer Query (The "Search"): We ask SQL to look at the entire table but only show rows where the town is in our target list.

- The Result: Finally, we ORDER BY floor_area_sqm DESC to put the biggest units at the top and LIMIT 5 to keep it concise.

### Part 2: The "Level Up" Solution
This challenge tests the ability to perform math across columns and then aggregate that math.

```sql
-- Finding the town with the lowest average price per square meter
SELECT 
    town, 
    AVG(resale_price / floor_area_sqm) AS avg_price_per_sqm
FROM resale_flat_prices_2017
GROUP BY town
ORDER BY avg_price_per_sqm ASC
LIMIT 1;
```

The Breakdown:

- The Calculation: For every single row, we divide resale_price by floor_area_sqm.

- The Aggregation: We then take the AVG() of those calculated results for each town.

- The Winner: By ordering ASC (ascending) and using LIMIT 1, we isolate the single town that gives you the most space for every dollar spent.

### Question 1

```sql
SELECT 
    MIN(resale_price / floor_area_sqm) AS min_price_per_sqm, 
    MAX(resale_price / floor_area_sqm) AS max_price_per_sqm
FROM resale_flat_prices_2017;
```

### Question 2

```sql
SELECT 
    town, 
    AVG(resale_price / floor_area_sqm) AS avg_price_per_sqm
FROM resale_flat_prices_2017
GROUP BY town
ORDER BY avg_price_per_sqm DESC;
```

### Question 3

```sql
SELECT 
    CASE 
        WHEN resale_price < 400000 THEN 'Budget'
        WHEN resale_price <= 700000 THEN 'Mid-Range'
        ELSE 'Premium' 
    END AS price_category,
    COUNT(*) AS number_of_flats
FROM resale_flat_prices_2017
GROUP BY price_category
ORDER BY number_of_flats DESC;
```

### Question 4

```sql
SELECT 
    town, 
    COUNT(*) AS flats_sold
FROM resale_flat_prices_2017
WHERE month IN ('2017-01', '2017-02', '2017-03')
GROUP BY town
ORDER BY flats_sold DESC;
```

