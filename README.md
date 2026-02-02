# Banking DWH ETL (Informatica)

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
* Fact grain: **1 transaction × 1 customer × 1 date × 1 branch**
* Dimensions: Customer (SCD2), Branch (SCD1), Date, Account Type, Investment Type

<img width="1064" height="893" alt="03_Data Model" src="https://github.com/user-attachments/assets/3e60b039-4a5c-49c3-9c74-c2e58b9b9e6b" />


## 4️⃣ Architecture

<img width="942" height="782" alt="01_High Level Architecture" src="https://github.com/user-attachments/assets/3d2a4ea2-8d7d-4dc2-bf13-5ce7a908fbdb" />


## 5️⃣ Data Lineage

* High-level lineage from source to fact

<img width="912" height="742" alt="02_Data Flow" src="https://github.com/user-attachments/assets/678ead09-a420-48e0-aad0-e0970e3bb2b7" />

## 6️⃣ Informatica Implementation


* Dimension & fact workflows
* Lookup-based SCD handling

<img width="956" height="368" alt="ETL_workflow" src="https://github.com/user-attachments/assets/13b21a7e-b99a-42ae-872e-0e42b036a30e" />

<img width="958" height="385" alt="loading_Dimensions" src="https://github.com/user-attachments/assets/0c3bf8e7-151a-4335-a98f-d019522a6871" />

<img width="959" height="424" alt="Mapping_SCD_2" src="https://github.com/user-attachments/assets/7d7a5d94-2844-4a7e-a87d-7b9c32131dc2" />

<img width="951" height="508" alt="Monitor_Run" src="https://github.com/user-attachments/assets/8f91280a-13ad-4082-98d3-b64435f7f63b" />

---

## 🛠 Tech Stack

**Informatica PowerCenter | Oracle**

## 👤 Author

**Mahmoud Ehelaly**

Data Engineer | ETL & Data Warehousing

## 💬 Feedback

Feedback and suggestions are welcome. This project is designed as a learning and portfolio artifact with real-world engineering considerations.
