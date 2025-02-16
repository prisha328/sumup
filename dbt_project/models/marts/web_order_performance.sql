WITH web_order AS (
    SELECT
        -- Standardizing column names
        DATE(DATE) AS date,

        -- Handling NULL/unknown country codes
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
),

channel AS (
    SELECT
        CAMPAIGN_ID AS campaign_id,

        -- Standardizing campaign names by removing unnecessary spaces
        REPLACE(CAMPAIGN_NAME, ' ', '') AS campaign_name,

        -- Handling NULL values for budget category
        COALESCE(CAMPAIGN_PERIOD_BUDGET_CATEGORY, 'others') AS campaign_period_budget_category,

        -- Standardizing channel names
        COALESCE(REPLACE(CHANNEL_3, ' ', ''), 'others') AS channel_3,
        COALESCE(REPLACE(CHANNEL_4, '  ', ' '), 'others') AS channel_4,
        COALESCE(REPLACE(CHANNEL_5, '  ', ' '), 'others') AS channel_5
    FROM channels
)

SELECT 
    w.date,
    w.country_code,
    w.campaign_id, 
    COALESCE(c.campaign_name, 'unknown') AS campaign_name,
    COALESCE(c.campaign_period_budget_category, 'unknown') AS campaign_period_budget_category,
    COALESCE(c.channel_3, 'unknown') AS channel_3,
    COALESCE(c.channel_4, 'unknown') AS channel_4,
    COALESCE(c.channel_5, 'unknown') AS channel_5,

    -- Aggregated Metrics
    SUM(w.nb_of_signups) AS total_signups,
    SUM(w.nb_of_poslite_items_ordered) AS total_items_ordered,
    SUM(w.nb_of_orders) AS total_orders,
    SUM(w.total_spend_eur) AS total_spend_eur,
    SUM(w.nb_poslite_items_dispatched) AS total_items_dispatched,

    -- Conversion Rate (with zero handling)
    COALESCE(
        SUM(CAST(w.nb_of_signups AS DOUBLE)) / NULLIF(SUM(CAST(w.nb_of_sessions AS DOUBLE)), 0), 
        0
    ) AS cvr_signup,

    -- Items per order (handling zero orders)
    COALESCE(SUM(w.nb_of_poslite_items_ordered) / NULLIF(SUM(w.nb_of_orders), 0), 0) AS items_per_order,

    -- Cost Per Signup & Order (handling division by zero)
    CASE 
        WHEN SUM(w.nb_of_signups) > 0 
        THEN SUM(w.total_spend_eur) / SUM(w.nb_of_signups) 
        ELSE NULL 
    END AS cost_per_signup,

    CASE 
        WHEN SUM(w.nb_of_orders) > 0 
        THEN SUM(w.total_spend_eur) / SUM(w.nb_of_orders) 
        ELSE NULL 
    END AS cost_per_order,

    -- Estimated Earnings (assuming POS Lite price = 249 EUR, also assuming a customer only ordered the POS lite at today's discounted price of 249 EUR and didn't add any extra items. Ideally, we should have earnings value in the table or at least be able to join it to another table that has earnings data )
    SUM(w.nb_of_poslite_items_ordered) * 249 AS earnings,

    -- Profit Calculation
    (SUM(w.nb_of_poslite_items_ordered) * 249) - SUM(w.total_spend_eur) AS profit,

    -- Return on Ad Spend (ROAS) (handling zero spend)
    CASE 
        WHEN SUM(w.total_spend_eur) > 0 
        THEN ((SUM(w.nb_of_poslite_items_ordered) * 249) / SUM(w.total_spend_eur)) * 100 
        ELSE NULL 
    END AS ROAS,

    -- Order Fulfillment Rate (handling division by zero)
    CASE 
        WHEN SUM(w.nb_of_poslite_items_ordered) > 0 
        THEN SUM(w.nb_poslite_items_dispatched) / SUM(w.nb_of_poslite_items_ordered) 
        ELSE NULL 
    END AS order_fulfillment_rate

FROM web_order w
LEFT JOIN channel c ON c.campaign_id = w.campaign_id
GROUP BY 1,2,3,4,5,6,7,8
