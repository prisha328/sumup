# SumUp take home assignment
Staging table: WEB_ORDERS

I created three staging tables based on the provided sheets, with the first one focusing on web orders. During data cleaning, I identified and addressed the following issues:
* Missing Dates (DATE IS NULL): I did not replace these with any values, as adding a string in a date column can cause issues in visualization tools like Tableau. The presence of NULL values in the date column likely indicates tracking issues, as a complete date is essential for accurate analysis.
* Missing or Unknown Country Codes (COUNTRY_CODE IS NULL or "unknown"): To simplify the data, I grouped both NULL and "unknown" values under a single category labeled "Others". While an "unknown" country can be acceptable, NULL values might point to tracking gaps.
* Issues in the CAMPAIGN_ID Column:
    * NULL values: I replaced these with "Others", as campaign tracking should ideally be complete.
    * Incorrect Format: Some CAMPAIGN_IDs were in FLOAT format (e.g., 120203990006170698.000000). I removed the decimal part and converted them into strings to ensure consistency.
    * Interpreting NULL CAMPAIGN_IDs: Initially, I considered that these orders might come from organic traffic, but since they include spend data, they must be from paid campaigns. This suggests that the NULL values are likely due to tracking errors.
