SELECT ad_date, 
		campaign_id, 
		sum (spend) AS total_spend, 
		sum (impressions) AS total_impressions, 
		sum (clicks) AS total_clicks, 
		sum (value) AS total_value,
		round (sum(spend)::NUMERIC / sum(clicks)::NUMERIC, 2)  AS CPC,
		round ((sum(spend)::NUMERIC / sum(impressions)::NUMERIC) * 1000, 2) AS CPM,
		round ((sum(clicks)::NUMERIC / sum(impressions)::NUMERIC) * 100, 2) AS CTR,
		round (((sum(value)::NUMERIC - sum(spend)::NUMERIC) / sum(spend)::NUMERIC*100), 2) AS ROMI
FROM facebook_ads_basic_daily
WHERE clicks <> 0 and impressions <> 0
GROUP BY ad_date, campaign_id 
ORDER BY ad_date;