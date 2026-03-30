# Marketing Ads Performance Analysis

SQL analysis of Facebook Ads and Google Ads campaign performance, including key marketing metrics calculation and month-over-month trend tracking.

---

## Project Files

| File                                  | Description                                                              |
|---------------------------------------|--------------------------------------------------------------------------|
| `facebook_marketing_ads.sql`          | Basic Facebook Ads analysis: metrics by day and campaign                 |
| `facebook_google_marketing_ads.sql`   | Combined Facebook + Google Ads report                                    |
| `facebook_google_marketing_ads_2.sql` | Extended analysis: UTM parameters, monthly aggregation, trend tracking   |

---

## SQL Functions and Techniques Used

### Aggregation and Grouping
- `SUM()` — summing spend, impressions, clicks, and conversions across groups
- `ROUND()` — rounding metric results to 2 decimal places
- `GROUP BY` — aggregation by date, campaign, ad set, and UTM

### Data Joining
- `INNER JOIN` — joining campaign and ad set tables with daily statistics
- `UNION` — combining Facebook and Google Ads data into a single dataset

### Nested CTEs (Common Table Expressions)
Three-level nesting with `WITH`:
1. Parsing data per platform
2. Merging platforms and cleaning data
3. Calculating metrics and month-over-month comparison

### NULL and Empty Value Handling
- `COALESCE(field, 0)` — replacing `NULL` with zero for correct calculations
- `NULLIF(value, 0)` — division-by-zero protection for percentage change calculations

### Conditional Logic
- `CASE WHEN` — computing metrics only when denominators are non-zero; cleaning `'nan'` values in UTM fields

### Date Handling
- `DATE_TRUNC('month', ad_date)` — aggregating daily data to a monthly granularity

### UTM Parameter Parsing
- `SUBSTRING(url_parameters FROM 'utm_campaign=([^&]+)')` — extracting `utm_campaign` value from a URL string using a regular expression
- `LOWER()` — normalizing values to lowercase

### Window Functions
- `LAG() OVER (PARTITION BY utm_campaign ORDER BY ad_month)` — retrieving the previous month's metric value for trend calculation

---

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

---

## Tech Stack

- **PostgreSQL** (syntax: `::NUMERIC`, `SUBSTRING ... FROM`, `date_trunc`)
- Compatible with any ANSI SQL database with minimal adaptation
