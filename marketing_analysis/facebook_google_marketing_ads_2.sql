WITH all_calculation AS(
WITH clients_data AS (
WITH facebook_inform AS (
SELECT  date_trunc('month', fabd.ad_date) AS ad_month,
		fc.campaign_name,
		fa.adset_name,
		COALESCE (fabd.spend, 0) AS new_spend,
		COALESCE (fabd.impressions, 0)  AS new_impressions,
		COALESCE (fabd.reach, 0) AS new_reach,
		COALESCE (fabd.clicks, 0) AS new_clicks,
		COALESCE (fabd.leads, 0) AS new_leads,
		COALESCE (fabd.value, 0) AS new_value,
		fabd.url_parameters 
FROM public.facebook_ads_basic_daily fabd
INNER JOIN public.facebook_campaign fc ON fc.campaign_id = fabd.campaign_id
INNER JOIN public.facebook_adset fa ON fa.adset_id = fabd.adset_id
 )
 SELECT ad_month,
 		campaign_name,
		adset_name,
		new_spend,
		new_impressions,
		new_reach,
		new_clicks,
		new_leads,
		new_value,
		url_parameters
FROM facebook_inform
UNION 
SELECT  date_trunc('month', ad_date) AS ad_month,
		campaign_name,
		adset_name,
		COALESCE (spend, 0) AS new_spend,
		COALESCE (impressions, 0) AS new_impressions,
		COALESCE (reach, 0) AS new_reach,
		COALESCE (clicks, 0) AS new_clicks,
		COALESCE (leads, 0) AS new_leads,
		COALESCE (value, 0) AS new_value,
		url_parameters
FROM public.google_ads_basic_daily gabd
)
 SELECT ad_month,
		campaign_name,
		adset_name,
		CASE
        WHEN LOWER(SUBSTRING(url_parameters FROM 'utm_campaign=([^&]+)')) = 'nan' THEN NULL
        ELSE LOWER(SUBSTRING(url_parameters FROM 'utm_campaign=([^&]+)'))
        END AS utm_campaign,
        sum (new_spend) AS total_spend,
        sum (new_impressions) AS total_impressions,
        sum (new_clicks) AS total_clicks,
        sum (new_value) AS total_value,
        CASE
        WHEN SUM(new_impressions) > 0 THEN round (SUM(new_clicks) * 1.0 / SUM(new_impressions) * 100, 2)
        ELSE 0
    END AS CTR,
    CASE
        WHEN SUM(new_clicks) > 0 THEN  round (SUM(new_spend) * 1.0 / SUM(new_clicks), 2)
        ELSE 0
    END AS CPC,
    CASE
        WHEN SUM(new_impressions) > 0 THEN round (SUM(new_spend) * 1.0 / SUM(new_impressions) * 1000, 2)
        ELSE 0
    END AS CPM,
    CASE
        WHEN SUM(new_spend) > 0 THEN round (SUM(new_value) * 1.0 / SUM(new_spend) * 100, 2)
        ELSE 0
    END AS ROMI   	
 FROM clients_data
 GROUP BY ad_month, campaign_name, adset_name, utm_campaign
 )
 SELECT ad_month,
		campaign_name,
		adset_name,
		utm_campaign,
		total_spend,
		total_impressions,
		total_clicks,
		total_value,
		CTR,
		CPC,
		CPM,
		ROMI,
		round ((CPM - LAG(CPM) OVER (PARTITION BY utm_campaign ORDER BY ad_month)) / NULLIF(LAG(CPM) OVER (PARTITION BY utm_campaign ORDER BY ad_month), 0) * 100, 2)  AS CPM_diff_percent,
        -- CPM percentage change from the previous month
        round ((CTR - LAG(CTR) OVER (PARTITION BY utm_campaign ORDER BY ad_month)) / NULLIF(LAG(CTR) OVER (PARTITION BY utm_campaign ORDER BY ad_month), 0) * 100, 2) AS CTR_diff_percent,
        -- CTR percentage change from the previous month
        round ((ROMI - LAG(ROMI) OVER (PARTITION BY utm_campaign ORDER BY ad_month)) / NULLIF(LAG(ROMI) OVER (PARTITION BY utm_campaign ORDER BY ad_month), 0) * 100, 2) AS ROMI_diff_percent,
		-- ROMI percentage change from the previous month
 FROM all_calculation
 ORDER BY ad_month;