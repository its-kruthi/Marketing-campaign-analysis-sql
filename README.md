# Marketing Campaign Performance & ROI Analysis

## Project Overview
Analysis of 200,000 marketing campaigns across 6 channels (Facebook, Website, Google Ads, Email, YouTube, Instagram) for a D2C company, using SQL for business analysis and Python/Excel/Power BI for reporting.

 ## Dataset sourced from Kaggle: [[link](https://www.kaggle.com/datasets/manishabhatt22/marketing-campaign-performance-dataset)]. Not included in repo due to size — see data_cleaning.py for the full cleaning pipeline ##
 
## Business Context
Simulates supporting a Growth Marketing team to answer:
- Which channels/campaign types perform best?
- Which campaigns waste budget?
- Which audience segments convert best?
- Where should next quarter's budget go?

## Dataset
- Source: Kaggle Marketing Campaign Performance Dataset (adapted for Indian context)
- 200,000 rows, 16 columns

## Tech Stack
- **Python (Pandas)**: data cleaning, date standardization
- **MySQL**: database design, LOAD DATA INFILE, 20+ SQL queries
- **Excel**: pivot tables, charts
- **Power BI**: interactive dashboard (KPI card, bar chart, trend line, slicer)

## SQL Concepts Used
SELECT, WHERE, GROUP BY, HAVING, CASE WHEN, subqueries, CTEs, 
Window Functions (RANK, ROW_NUMBER, DENSE_RANK), running totals, Views

## Key Business Questions Answered
1. Which channel delivers the best ROI?
2. Which campaign type is most cost-efficient?
3. Which locations underperform despite high spend?
4. Does engagement drive conversion?
5. Which customer segment is most valuable?
6. Does campaign duration affect performance?
7. What's the month-over-month ROI trend?
8. What do the worst-performing campaigns have in common?

## Key Insights
- Channel-level ROI is nearly identical (4.99–5.02) across all 6 channels — 
  no single channel dominates.
- Engagement Score shows no meaningful correlation with Conversion Rate.
- No seasonal trend — ROI stayed flat (4.98–5.02) across all 12 months.
- Real variance exists at the individual campaign level, not category level — 
  bottom-10 campaigns cluster around specific company-channel pairs.

## Recommendation
Category-level budget reallocation is not supported by this data. Recommended 
approach: audit and pause bottom-decile campaigns individually, rather than 
shifting budget between channels or locations.

## Author
[KRUTHIKA Y N] 
