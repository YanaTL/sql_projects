# Marketing Ads Performance Analysis

SQL analysis of Facebook Ads and Google Ads campaign performance, including key marketing metrics calculation and month-over-month trend tracking.

## Project Files

| File                                  | Description                                                              |
|---------------------------------------|--------------------------------------------------------------------------|
| [facebook_marketing_ads.sql]( https://github.com/YanaTL/sql_projects/blob/main/marketing_analysis/facebook_marketing_ads.sql)       | Basic Facebook Ads analysis: metrics by day and campaign                 |
| [facebook_google_marketing_ads.sql](https://github.com/YanaTL/sql_projects/blob/main/marketing_analysis/facebook_google_marketing_ads.sql)| Combined Facebook + Google Ads report                                    |
| [facebook_google_marketing_ads_2.sql](https://github.com/YanaTL/sql_projects/blob/main/marketing_analysis/facebook_google_marketing_ads_2.sql) | Extended analysis: UTM parameters, monthly aggregation, trend tracking   |

---

## SQL Functions and Techniques Used
1. Aggregation and Grouping:`SUM()`, `ROUND()`,`GROUP BY`
2. Data Joining:`INNER JOIN`, `UNION` 
3. Nested CTEs (Common Table Expressions)
4. NULL and Empty Value Handling:`COALESCE(field, 0)`, `NULLIF(value, 0)` 
5. Conditional Logic:`CASE WHEN` 
6. Date Handling: `DATE_TRUNC('month', ad_date)` 
7. UTM Parameter Parsing: `SUBSTRING(url_parameters FROM 'utm_campaign=([^&]+)')`, `LOWER()` 
8. Window Functions: `LAG() OVER (PARTITION BY utm_campaign ORDER BY ad_month)`

## Calculated Metrics

| Metric                | Description                                    |
|-----------------------|------------------------------------------------|
| **CTR**               | Ad click-through rate, %                       |
| **CPC**               | Cost per click                                 |
| **CPM**               | Cost per 1,000 impressions                     |
| **ROMI**              | Return on marketing investment, %              |
| **CPM_diff_percent**  | CPM change compared to the previous month      |
| **CTR_diff_percent**  | CTR change compared to the previous month      |
| **ROMI_diff_percent** | ROMI change compared to the previous month     |

---

## Use Cases
### 1. Ad Budget Optimization
Comparing CPC and CPM between Facebook and Google Ads helps identify which platform delivers cheaper traffic for a given campaign, enabling budget reallocation toward the more cost-effective channel.
### 2. Campaign ROI Evaluation (ROMI)
ROMI broken down by campaign and ad set reveals which ones actually generate revenue. Campaigns with negative ROMI are candidates for pausing or optimization.
### 3. Performance Trend Analysis
Monthly dynamics (`CPM_diff_percent`, `CTR_diff_percent`, `ROMI_diff_percent`) help detect seasonality, audience fatigue, or the positive impact of creative and targeting changes.
### 4. UTM Attribution
Breakdown by `utm_campaign` allows matching ad spend with actual UTM tags in analytics platforms (Google Analytics, Mixpanel), which is critical for multi-touch attribution.
### 5. Dashboards and Reporting
Query results are ready to load into BI tools (Tableau, Looker Studio, Power BI) for building automated marketing dashboards without additional transformation.
### 6. Ad Set A/B Testing
Comparing CTR and ROMI across `adset_name` within a single campaign helps identify the most effective audiences and creative approaches.
