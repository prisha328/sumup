--this SQL query contains all the data from leads_funnel table and in addition, has more calculated fields. Ideally, this calculated field should be created in Tableau, else we will have aggregation problem for calculated fields.
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

FROM staging.leads_funnel


