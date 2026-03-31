# 🎓 Lesson 1.4: SQL Basic — DML — Instructor Guide

## Session Overview

| Item | Detail |
|------|--------|
| **Duration** | 3 hours |
| **Format** | Flipped Classroom + Hands-On SQL in DbGate |
| **Prerequisites** | SQL DDL (Lesson 1.3); able to create tables; `unit-1-4.db` downloaded |
| **Tools** | DuckDB + DbGate |
| **Dataset** | Singapore HDB Resale Flat Prices 2017 (`unit-1-4.db`) — table: `resale_flat_prices_2017` |

### Agenda

| Time | Section | Focus |
|------|---------|-------|
| 0:00 – 0:55 | Part 1: Selection, Filtering & Sorting | SELECT, WHERE, ORDER BY |
| 0:55 – 1:00 | Break | — |
| 1:00 – 1:55 | Part 2: Aggregates & Grouping | COUNT, SUM, AVG; GROUP BY; WHERE vs. HAVING |
| 1:55 – 2:00 | Break | — |
| 2:00 – 2:55 | Part 3: Advanced Logic & Cleaning | CASE statements; CAST; date extraction |
| 2:55 – 3:00 | Wrap-Up | Key Takeaways & Post-Class Assignment Briefing |

> **Before class:** Have students run `SELECT * FROM resale_flat_prices_2017 LIMIT 10;` to confirm the database is connected.

---

## 🏃 Part 1: Selection, Filtering & Sorting (55 min)

### 🎯 Learning Objective
Retrieve specific rows and columns from a database using `SELECT`, `WHERE`, and `ORDER BY` with logical and comparison operators.

### 📖 Theory Recap (10 min)

**Analogy:** Querying a database is like having a conversation with your data.
- `SELECT` says: *"Give me these columns."*
- `FROM` says: *"...from this table."*
- `WHERE` says: *"...but only rows matching this condition."*
- `ORDER BY` says: *"...sorted this way."*

Think of it as narrowing a spotlight — `WHERE` shrinks the pool of rows *before* `ORDER BY` arranges them.

**Operator cheat sheet:**
- `=` `!=` `>` `<` `>=` `<=` — standard comparison
- `BETWEEN a AND b` — inclusive range
- `IN ('a', 'b', 'c')` — match any in a list
- `LIKE 'ANG%'` — pattern match (% is wildcard)
- `AND` `OR` `NOT` — combine conditions

### 🛠️ Hands-On Activity: "The Real Estate Explorer" (35 min)

1. Basic retrieval:
```sql
SELECT town, flat_type, resale_price FROM resale_flat_prices_2017 LIMIT 20;
```

2. Filter with WHERE:
```sql
SELECT * FROM resale_flat_prices_2017
WHERE town = 'ANG MO KIO' AND resale_price > 500000;
```

3. Sort results:
```sql
SELECT town, flat_type, resale_price
FROM resale_flat_prices_2017
WHERE flat_type = '4 ROOM'
ORDER BY resale_price DESC
LIMIT 10;
```

4. Calculate a new column:
```sql
SELECT town, floor_area_sqm, resale_price,
       ROUND(resale_price / floor_area_sqm, 2) AS price_per_sqm
FROM resale_flat_prices_2017
ORDER BY price_per_sqm DESC
LIMIT 10;
```

**Discussion Questions:**
- "What towns appear most often in the top 10 most expensive per sqm?"
- "What's the difference between `WHERE resale_price BETWEEN 400000 AND 500000` and `WHERE resale_price >= 400000 AND resale_price <= 500000`?"

### 💬 Q&A & Reflection (10 min)

- **Common Misconception:** "I can use `WHERE` with column aliases I just defined in `SELECT`." → No — `WHERE` is evaluated *before* `SELECT`. Use the full expression or a subquery.
- **Business Case:** PropertyGuru and 99.co run exactly these types of queries to power their real-time property search filters — every filter a user clicks generates a dynamically-built `WHERE` clause.

---

## 🏃 Part 2: Aggregates & Grouping (55 min)

### 🎯 Learning Objective
Summarise datasets using aggregate functions with `GROUP BY`, and correctly apply `WHERE` (pre-grouping) vs. `HAVING` (post-grouping) filters.

### 📖 Theory Recap (10 min)

**Analogy:** Imagine counting votes in an election.
- You first *collect* all votes (the raw rows).
- Then you *sort* them by party (GROUP BY).
- Then you *count* each pile (aggregate function).
- `WHERE` removes individual votes *before* sorting. `HAVING` filters parties *after* counting.

| Function | Returns |
|----------|---------|
| `COUNT(*)` | Number of rows |
| `SUM(col)` | Total of a numeric column |
| `AVG(col)` | Mean value |
| `MIN(col)` | Smallest value |
| `MAX(col)` | Largest value |

**The key rule:** Any column in `SELECT` that isn't inside an aggregate function *must* appear in `GROUP BY`.

### 🛠️ Hands-On Activity: "The Market Report" (35 min)

1. Count transactions per town:
```sql
SELECT town, COUNT(*) AS num_transactions
FROM resale_flat_prices_2017
GROUP BY town
ORDER BY num_transactions DESC;
```

2. Average resale price by flat type:
```sql
SELECT flat_type, ROUND(AVG(resale_price), 0) AS avg_price
FROM resale_flat_prices_2017
GROUP BY flat_type
ORDER BY avg_price DESC;
```

3. WHERE vs. HAVING:
```sql
-- Towns with more than 500 transactions for 4 ROOM flats only
SELECT town, COUNT(*) AS transactions
FROM resale_flat_prices_2017
WHERE flat_type = '4 ROOM'           -- filter rows BEFORE grouping
GROUP BY town
HAVING COUNT(*) > 500                -- filter groups AFTER counting
ORDER BY transactions DESC;
```

**Discussion Questions:**
- "Why can't you write `HAVING flat_type = '4 ROOM'`?"
- "What does `GROUP BY town, flat_type` give you vs. `GROUP BY town` alone?"

### 💬 Q&A & Reflection (10 min)

- **Common Misconception:** "`HAVING` is just `WHERE` for aggregates." → Conceptually yes, but mechanically different — `WHERE` runs before grouping, `HAVING` after. Mixing them up produces errors or wrong results.
- **Business Case:** Singapore's HDB uses aggregate queries exactly like this to publish quarterly housing market reports — average resale prices by town, flat type, and storey range.

---

## 🏃 Part 3: Advanced Logic & Data Cleaning (55 min)

### 🎯 Learning Objective
Transform data using `CASE` statements for conditional categorisation and `CAST` for type conversion including date extraction.

### 📖 Theory Recap (10 min)

**Analogy:** `CASE` is SQL's `if/elif/else`. `CAST` is SQL's translator — it converts data from one type to another (e.g., text → number, text → date).

**CASE syntax:**
```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE default_result
END AS alias
```

**CAST syntax:**
```sql
CAST(column AS target_type)
-- or DuckDB shorthand:
column::DATE
column::INTEGER
```

### 🛠️ Hands-On Activity: "The Property Classifier" (35 min)

1. Categorise flats by price bracket:
```sql
SELECT town, flat_type, resale_price,
    CASE
        WHEN resale_price < 300000 THEN 'Budget'
        WHEN resale_price BETWEEN 300000 AND 500000 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS price_category
FROM resale_flat_prices_2017;
```

2. Convert text month to date and extract year:
```sql
SELECT month,
    CAST(month || '-01' AS DATE) AS first_of_month,
    YEAR(CAST(month || '-01' AS DATE)) AS year,
    MONTH(CAST(month || '-01' AS DATE)) AS month_num
FROM resale_flat_prices_2017
LIMIT 10;
```

3. Combine with aggregation — count by category and quarter:
```sql
SELECT
    CASE
        WHEN MONTH(CAST(month || '-01' AS DATE)) <= 3 THEN 'Q1'
        WHEN MONTH(CAST(month || '-01' AS DATE)) <= 6 THEN 'Q2'
        WHEN MONTH(CAST(month || '-01' AS DATE)) <= 9 THEN 'Q3'
        ELSE 'Q4'
    END AS quarter,
    COUNT(*) AS transactions,
    ROUND(AVG(resale_price), 0) AS avg_price
FROM resale_flat_prices_2017
GROUP BY quarter
ORDER BY quarter;
```

**Discussion Questions:**
- "What happens if you forget `ELSE` in a `CASE` statement?"
- "Why does `CAST(month AS DATE)` fail for the raw `month` column?"

### 💬 Q&A & Reflection (10 min)

- **Common Misconception:** "`CASE` can only be used in `SELECT`." → You can use `CASE` in `WHERE`, `ORDER BY`, and even inside aggregate functions: `SUM(CASE WHEN town = 'BISHAN' THEN 1 ELSE 0 END)`.
- **Business Case:** Banks use `CASE` statements to classify loan applications into risk tiers based on income, credit score, and loan-to-value ratio — producing real-time lending decisions at scale.

---

## 🎯 Wrap-Up (5 min)

### Key Takeaways
1. **SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY** — this is the logical execution order. Understanding it prevents 80% of beginner SQL errors.
2. **Aggregate functions collapse rows** — always pair them with `GROUP BY` for meaningful results.
3. **`CASE` and `CAST` are your cleaning tools** — categorise messy text and convert mistyped columns directly in your query.

### Next Steps
- **Post-Class:** Complete [The Property Analyst](./post-class.md) — 4 SQL questions + a capstone challenge finding undervalued towns (45–60 min).
- **Next Lesson:** Lesson 1.5 goes advanced — JOINs, window functions, and CTEs for complex multi-table analytics.
