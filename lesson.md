# 📚 Lesson 1.4: SQL Basic — DML

## Session Overview

| | |
|---|---|
| **Duration** | 3 hours |
| **Format** | Flipped Classroom + Hands-On SQL in DbGate |
| **Tools** | DuckDB + DbGate |
| **Database** | `db/unit-1-4.db` — table: `resale_flat_prices_2017` |
| **Dataset** | Singapore HDB Resale Flat Prices 2017 |

## Agenda

| Time | Part | Topic |
|------|------|-------|
| 0:00 – 0:55 | Part 1 | Selection, Filtering & Sorting — SELECT, WHERE, ORDER BY |
| 0:55 – 1:00 | Break | — |
| 1:00 – 1:55 | Part 2 | Aggregates & Grouping — COUNT, SUM, AVG; GROUP BY; HAVING |
| 1:55 – 2:00 | Break | — |
| 2:00 – 2:55 | Part 3 | Advanced Logic & Data Cleaning — CASE, CAST, date extraction |

---

## 🏃 Part 1: The Art of Asking — Selection, Filtering & Sorting (55 min)

### 🎯 Learning Objectives
Retrieve specific columns, apply mathematical operators, filter datasets, and organize results using sorting.

### Concept Overview

**Analogy:** Querying a database is like having a conversation with your data:
- `SELECT` says: *"Give me these columns."*
- `FROM` says: *"...from this table."*
- `WHERE` says: *"...but only rows matching this condition."*
- `ORDER BY` says: *"...sorted this way."*

### 🛠️ Workshop — Task 1: Basic Retrieval & Sorting

Open DbGate and create a new connection to `db/unit-1-4.db`.

> The table we will be using is `main.resale_flat_prices_2017`. It contains HDB resale flat prices based on registration date from Jan-2017 onwards.
>
> **Data Dictionary:**
>
> | Column Name | Data Type | Description |
> |-------------|-----------|-------------|
> | month | Datetime (Month) "YYYY-MM" | Transaction month |
> | town | Text | Town name |
> | flat_type | Text | Type of flat |
> | block | Text | Block number |
> | street_name | Text | Street name |
> | storey_range | Text | Storey range |
> | floor_area_sqm | Numeric | Floor area in sqm |
> | flat_model | Text | Flat model |
> | lease_commence_date | Datetime (Year) | Year lease commenced |
> | remaining_lease | Text | Remaining lease |
> | resale_price | Numeric ($) | Resale transaction price |

**Examples:**

See all columns:

```sql
SELECT
  *
FROM
  resale_flat_prices_2017;
```

Select specific columns and sort by price (ascending is default):

```sql
SELECT
  town, flat_type, resale_price
FROM
  resale_flat_prices_2017
ORDER BY
  resale_price;
```

Sort by price from highest to lowest:

```sql
SELECT
  *
FROM
  resale_flat_prices_2017
ORDER BY
  resale_price DESC;
```

Sort by town alphabetically, then by price (highest first):

```sql
SELECT
  town, street_name, resale_price
FROM
  resale_flat_prices_2017
ORDER BY
  town ASC,
  resale_price DESC;
```

**Exercise:**
- Select any 3 columns from the table.
- Select flats from highest to lowest resale price in Punggol.

> **What's Your Query?**
> "If our table had 100 columns and a million rows, what would happen to our computer's memory if we always used `SELECT *`?"

---

### 🛠️ Workshop — Task 2: Transformations & Filtering

**Operators:**

| Operator | Description |
|----------|-------------|
| `+` | Addition |
| `-` | Subtraction |
| `*` | Multiplication |
| `/` | Division |
| `%` | Modulo |

Example — calculate price in thousands and rename for clarity:

```sql
SELECT
  street_name,
  resale_price / 1000 AS price_k  -- Use AS to rename the column
FROM
  resale_flat_prices_2017
WHERE
  town = 'PUNGGOL'
  AND resale_price > 500000
ORDER BY
  resale_price DESC;
```

**Exercise:**

"I want to find a home for my parents. They need something larger than 100sqm, but my budget is strictly under $600,000. How would we write that rule?"

> **What's Your Query?**

**Comparison and Logical Operators:**

| Operator | Description |
|----------|-------------|
| `=` | Equal |
| `<>` | Not equal |
| `>` | Greater |
| `>=` | Greater or equal |
| `<` | Less |
| `<=` | Less or equal |
| `AND` | Logical AND |
| `OR` | Logical OR |
| `NOT` | Logical NOT |

Example:

```sql
SELECT
  *
FROM
  resale_flat_prices_2017
WHERE
  town = 'BUKIT MERAH';
```

> **Exercise — basic filters:**
> - Select flats with floor area greater than 100 sqm.
> - Select flats with resale price between 400,000 and 500,000.
> - Select flats with lease commence date later than year 2000 and floor area greater than 100 sqm.

**Advanced Filters:**

```sql
-- IN – one of several values
SELECT * FROM resale_flat_prices_2017
WHERE town IN ('BUKIT MERAH', 'BUKIT TIMAH');

-- BETWEEN – numbers in a range
SELECT * FROM resale_flat_prices_2017
WHERE resale_price BETWEEN 400000 AND 500000;

-- LIKE – pattern matching
SELECT * FROM resale_flat_prices_2017
WHERE town LIKE 'B%';

-- DISTINCT – remove duplicates
SELECT DISTINCT town FROM resale_flat_prices_2017;
```

> **Optional Exercise:**
> - Return the unique flat types and flat models.
> - Find all towns starting with "P".

**Functions:**

| Function | Description |
|----------|-------------|
| `ABS()` | Absolute value of a number |
| `ROUND()` | Round to a number of decimal places |
| `LOWER()` | String in lowercase |
| `UPPER()` | String in uppercase |
| `LENGTH()` | Length of a string |
| `TRIM()` | Remove leading and trailing spaces |
| `CONCAT()` | Concatenate strings |

Example:

```sql
SELECT
  LOWER(town) AS town_lower,
  CONCAT(block, ' ', street_name) AS address
FROM
  resale_flat_prices_2017;
```

### 💬 Reflection

- Do SQL keywords need to be capitalized? Why do we use uppercase for them anyway?
- How would a real estate app like PropertyGuru use these filters when a user moves a slider on their screen?

---

## 🏃 Part 2: Finding the Big Picture — Aggregates & Grouping (55 min)

### 🎯 Learning Objectives
Summarise datasets using aggregate functions and use the `HAVING` clause to filter those summaries.

### Concept Overview

**Aggregate Functions:**

| Function | Description |
|----------|-------------|
| `COUNT()` | Number of rows |
| `SUM()` | Sum of values |
| `AVG()` | Average value |
| `MIN()` | Minimum value |
| `MAX()` | Maximum value |
| `FIRST()` | First value in a column |
| `LAST()` | Last value in a column |

### 🛠️ Workshop — Task 3: Basic Aggregates

How many transactions happened?

```sql
SELECT
  COUNT(*)
FROM
  resale_flat_prices_2017;
```

What is the most expensive flat ever sold in this dataset?

```sql
SELECT
  MAX(resale_price)
FROM
  resale_flat_prices_2017;
```

Average resale price overall:

```sql
SELECT
  AVG(resale_price) AS avg_price_overall
FROM
  resale_flat_prices_2017;
```

Average price per town:

```sql
SELECT
  town,
  AVG(resale_price) AS avg_price
FROM
  resale_flat_prices_2017
GROUP BY
  town;
```

> **Exercise:**
> - Select the average resale price of flats in Bishan.
> - Select the total resale value (price) of flats in Tampines.

---

### 🛠️ Workshop — Task 4: GROUP BY & HAVING

> **Question:** Look at this query. If you want to find the town where the average price is more than $600,000, can you use `WHERE` as a filter? Run this SQL and find out what's wrong.

```sql
-- This will fail — why?
SELECT
  town,
  AVG(resale_price) AS avg_price
FROM
  resale_flat_prices_2017
WHERE
  avg_price > 600000
ORDER BY
  avg_price DESC;
```

`WHERE` filters individual rows **before** they are grouped. To filter on aggregated results, use `HAVING` — the *post-grouping filter*.

**WHERE vs. HAVING side-by-side:**

```sql
-- Filter on individual rows BEFORE grouping
SELECT
  town,
  AVG(resale_price) AS avg_price
FROM
  resale_flat_prices_2017
WHERE
  resale_price > 500000
GROUP BY
  town;
```

```sql
-- Filter on the aggregated result AFTER grouping
SELECT
  town,
  AVG(resale_price) AS avg_price
FROM
  resale_flat_prices_2017
GROUP BY
  town
HAVING
  AVG(resale_price) > 500000;
```

Filter to show only towns with high average prices:

```sql
SELECT
  town,
  AVG(resale_price) AS avg_price
FROM
  resale_flat_prices_2017
GROUP BY
  town
HAVING
  avg_price > 600000
ORDER BY
  avg_price DESC;
```

Group by multiple columns:

```sql
SELECT
  town,
  lease_commence_date,
  AVG(resale_price) AS avg_price
FROM
  resale_flat_prices_2017
GROUP BY
  town, lease_commence_date;
```

> **Exercise:**
> - Select the average resale price by flat type.
> - Select the average resale price by flat type and flat model.
> - Select the average resale price by town and lease commence date, only for lease commence dates after year 2010, sorted by town (descending) and lease commence date (descending).

### 💬 Reflection

- What happens if you forget the `GROUP BY` but use an `AVG()`?
- If you are a government planner, how does `GROUP BY town` help you decide where to build the next MRT station or school?

---

## 🏃 Part 3: Advanced Logic & Data Cleaning (55 min)

### 🎯 Learning Objectives
Transform data using `CASE` statements for conditional categorisation and `CAST` for type conversion including date extraction.

### Concept Overview

"Data isn't always ready for analysis. A `month` column might be a text string like `'2017-01'` instead of a date object. `CAST` (or the `::` shorthand) acts as our translator to fix types. Meanwhile, `CASE` allows us to create new labels — like tagging a flat as 'Large' or 'Small' based on its type — making our data much easier to read."

### 🛠️ Workshop — Task 5: Categorizing with CASE

**Price Categories:**

```sql
SELECT
  town,
  resale_price,
  CASE
    WHEN resale_price > 1000000 THEN 'Million Dollar Club'
    WHEN resale_price > 500000 THEN 'Mid-Range'
    ELSE 'Entry-Level'
  END AS price_category
FROM
  resale_flat_prices_2017;
```

Categorize flat sizes:

```sql
SELECT
  town,
  flat_type,
  CASE
    WHEN flat_type IN ('1 ROOM', '2 ROOM', '3 ROOM') THEN 'Small'
    WHEN flat_type = '4 ROOM' THEN 'Medium'
    ELSE 'Large'
  END AS flat_size
FROM
  resale_flat_prices_2017;
```

> **Exercise:**
> - Design your own "budget/mid/high-end" categories based on resale_price.
> - Design a "old vs new" label based on lease_commence_date.

---

### 🛠️ Workshop — Task 6: Dates and Casting

**Casting Numbers:**

```sql
SELECT
  town,
  resale_price,
  CAST(resale_price AS INTEGER) AS resale_price_int
FROM
  resale_flat_prices_2017;
```

Or using shorthand:

```sql
SELECT
  town,
  resale_price,
  resale_price::INTEGER AS resale_price_int
FROM
  resale_flat_prices_2017;
```

**Convert text to a real date and extract the year:**

```sql
-- ANSI SQL style (maximum portability)
SELECT
    month,
    CAST(month || '-01' AS DATE) AS transaction_date,
    EXTRACT(YEAR FROM CAST(month || '-01' AS DATE)) AS sale_year
FROM resale_flat_prices_2017;
```

```sql
-- DuckDB/PostgreSQL style
SELECT
    month,
    (month || '-01')::DATE AS transaction_date,
    date_part('year', (month || '-01')::DATE) AS sale_year
FROM resale_flat_prices_2017;
```

> **Question:** "If the `month` column is text `'2017-01'`, can we add 1 month to it directly? Why do we need to `CAST` it to a `DATE` type first?"

**Optional — Changing the Table Schema:**

Add a new column and fill it:

```sql
ALTER TABLE
  resale_flat_prices_2017
ADD COLUMN
  transaction_date DATE;

UPDATE
  resale_flat_prices_2017
SET
  transaction_date = CONCAT(month, '-01')::DATE;
```

Extract the transaction year:

```sql
SELECT
  *,
  date_part('year', transaction_date) AS transaction_year
FROM
  resale_flat_prices_2017;
```

### 💬 Reflection

- What does the `::` mean in DuckDB/PostgreSQL? How does it relate to `CAST()`?
- Why is it important to standardize date formats when merging data from two different countries?

---

## 🎯 Wrap-Up

**Key Takeaways:**
1. **SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY** — this is the logical execution order. Understanding it prevents most beginner SQL errors.
2. Aggregate functions collapse rows — always pair them with `GROUP BY` for meaningful results.
3. `CASE` and `CAST` are your cleaning tools — categorise messy text and convert mistyped columns directly in your query.

**Next Steps:**
- Complete the [Assignment](./assignment.md) — SQL questions + a capstone challenge finding undervalued towns.
- Next lesson: Lesson 1.5 goes advanced — JOINs, window functions, and CTEs for complex multi-table analytics.
