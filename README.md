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


