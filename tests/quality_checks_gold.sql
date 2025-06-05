/*
============================================================================
Quality Checks
============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqeueness of surrogate keys in dimesnsion tables.
    - Referential integrity between fact and dimension tables.
    - validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Run these checks after data loading silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
============================================================================
*/



-- ============================================================================
-- checking 'gold_dim_customers'  
-- ============================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Exepectation: No Results

SELECT
    customer_key,
    COUNT(*)
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ============================================================================
-- checking 'gold_dim_products'  
-- ============================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Exepectation: No Results

SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ============================================================================
-- checking 'gold_fact_sales'  
-- ============================================================================
-- Check the data model connectivity between fact and dimensions

SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL


