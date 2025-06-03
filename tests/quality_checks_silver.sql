/*
-- =========================================================================================
Quality Checks
-- =========================================================================================
Script Purpose:
    This scripts performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schemas. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid data ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading silver layer.
    - Investigate and resolve any discrepancies found during the checks.
-- ===========================================================================================
*/



-- =========================================================================================
-- Checking 'silver.crm_cust_info'
-- =========================================================================================
-- check for NULLs or duplicates in primary key
-- Expectation: No Results

SELECT 
  cst_id,
  COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- check for unwanted spaces
-- Expectation: No Results

SELECT 
  cst_id
FROM silver.crm_cust_info
WHERE cst_id != TRIM(cst_id);

-- Data Standardization & Consistency
SELECT DISTINCT
  cst_marital_status
FROM silver.crm_cust_info;


-- =========================================================================================
-- Checking 'silver.crm_prd_info'
-- =========================================================================================
-- check for NULLs or duplicates in primary key
-- Expectation: No Results

SELECT 
  prd_id,
  COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- check for unwanted spaces
-- Expectation: No Results
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- check for Nulls or Negative values in cost
-- Expectation: No Results
SELECT  
  prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;


-- Data Standardization & Consistency
SELECT Distinct
    prd_line
FROM silver.crm_prd_info;


-- check for Invalid Date Orders (Start Date > End Date)
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt



-- =========================================================================================
-- Checking 'silver.crm_sales_details'
-- =========================================================================================
-- check for Invalid dates
-- Expectation: No Invalid Dates

SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;


-- check for Invalid Date Orders (order Date > shipping/due date)
-- Exepectation: No Results
SELECT 
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
OR sls_order_dt > sls_due_dt;


-- check data consistency: Sales = Quantity * Price
-- Exepectation: No Results

SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
  OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
  OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;



-- =========================================================================================
-- Checking 'silver.erp_cust_az12'
-- =========================================================================================
-- Identify out-of-range Dates 
-- Expectation: BirthDates Between 1924-01-01 and Today
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
  OR bdate > GETDATE();


-- Data Standardization & Consistency
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;



-- =========================================================================================
-- Checking 'silver.erp_loc_a101'
-- =========================================================================================
-- Data Standardization & Consistency
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;




-- =========================================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- =========================================================================================
-- Check for unwanted spaces
-- Expectation: No results

SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);


-- Data Standardization & Consistency
SELECT DISTINCT 
    maintenance
FROM silver.erp_px_cat_g1v2;
