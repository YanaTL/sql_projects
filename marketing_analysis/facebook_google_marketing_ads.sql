WITH clients_information AS (
WITH facebook_information AS (
SELECT fabd.ad_date,
		'Facebook Ads' AS media_source,
		fc.campaign_name,
		fa.adset_name,
		fabd.spend,
		fabd.impressions,
		fabd.reach,
		fabd.clicks,
		fabd.leads,
		fabd.value 
FROM public.facebook_ads_basic_daily fabd
INNER JOIN public.facebook_campaign fc ON fc.campaign_id = fabd.campaign_id
INNER JOIN public.facebook_adset fa ON fa.adset_id = fabd.adset_id
 )
 SELECT ad_date,
 		media_source,
		campaign_name,
		adset_name,
		spend,
		impressions,
		reach,
		clicks,
		leads,
		value 
FROM facebook_information
UNION 
SELECT ad_date,
 		'Google Ads' AS media_source,
		campaign_name,
		adset_name,
		spend,
		impressions,
		reach,
		clicks,
		leads,
		value 
FROM public.google_ads_basic_daily gabd
)
 SELECT ad_date,
        media_source,
		campaign_name,
		adset_name,
		sum (spend) AS total_spend,
		sum (impressions) AS total_impressions,
		sum (clicks) AS total_clicks,
		sum (value) AS total_value 
 FROM clients_information
 GROUP BY ad_date, media_source, campaign_name, adset_name
 ORDER BY ad_date;
 