
-- ======================================================================
-- DIM_ACCOUNT_TYPE
-- ======================================================================
-- Drop DIM_ACCOUNT_TYPE Table (If Exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'DIM_ACCOUNT_TYPE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
-- Create DIM_ACCOUNT_TYPE Table
CREATE TABLE DIM_ACCOUNT_TYPE (
    ACCOUNT_TYPE_KEY      NUMBER(10) PRIMARY KEY, -- Surrogate Key
    ACCOUNT_TYPE          VARCHAR2(50) NOT NULL
);

-- 3- Insert Unknown row
INSERT INTO DIM_ACCOUNT_TYPE (
    ACCOUNT_TYPE_KEY,
    ACCOUNT_TYPE
)
VALUES (
    0,
    'UNKNOWN'
);

COMMIT;

-- ======================================================================
-- DIM_INVESTMENT_TYPE
-- ======================================================================
-- Drop DIM_INVESTMENT_TYPE Table (If Exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'DIM_INVESTMENT_TYPE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
-- Create DIM_INVESTMENT_TYPE Table
CREATE TABLE DIM_INVESTMENT_TYPE (
    INVESTMENT_TYPE_KEY      NUMBER(10) PRIMARY KEY, -- Surrogate Key
    INVESTMENT_TYPE          VARCHAR2(50) NOT NULL
);

-- 3- Insert Unknown row
INSERT INTO DIM_INVESTMENT_TYPE (
    INVESTMENT_TYPE_KEY,
    INVESTMENT_TYPE
)
VALUES (
     0,
    'UNKNOWN'
);

COMMIT;



-- ======================================================================
-- DIM_BRANCH SCD Type 1
-- ======================================================================
-- 1- Drop DIM_BRANCH Table (If Exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'DIM_BRANCH';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
-- 2- Create DIM_BRANCH Table
CREATE TABLE DIM_BRANCH (
    BRANCH_KEY               NUMBER(10) PRIMARY KEY,
    BRANCH_ID                NUMBER(10) NOT NULL,
    BRANCH_CITY              VARCHAR2(50),
    BRANCH_REGION            VARCHAR2(30),
    
    -- meta data to trace record last updated date
    LOAD_DATE                DATE
);

-- 3- Insert Unknown row
INSERT INTO DIM_BRANCH (
    BRANCH_KEY,
    BRANCH_ID,
    BRANCH_CITY,
    BRANCH_REGION,
    LOAD_DATE
)
VALUES (
    0,
    0,
    'UNKNOWN',
    'UNKNOWN',
    SYSDATE
);

COMMIT;

-- ======================================================================
-- DIM_CUSTOMER SCD Type 2
-- ======================================================================
-- 1- Drop DIM_CUSTOMER Table (If Exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'DIM_CUSTOMER';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
-- 2- Create DIM_CUSTOMER Table
CREATE TABLE DIM_CUSTOMER (
    CUSTOMER_KEY        NUMBER(10) PRIMARY KEY, -- Surrogate Key
    CUSTOMER_ID         NUMBER(10) NOT NULL,    -- Business Key
    CUSTOMER_TYPE       VARCHAR2(20),
    CUSTOMER_CITY       VARCHAR2(50),
    CUSTOMER_REGION     VARCHAR2(30),
    BRANCH_ID           NUMBER(10) NOT NULL,
    BANK_NAME           VARCHAR2(50),
    
    -- SCD Type 2 data
    START_DATE          DATE NOT NULL,                    
    END_DATE            DATE,                    
    IS_CURRENT          CHAR(1)                 -- Y = current, N = historical
);

-- 3- Insert Unknown row
INSERT INTO DIM_CUSTOMER (
    CUSTOMER_KEY,
    CUSTOMER_ID,
    CUSTOMER_TYPE,
    CUSTOMER_CITY,
    CUSTOMER_REGION,
    BRANCH_ID,
    BANK_NAME,
    START_DATE,
    END_DATE,
    IS_CURRENT
)
VALUES (
     0,
     0,
    'UNKNOWN',
    'UNKNOWN',
    'UNKNOWN',
     0,
    'UNKNOWN',
     DATE '1900-01-01',
     NULL,
     'Y'
);

COMMIT;


-- ======================================================================
-- DIM_DATE
-- ======================================================================
-- 1- Drop DIM_DATE Table (If Exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'DIM_DATE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
-- 2- CREATE DIM_DATE TABLE
CREATE TABLE DIM_DATE (
    DATE_KEY       NUMBER(8) PRIMARY KEY,
    FULL_DATE      DATE NOT NULL,
    DAY            NUMBER(2) NOT NULL,
    MONTH          NUMBER(2) NOT NULL,
    QUARTER        NUMBER(1) NOT NULL,
    YEAR           NUMBER(4) NOT NULL,
    MONTH_NAME     VARCHAR2(15) NOT NULL,
    DAY_OF_WEEK    NUMBER(1) NOT NULL,
    DAY_NAME       VARCHAR2(10) NOT NULL
);

-- 3- Insert Unknown row
INSERT INTO DIM_DATE (
    DATE_KEY,
    FULL_DATE,
    DAY,
    MONTH,
    QUARTER,
    YEAR,
    MONTH_NAME,
    DAY_OF_WEEK,
    DAY_NAME
)
VALUES (
    19000101,
    DATE '1900-01-01',
    1,
    1,
    1,
    1900,
    'January',
    1,
    'Monday'
);

COMMIT;

-- 4- Date population From '2020-01-01' to '2028-12-31'
DECLARE
    v_start_date DATE := DATE '2020-01-01';
    v_end_date   DATE := DATE '2028-12-31';
    v_date       DATE := v_start_date;
BEGIN
    WHILE v_date <= v_end_date LOOP
        INSERT INTO dim_date (
            date_key, full_date, day, month, month_name, quarter, year, day_of_week, day_name
        ) VALUES (
            TO_NUMBER(TO_CHAR(v_date,'YYYYMMDD')),
            v_date,
            TO_NUMBER(TO_CHAR(v_date,'DD')),
            TO_NUMBER(TO_CHAR(v_date,'MM')),
            TO_CHAR(v_date,'Month'),
            TO_NUMBER(TO_CHAR(v_date,'Q')),
            TO_NUMBER(TO_CHAR(v_date,'YYYY')),
            TO_NUMBER(TO_CHAR(v_date,'D')), -- depends on NLS_TERRITORY
            TO_CHAR(v_date,'Day')
        );
        v_date := v_date + 1;
    END LOOP;
    COMMIT;
END;
/


-- ======================================================================
-- FACT_TRANSACTION (Daily loads)
-- ======================================================================
-- 1- Drop FACT_TRANSACTION Table (If Exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'FACT_TRANSACTION';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
-- 2- Create FACT_TRANSACTION Table
CREATE TABLE FACT_TRANSACTION (

    TRANSACTION_KEY       NUMBER(19) PRIMARY KEY,
    -- Foreign Keys to Dimensions
    CUSTOMER_KEY          NUMBER(10) NOT NULL,    -- FK to DIM_CUSTOMER
    BRANCH_KEY            NUMBER(10) NOT NULL,    -- FK to DIM_BRANCH
    DATE_SK               NUMBER(8)  NOT NULL,
    INVESTMENT_TYPE_KEY   NUMBER(10) NOT NULL,
    ACCOUNT_TYPE_KEY      NUMBER(10) NOT NULL,
    
    TRANSACTION_ID        NUMBER(10) NOT NULL,   
    -- Measures
    TRANSACTION_AMOUNT    NUMBER(15,2),           -- Additive         
    TOTAL_BALANCE         NUMBER(15,2),           -- Semi-additive (snapshot, do NOT sum across rows)
    INVESTMENT_AMOUNT     NUMBER(15,2),
    
    -- BRANCH RELATED INFO
    BRANCH_REVENUE           NUMBER(15,2),
    BRANCH_EXPENSES          NUMBER(15,2),
    BRANCH_PROFIT_MARGIN     NUMBER(7,2),
    
    -- ETL Audit Columns
    LOAD_DATE             DATE,                    -- Timestamp when this row was loaded
    LOAD_RUN_ID           NUMBER(10)               -- Identifier for ETL run for recovery
);