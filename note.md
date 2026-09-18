# Superstore Sales & Profit Analysis - Analysis Notes

## 1. Project Overview

This project analyzes sales, profit, discounts, shipping performance,
product sub-categories, and customer profitability using the Sample
Superstore dataset.

The main goal is to use SQL as the primary analysis engine and extract
business-relevant findings from the data. Python and pandas are used to
execute SQL queries and create visualizations, while the analytical
logic is performed in SQL.

## 2. Dataset

The dataset contains **9,994 order-line records** and **21 columns**.

| Metric | Result |
|---|---:|
| Rows | 9,994 |
| Distinct Customers | 793 |
| Distinct Products | 1,862 |
| Minimum Order Date | 2014-01-03 |
| Maximum Order Date | 2017-12-30 |

The dataset covers sales transactions from **2014 through 2017**.

## 3. Data Preparation

The original CSV file was loaded into SQLite and stored in an `orders`
table.

The main analytical fields use appropriate database types: `INTEGER` for
numeric IDs and quantities, `TEXT` for identifiers and categorical
fields, `DATE` for order and ship dates, and `NUMERIC` for sales,
discounts, and profit.

The original date values were converted into ISO-style dates before
loading the cleaned data into SQLite.

The final database contains **9,994 rows**.

## 4. Data Quality Checks

### Missing Values

A NULL check was performed for every column.

**Result:** all 21 columns contained **0 NULL values**.

### Duplicate Order Lines

Duplicate order lines were checked using the combination of `order_id`
and `product_id`.

The query identified **8 Order ID + Product ID combinations**, each
occurring twice.

No rows were removed because the duplicate check was performed for
profiling purposes, and the analysis did not independently establish
that these records were invalid.

## 5. SQL Analysis Approach

The analysis was completed through ten SQL questions covering dataset
profiling, NULL checks, duplicate detection, shipping delay,
region/category/sub-category profitability, top and bottom
sub-categories, discount bands, year-over-year sales, negative-profit
sub-categories, and customer lifetime profitability.

SQL techniques used include:

- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `LIMIT`
- `SUM()`
- `AVG()`
- `COUNT()`
- `COUNT(DISTINCT ...)`
- `CASE WHEN`
- `UNION ALL`
- `LAG()`
- SQLite date functions such as `julianday()`

Python was used with `pandas.read_sql()` to execute SQL queries and
create visualizations. Whole-table pandas `groupby()` operations were
not used as a replacement for SQL analysis.

# 6. Key Findings

## Shipping Performance

| Ship Mode | Average Days to Ship |
|---|---:|
| Same Day | 0.044 |
| First Class | 2.183 |
| Second Class | 3.238 |
| Standard Class | 5.007 |

Standard Class had the highest average shipping time at approximately
**5.01 days**, while Same Day orders averaged approximately **0.04
days**.

## Sub-Category Profitability

The five highest-profit sub-categories were:

| Sub-Category | Total Profit |
|---|---:|
| Copiers | $55,617.82 |
| Phones | $44,515.73 |
| Accessories | $41,936.64 |
| Paper | $34,053.57 |
| Binders | $30,221.76 |

The five lowest-profit sub-categories were:

| Sub-Category | Total Profit |
|---|---:|
| Tables | -$17,725.48 |
| Bookcases | -$3,472.56 |
| Supplies | -$1,189.10 |
| Fasteners | $949.52 |
| Machines | $3,384.76 |

Tables had the lowest total profit.

## Discount and Profitability

| Discount Band | Order Count | Average Profit | Total Profit |
|---|---:|---:|---:|
| 0% | 2,644 | $66.90 | $320,987.60 |
| 1–20% | 2,507 | $26.50 | $100,785.47 |
| 21–40% | 400 | -$77.86 | -$35,817.47 |
| 41%+ | 737 | -$106.71 | -$99,558.59 |

Higher discount bands were associated with lower observed profitability.
This is a descriptive relationship and does not establish that discount
level alone caused the profit differences.

## Yearly Sales Trend

| Year | Total Sales | YoY Change | YoY % |
|---|---:|---:|---:|
| 2014 | $484,247.50 | — | — |
| 2015 | $470,532.51 | -$13,714.99 | -2.83% |
| 2016 | $609,205.60 | +$138,673.09 | +29.47% |
| 2017 | $733,215.26 | +$124,009.66 | +20.36% |

Sales decreased by **2.83% in 2015**, followed by increases of **29.47%
in 2016** and **20.36% in 2017**.

## Negative-Profit Sub-Categories

| Sub-Category | Total Profit | Total Sales | Revenue Share |
|---|---:|---:|---:|
| Tables | -$17,725.48 | $206,965.53 | 9.01% |
| Bookcases | -$3,472.56 | $114,880.00 | 5.00% |
| Supplies | -$1,189.10 | $46,673.54 | 2.03% |

Together, these three sub-categories represented approximately **16.04%
of total revenue** while generating negative total profit.

# 7. Business Insights

## Insight 1 - Review High-Discount Transactions (Q7)

The 21–40% discount band generated **-$35,817.47** in total profit,
while the 41%+ band generated **-$99,558.59**. Their average profits
were also negative at **-$77.86** and **-$106.71**, respectively.

**Business implication:** High-discount transactions could be reviewed
by product, region, and customer segment to identify where discounts are
associated with weak margins. Discount policies can then be evaluated
using profitability or margin targets.

## Insight 2 - Investigate Tables, Bookcases, and Supplies (Q9)

Tables generated **-$17,725.48** in total profit, Bookcases generated
**-$3,472.56**, and Supplies generated **-$1,189.10**. Together, these
sub-categories represented approximately **16.04% of total revenue**.

**Business implication:** These sub-categories can be investigated at
product, region, and discount level to identify pricing, product-mix, or
other factors associated with the losses.

## Insight 3 - Monitor Strong Profit Contributors (Q6)

Copiers generated **$55,617.82** in total profit, followed by Phones at
**$44,515.73** and Accessories at **$41,936.64**.

**Business implication:** These sub-categories are important
contributors to observed profit and can be monitored further by region,
customer segment, and margin to understand where their performance is
strongest.

## Insight 4 - Sales Growth Accelerated After 2015 (Q8)

Sales declined by **2.83% in 2015**, then increased by **29.47% in
2016** and **20.36% in 2017**. Total sales reached **$733,215.26 in
2017**, compared with **$470,532.51 in 2015**.

**Business implication:** The growth period after 2015 can be
investigated by region, category, and customer segment to identify the
contributors to revenue growth and to check whether sales growth was
accompanied by healthy profitability.

# 8. Customer Profitability

The highest lifetime-profit customer in the analysis was Tamara Chand:

- Lifetime profit: **$8,981.32**
- Order count: **5**
- Average order value: **$3,810.44**

The top 10 customers were ranked by lifetime profit using SQL
aggregation.

## 9. Visualizations

The project includes three visualizations:

1. **Profit by Sub-Category** - compares total profit across
   sub-categories.
2. **Yearly Sales Trend** - shows annual sales and year-over-year
   changes from 2014 to 2017.
3. **Average Profit by Discount Band** - compares average profit
   across discount bands.

The visualizations were created from SQL query results using Python.

# 10. Conclusion

The analysis shows several important patterns in the Superstore dataset.
Sales increased substantially after 2015, reaching **$733,215.26 in
2017**. Profitability varied considerably across sub-categories and
discount levels. Tables, Bookcases, and Supplies generated negative
total profit while representing approximately **16.04% of total
revenue**, and higher discount bands were associated with negative
average and total profit.
