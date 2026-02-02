-- ======================================================================
-- STG_BANK
-- ======================================================================
-- 1- Drop STG_BANK Table (If Exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'STG_BANK';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
-- 2- Create STG_BANK Table
CREATE TABLE STG_BANK (
    BRANCH_ID        NUMBER(10),
    CITY             VARCHAR2(50),
    REGION           VARCHAR2(30),
    FIRM_REVENUE     NUMBER(15,2),
    EXPENSES         NUMBER(15,2),
    PROFIT_MARGIN    NUMBER(5,2)
);

-- ======================================================================
-- STG_CUSTOMER
-- ======================================================================
-- 1- Drop STG_CUSTOMER Table (If Exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'STG_CUSTOMER';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
-- 2- Create STG_CUSTOMER Table
CREATE TABLE STG_CUSTOMER (
    CUSTOMER_ID      NUMBER(10),
    AGE              NUMBER(3),
    CUSTOMER_TYPE    VARCHAR2(20),
    CITY             VARCHAR2(50),
    REGION           VARCHAR2(30),
    BANK_NAME        VARCHAR2(50),
    BRANCH_ID        NUMBER(10)
);

-- ======================================================================
-- STG_TRANSACTION
-- ======================================================================
-- 1- Drop STG_TRANSACTION Table (If Exists)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE ' || 'STG_TRANSACTION';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/
-- 2- Create STG_TRANSACTION Table
CREATE TABLE STG_TRANSACTION (
    TRANSACTION_ID       NUMBER(10),
    CUSTOMER_ID          NUMBER(10),
    ACCOUNT_TYPE         VARCHAR2(20),
    TOTAL_BALANCE        NUMBER(15,2),
    TRANSACTION_AMOUNT   NUMBER(15,2),
    INVESTMENT_AMOUNT    NUMBER(15,2),
    INVESTMENT_TYPE      VARCHAR2(30),
    TRANSACTION_DATE     DATE  
);
