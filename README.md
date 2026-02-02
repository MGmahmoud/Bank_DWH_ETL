# Banking Sales Data Warehouse – End-to-End ETL Project

## 📌 Project Overview

This project demonstrates the design and implementation of an **end-to-end Banking Sales Data Warehouse** using **Oracle** as the target database and **Informatica PowerCenter** for ETL.

The focus of this project is **data modeling correctness, ETL robustness, and real-world tradeoffs**, rather than tool-heavy or tutorial-style implementation.

The warehouse is designed to support analytical questions around:

* Customer transaction behavior
* Account balance evolution
* Investment patterns
* Branch-level financial performance

---

## 🧱 Source Data

The project is based on three operational source tables loaded into a **Staging Layer (STG)**:

### 1️⃣ STG_BANK

Stores branch-level geographic and financial data.

* One row per branch
* No historical tracking in source

Key columns:

* BRANCH_ID
* CITY
* REGION
* FIRM_REVENUE
* EXPENSES
* PROFIT_MARGIN

---

### 2️⃣ STG_CUSTOMER

Stores customer-account related information.

* Each row represents **one customer account**
* Assumption: one account per customer in source system

Key columns:

* CUSTOMER_ID
* AGE
* CUSTOMER_TYPE
* CITY
* REGION
* BANK_NAME
* BRANCH_ID

---

### 3️⃣ STG_TRANSACTION

Stores transactional activity.

* One row per transaction
* Contains both transactional and account-related attributes

Key columns:

* TRANSACTION_ID
* CUSTOMER_ID
* ACCOUNT_TYPE
* TRANSACTION_AMOUNT
* TRANSACTION_DATE
* TOTAL_BALANCE
* INVESTMENT_AMOUNT
* INVESTMENT_TYPE

---

## ⭐ Data Warehouse Design

### 🎯 Fact Grain Definition

Before modeling, the fact grain was explicitly defined:

> **1 row in FACT_TRANSACTION = 1 transaction performed by 1 account on 1 date at 1 branch**

This grain decision drives all downstream modeling and ETL logic.

---

### 🧩 Fact Tables

#### 1️⃣ FACT_TRANSACTION (Transactional Fact)

Captures atomic transaction events.

Measures:

* TRANSACTION_AMOUNT
* INVESTMENT_AMOUNT
* TOTAL_BALANCE (balance *after* transaction)

Foreign Keys:

* CUSTOMER_SK
* BRANCH_SK
* ACCOUNT_TYPE_SK
* INVESTMENT_TYPE_SK
* DATE_KEY

Loading Strategy:

* Incremental load based on **TRANSACTION_ID (high-water mark)**

---

### 📊 Dimensions

#### DIM_CUSTOMER (SCD Type 2)

Tracks historical changes in customer/account attributes.

Tracked changes:

* CUSTOMER_TYPE
* CITY
* REGION
* BRANCH_ID

Key features:

* SURROGATE KEY (CUSTOMER_SK)
* IS_CURRENT flag
* EFFECTIVE_FROM / EFFECTIVE_TO dates

---

#### DIM_BRANCH (SCD Type 1)

Stores current branch attributes only.

Reasoning:

* No historical requirement provided for branch financials
* Overwrite changes is acceptable

---

#### DIM_ACCOUNT_TYPE

Static reference dimension.

Examples:

* Savings
* Current
* Business

---

#### DIM_INVESTMENT_TYPE

Static reference dimension.

Examples:

* Fixed Deposit
* Mutual Funds

---

#### DIM_DATE

Standard calendar dimension.

Granularity:

* One row per day

Attributes include:

* Day, Month, Quarter, Year
* Day name
* Weekend flag

---

## 🔄 ETL Architecture

### 🔹 Staging Layer

* Basic data quality checks
* NULL handling using default values
* No business logic applied

---

### 🔹 Dimension Load

| Dimension           | Strategy           |
| ------------------- | ------------------ |
| DIM_BRANCH          | SCD Type 1         |
| DIM_CUSTOMER        | SCD Type 2         |
| DIM_ACCOUNT_TYPE    | Full load / static |
| DIM_INVESTMENT_TYPE | Full load / static |
| DIM_DATE            | Pre-generated      |

---

### 🔹 Fact Load

Fact loading steps:

1. Filter new transactions using **MAX(TRANSACTION_ID)** from FACT table
2. Lookup surrogate keys from dimensions
3. Handle late-arriving dimensions using default SKs
4. Insert only new transaction rows

---

## 🧠 Key Design Decisions & Tradeoffs

* TOTAL_BALANCE stored in FACT_TRANSACTION because it changes per transaction
* No daily snapshot fact implemented to avoid over-engineering
* Investment attributes modeled as dimensions to avoid duplication
* No custom audit tables (Informatica metadata is sufficient)

---

## 🛠️ Tools & Technologies

* Oracle Database
* Informatica PowerCenter
* SQL
* Dimensional Modeling (Kimball methodology)

---

## 📈 Use Cases Enabled

* Customer transaction behavior analysis
* Balance vs transaction activity analysis
* Investment distribution by account type
* Branch performance comparison

---

## 🚀 Future Enhancements

* Add daily account snapshot fact
* Add data quality metrics
* Add reconciliation checks
* Implement CDC-based incremental loading

---

## 👤 Author

**Mahmoud Ehelaly**
Aspiring Data Engineer | ETL & Data Warehousing

---

## 💬 Feedback

Feedback and suggestions are welcome. This project is designed as a learning and portfolio artifact with real-world engineering considerations.
