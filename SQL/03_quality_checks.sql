-- =======================================================( START )=======================================================
SELECT * FROM STG_BANK;
SELECT * FROM STG_CUSTOMER;
SELECT * FROM STG_TRANSACTION;

-- ===========================================
-- STG_BANK Table
-- ===========================================
-- -------------------------------------------
-- 1.Completeness
-- -------------------------------------------
SELECT 
    * 
FROM STG_BANK
WHERE
    BRANCH_ID IS NULL
 OR CITY IS NULL
 OR REGION IS NULL
 OR FIRM_REVENUE IS NULL
 OR EXPENSES IS NULL
 OR PROFIT_MARGIN IS NULL;

-- -------------------------------------------
-- 2.Validitiy
-- -------------------------------------------
SELECT 
    * 
FROM STG_BANK
WHERE
    FIRM_REVENUE < 0
 OR EXPENSES < 0
 OR PROFIT_MARGIN < -100
 OR PROFIT_MARGIN > 100;
 
-- Check for duplicate keys
SELECT 
    BRANCH_ID, 
    COUNT(*) AS BRANCH_COUNT
FROM STG_BANK
GROUP BY BRANCH_ID
HAVING COUNT(*) > 1;
-- -------------------------------------------
-- 3.Accuracy
-- -------------------------------------------
SELECT 
    * 
FROM STG_BANK
WHERE
    EXPENSES > FIRM_REVENUE;


-- ===========================================
-- STG_CUSTOMER Table
-- ===========================================
-- -------------------------------------------
-- 1.Completeness
-- -------------------------------------------
SELECT 
    *
FROM STG_CUSTOMER
WHERE
    CUSTOMER_ID IS NULL
 OR AGE IS NULL
 OR CUSTOMER_TYPE IS NULL
 OR BRANCH_ID IS NULL;

-- -------------------------------------------
-- 2.Validitiy
-- -------------------------------------------
SELECT 
    *
FROM STG_CUSTOMER
WHERE 
    AGE < 18 OR AGE > 100;


SELECT 
    *
FROM STG_CUSTOMER
WHERE 
CUSTOMER_TYPE NOT IN ('Employee', 'Business', 'Individual');

SELECT 
    CUSTOMER_ID, 
    COUNT(*)
FROM STG_CUSTOMER
GROUP BY CUSTOMER_ID
HAVING COUNT(*) > 1;

-- -------------------------------------------
-- 3.Consistancy
-- -------------------------------------------
SELECT 
    *
FROM STG_CUSTOMER
WHERE BRANCH_ID NOT IN (
    SELECT BRANCH_ID FROM STG_BANK
);


-- ===========================================
-- STG_TRANSACTION Table
-- ===========================================
-- -------------------------------------------
-- 1.Completeness
-- -------------------------------------------
SELECT
    *
FROM STG_TRANSACTION
WHERE
    TRANSACTION_ID IS NULL
 OR CUSTOMER_ID IS NULL
 OR TRANSACTION_DATE IS NULL
 OR INVESTMENT_AMOUNT IS NULL
 OR TRANSACTION_AMOUNT IS NULL;
-- -------------------------------------------
-- 2.Validitiy
-- -------------------------------------------
SELECT
    *
FROM STG_TRANSACTION
WHERE
    TRANSACTION_AMOUNT < 0
 OR INVESTMENT_AMOUNT < 0
 OR TOTAL_BALANCE < 0;

SELECT
    *
FROM STG_TRANSACTION
WHERE TRANSACTION_DATE > SYSDATE;

-- -------------------------------------------
-- 3.Consistancy
-- -------------------------------------------
SELECT
    *
FROM STG_TRANSACTION
WHERE CUSTOMER_ID NOT IN (
    SELECT CUSTOMER_ID FROM STG_CUSTOMER
);

-- Check if account type is the same as customer type
SELECT
    C.CUSTOMER_ID,
    T.CUSTOMER_ID,
    T.ACCOUNT_TYPE,
    C.CUSTOMER_TYPE
FROM STG_TRANSACTION T
INNER JOIN STG_CUSTOMER C
ON T.CUSTOMER_ID = C.CUSTOMER_ID;


-- Check the same customer transactions
SELECT *
FROM STG_TRANSACTION
WHERE CUSTOMER_ID IN (
    SELECT CUSTOMER_ID
    FROM STG_TRANSACTION
    GROUP BY CUSTOMER_ID
    HAVING COUNT(*) > 1
)
ORDER BY CUSTOMER_ID, TRANSACTION_DATE;
-- -------------------------------------------
-- 4.Accuracy
-- -------------------------------------------
SELECT
    *
FROM STG_TRANSACTION
WHERE
    TRANSACTION_AMOUNT > TOTAL_BALANCE
 OR INVESTMENT_AMOUNT > TOTAL_BALANCE;
 
 /*
 The only problem with data is null values 
 we will address these problems with the following strategy:
 1- Key columns ( business keys ) --> You usually reject the row or send it to a quarantine table.
 2- Text / descriptive columns ( CITY, REGION, BANK_NAME, PRODUCT_NAME, etc. ) --> Replace NULLs with a default value, e.g., 'Unknown' or 'Not Provided'.
 3- Numeric columns ( FIRM_REVENUE, EXPENSES, PROFIT_MARGIN, AGE, etc. ) --> 
    Strategy: Depends on business meaning:
        - Replace with 0 if it makes sense (like revenue or expenses)
        - Reject the row if missing value is critical
 4- Dates ( TRANSACTION_DATE, START_DATE, etc. ) --> 
    - Usually reject NULLs because they’re needed for SCD or time dimensions.
    - If optional, you can replace with a dummy date like '1900-01-01'.
 */
