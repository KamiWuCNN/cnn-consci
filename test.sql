SELECT ex_group AS GROUPS, CONVERT_TIMEZONE('UTC', 'America/New_York', HOURS) AS HOURS, COUNT(DISTINCT ZION_ANON_ID) AS TOTAL_USER
FROM (SELECT ZION_ANON_ID, 
CASE WHEN parse_json(TRAITS):variant_id::string LIKE '%20921136098%' THEN 'control'
WHEN parse_json(TRAITS):variant_id::string LIKE '%20959060667%' THEN 'variant_1'
WHEN parse_json(TRAITS):variant_id::string LIKE '%20872674603%' THEN 'variant_2'
WHEN parse_json(TRAITS):variant_id::string LIKE '%20949841289%' THEN 'variant_3' END AS ex_group, 
DATE_TRUNC('hour', timestamp) AS HOURS
FROM ZION_CLEANED.SNOWPLOW.STG_SNOWPLOW__PAGEVIEW
WHERE timestamp BETWEEN CONVERT_TIMEZONE('America/New_York', 'UTC', '2021-12-09 00:00:00') AND DATEADD(Day, 1, current_timestamp)
AND parse_json(TRAITS):experiment_id::string LIKE '%20909855388%'
GROUP BY ZION_ANON_ID, ex_group, HOURS)
GROUP BY ex_group, HOURS
