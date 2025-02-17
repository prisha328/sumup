# SumUp take home assignment
Staging table: WEB_ORDERS

I created three staging tables based on the provided sheets, with the first one focusing on web orders. During data cleaning, I identified and addressed the following issues:
* Missing Dates (DATE IS NULL): I did not replace these with any values, as adding a string in a date column can cause issues in visualization tools like Tableau. The presence of NULL values in the date column likely indicates tracking issues, as a complete date is essential for accurate analysis.
* Missing or Unknown Country Codes (COUNTRY_CODE IS NULL or "unknown"): To simplify the data, I grouped both NULL and "unknown" values under a single category labeled "Others". While an "unknown" country can be acceptable, NULL values might point to tracking gaps.
* Issues in the CAMPAIGN_ID Column:
    * NULL values: I replaced these with "Others", as campaign tracking should ideally be complete.
    * Incorrect Format: Some CAMPAIGN_IDs were in FLOAT format (e.g., 120203990006170698.000000). I removed the decimal part and converted them into strings to ensure consistency.
    * Interpreting NULL CAMPAIGN_IDs: Initially, I considered that these orders might come from organic traffic, but since they include spend data, they must be from paid campaigns. This suggests that the NULL values are likely due to tracking errors.
 
Staging table: CHANNELS

The second staging table focuses on detailed campaign information and required data cleaning due to the following issues:
* Inconsistent CAMPAIGN_ID Mappings: In some cases, a single CAMPAIGN_ID was associated with two different campaign names, likely due to formatting inconsistencies. One version contained unnecessary spaces, which I removed to standardize the names.
* Missing or Unknown Values in CAMPAIGN_PERIOD_BUDGET_CATEGORY: NULL and "unknown" values were grouped under "Others" to ensure consistency.
* Inconsistent Spacing in CHANNEL_3, CHANNEL_4, and CHANNEL_5: Some values contained single and double spaces, which I cleaned using the REPLACE function to maintain uniform formatting.

Staging table: LEADS_FUNNEL

The final staging table focuses on leads funnel data and required similar cleaning steps as the other tables:
* CAMPAIGN_ID Issues: The same issue observed in the web_orders table was present here—some CAMPAIGN_IDs had inconsistent formatting, which I corrected.
* CAMPAIGN_NAME Cleaning:
    * NULL values were grouped with "unknown" under "Others" for consistency.
    * Some campaign names had extra spaces, leading to duplicate entries (e.g., fb_uk_pos-lite_prospecting_landing_promo vs. fb_uk_ pos-lite_prospecting_landing_promo). I removed these unnecessary spaces to standardize campaign names.
* PRODUCT Column Issues: This had the same formatting problem as CAMPAIGN_NAME, with inconsistent spacing. I cleaned it to ensure uniform naming.
* Channel Columns (CHANNEL_3, CHANNEL_4, CHANNEL_5):
    * NULL values were replaced with "Others" to avoid gaps in the data.
    * Unnecessary spaces within text values were removed to maintain consistency.

Data marts: web_order_performance

I created three data mart tables, the first being web_order_performance, which combines data from the web_orders and channels tables using a LEFT JOIN on campaign_id. This allows us to enrich the web order data with detailed campaign information from the channels table. However, I noticed that some campaign_ids in the web_orders table are missing from the channels table. This discrepancy should be investigated to understand why certain campaigns are not recorded in the channels dataset.

In addition to the existing metrics in the web_orders table, I introduced an earnings metric, assuming a flat rate of €249 per POS Lite unit based on the current website pricing. This earnings estimate was then used to calculate profitability.
For visualization, I used Tableau, where I created calculated fields such as conversion rates (sessions to signups, sessions to orders), ROAS, and other key performance indicators to better analyze web order performance. The ROAS calculation was kept straightforward for clarity.
To provide a comprehensive view, I visualized key metrics both as total values and daily trends. While analyzing the data, I observed unusual peaks on certain days. While traffic spikes are expected during CRM-driven campaigns or seasonal promotions, some of these peaks appeared abnormal. I would investigate further to determine the cause of these inconsistencies.

Data marts: leads_funnel_ad_performance

This table includes key marketing metrics from the leads_funnel table, such as total impressions, total clicks, total spend, and total leads. These metrics help track KPIs like impressions, click-through rates (CTR), conversion rates (impressions to clicks and clicks to leads), cost per click (CPC), earnings, and ROAS.
Once clicks are converted into leads, the sales team takes over the process. To support their analysis, I created a second data mart focused on lead performance, specifically tailored for sales insights.
During data visualization, I observed that performance was particularly strong in May. However, I identified abnormally high spikes on May 16th and May 29th, likely indicating a tracking issue. The campaigns  fb_es_landing_prospecting_pos-lite_poslite-cr_bau_alwayson and fb_es_landing_prospecting_pos-lite_poslite-cr_bau_alwayson appear to be affected.

Data marts: leads_funnel_leads_performance

This table contains sales-related metrics from the leads_funnel table, including total leads, total fake leads, total SQLs, total meetings conducted, total signed leads, and total POS Lite deals.
Using these metrics, I created calculated fields in Tableau to analyze conversion rates at each stage of the funnel. This helps identify where potential customers are dropping off, allowing the sales team to refine their strategy and improve conversion rates.

