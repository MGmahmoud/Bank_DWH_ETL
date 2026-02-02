# Banking Data Mart (Informatica)

## 1️⃣ Objective

Build an end-to-end **Data Mart** using **Informatica PowerCenter** with proper dimensional modeling, SCD handling, and incremental loads.

---

## 2️⃣ Data Sources & Notes

* Bank, Customer, and Transaction relational tables
* One customer record represents **one account**
* Account balance changes per transaction
* Incremental load based on **Transaction_ID**

---

## 3️⃣ Data Model

* **Star Schema**
* Fact grain: **1 transaction × 1 account × 1 date × 1 branch**
* Dimensions: Customer (SCD2), Branch (SCD1), Date, Account Type, Investment Type

📷 *Star Schema Diagram*

---

## 4️⃣ ETL Architecture

* Source → Staging → Dimensions → Fact
* Surrogate keys, data quality rules, SCD logic
* Incremental fact loading

📷 *ETL Architecture Diagram*

---

## 5️⃣ Data Lineage

* High-level and column-level lineage from source to fact

📷 *Lineage Diagrams*

---

## 6️⃣ Informatica Implementation

* Dimension & fact workflows
* Lookup-based SCD handling

📷 *Workflow & SCD Mapping Images*

---

## 7️⃣ Reporting

* Customer behavior analysis
* Branch performance
* Investment insights

---

## 🛠 Tech Stack

**Informatica PowerCenter | SQL Server | Oracle | Star Schema**

---

If you want, I can now:

* ✨ Write a **2-line LinkedIn post**
* 🎯 Prepare **interview explanation (60 seconds)**
* 📐 Fix diagram titles so they look enterprise-grade
