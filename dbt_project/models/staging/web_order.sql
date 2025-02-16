SELECT
        -- Standardizing column names
        DATE(DATE) AS date,

        -- Handling NULL/unknown country codes. NULL could represent tracking issues. 
        CASE 
            WHEN COUNTRY_CODE IS NULL OR COUNTRY_CODE = 'unknown' THEN 'others'
            ELSE COUNTRY_CODE 
        END AS country_code,

        -- Standardizing campaign_id, handling NULLs, and removing decimals
        CASE 
            WHEN CAMPAIGN_ID IS NULL THEN 'others'
            ELSE CAST(CAST(FLOOR(CAST(CAMPAIGN_ID AS DOUBLE)) AS BIGINT) AS VARCHAR)
        END AS campaign_id,

        TOTAL_SPEND_EUR AS total_spend_eur,
        NB_OF_SESSIONS AS nb_of_sessions,
        NB_OF_SIGNUPS AS nb_of_signups,
        NB_OF_ORDERS AS nb_of_orders,
        NB_OF_POSLITE_ITEMS_ORDERED AS nb_of_poslite_items_ordered,
        NB_POSLITE_ITEMS_DISPATCHED AS nb_poslite_items_dispatched
    FROM web_orders
