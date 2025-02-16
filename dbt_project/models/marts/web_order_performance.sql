WITH web_order AS (
    SELECT
       *
    FROM staging.web_order
),

channel AS (
    SELECT
       *
    FROM staging.channels
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



    -- Estimated Earnings (assuming POS Lite price = 249 EUR, also assuming a customer only ordered the POS lite at today's discounted price of 249 EUR and didn't add any extra items. Ideally, we should have earnings value in the table or at least be able to join it to another table that has earnings data )
    SUM(w.nb_of_poslite_items_ordered) * 249 AS earnings,

    -- Profit Calculation
    (SUM(w.nb_of_poslite_items_ordered) * 249) - SUM(w.total_spend_eur) AS profit



FROM web_order w
LEFT JOIN channel c ON c.campaign_id = w.campaign_id
GROUP BY 1,2,3,4,5,6,7,8
