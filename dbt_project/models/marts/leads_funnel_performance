WITH data AS (
    SELECT 
        DATE(DATE) AS date, 
        CURRENCY AS currency,
        COUNTRY_CODE AS country_code,
        
        -- Standardize CAMPAIGN_ID
        CASE 
            WHEN CAMPAIGN_ID IS NULL THEN 'others' 
            ELSE CAST(CAST(FLOOR(CAST(CAMPAIGN_ID AS DOUBLE)) AS BIGINT) AS VARCHAR)
        END AS campaign_id,

        -- Standardize CAMPAIGN_NAME
        CASE 
            WHEN CAMPAIGN_NAME IS NULL OR CAMPAIGN_NAME = 'unknown' THEN 'others'  
            ELSE REPLACE(CAMPAIGN_NAME, ' ', '')  
        END AS campaign_name,

        -- Standardize PRODUCT
        CASE 
            WHEN PRODUCT IS NULL OR PRODUCT = 'unknown' THEN 'others' 
            ELSE REPLACE(PRODUCT, ' ', '-')  
        END AS product,

        -- Standardize CHANNEL_3
        CASE 
            WHEN CHANNEL_3 IS NULL THEN 'others' 
            ELSE CHANNEL_3 
        END AS channel_3,

        -- Clean CHANNEL_4
        CASE 
            WHEN CHANNEL_4 IS NULL THEN 'others' 
            ELSE REPLACE(REPLACE(REPLACE(CHANNEL_4, 
                        'shopp ing', 'shopping'), 
                        'pro specting', 'prospecting'), 
                        'prosp ecting', 'prospecting') 
        END AS channel_4,

        -- Clean CHANNEL_5
        CASE 
            WHEN CHANNEL_5 IS NULL THEN 'others' 
            ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CHANNEL_5, 
                        'shopp ing', 'shopping'), 
                        'pro specting', 'prospecting'),
                        'p rospecting', 'prospecting'),
                        'prospe cting', 'prospecting'),
                        'prosp ecting', 'prospecting') 
        END AS channel_5 ,
		
		TOTAL_IMPRESSIONS AS total_impressions,
		TOTAL_CLICKS AS total_clicks,
		TOTAL_SPEND AS total_spend,
		TOTAL_LEADS AS total_leads,
		TOTAL_FAKE_LEADS AS total_fake_leads,
		TOTAL_SQLS AS total_sqls,
		TOTAL_MEETING_DONE AS total_meeting_done,
		TOTAL_SIGNED_LEADS AS total_signed_leads,
		TOTAL_POS_LITE_DEALS AS total_pos_lite_deals
    FROM leads_funnel
    ORDER BY DATE ASC
)

SELECT 
    *,
    -- Click-Through Rate (CTR) = Clicks / Impressions
    CASE 
        WHEN total_impressions > 0 THEN (total_clicks * 1.0 / total_impressions) --multiplying the nominator by 1.0 instead of using the CAST function here
        ELSE 0 
    END AS ctr,

    -- Cost Per Click (CPC) = Total Spend / Clicks
    CASE 
        WHEN total_clicks > 0 THEN (total_spend * 1.0 / total_clicks)
        ELSE 0 
    END AS cpc,

    -- Conversion Rate (CVR) from Clicks to Leads = Leads / Clicks
    CASE 
        WHEN total_clicks > 0 THEN (total_leads * 1.0 / total_clicks) 
        ELSE 0 
    END AS cvr_clicks_to_leads,

    -- Lead Quality Rate = (Leads - Fake Leads) / Leads
    CASE 
        WHEN total_leads > 0 THEN ((total_leads - total_fake_leads) * 1.0 / total_leads) 
        ELSE 0 
    END AS lead_quality_rate,

    -- SQL Conversion Rate = SQLs / Leads
    CASE 
        WHEN total_leads > 0 THEN (total_sqls * 1.0 / total_leads) 
        ELSE 0 
    END AS sql_conversion_rate,

    -- Meeting Rate = Meetings Done / SQLs
    CASE 
        WHEN total_sqls > 0 THEN (total_meeting_done * 1.0 / total_sqls) 
        ELSE 0 
    END AS meeting_conversion_rate,

    -- Signed Lead Rate = Signed Leads / Meetings Done
    CASE 
        WHEN total_meeting_done > 0 THEN (total_signed_leads * 1.0 / total_meeting_done) 
        ELSE 0 
    END AS signed_lead_rate,

    -- POS Lite Deals Rate = POS Lite Deals / Signed Leads
    CASE 
        WHEN total_signed_leads > 0 THEN (total_pos_lite_deals * 1.0 / total_signed_leads) 
        ELSE 0 
    END AS pos_lite_deals_rate

FROM data


