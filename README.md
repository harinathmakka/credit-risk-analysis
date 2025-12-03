---

# **Credit Risk Analysis for Loan Applicants 📊🏦**

A complete **SQL + Power BI** project focused on analyzing loan applicant risk profiles and approval patterns using a real-world style BFSI dataset.

This project demonstrates **data cleaning, preprocessing, feature engineering, exploratory analysis, and dashboard reporting** — all done using **MySQL** and **Power BI Service**.

It highlights strong applied skills in **BFSI analytics**, **SQL EDA**, and **data visualization**.

---

## 📌 **Table of Contents**

* [Project Overview](#project-overview)
* [Goals](#goals)
* [Tech Stack](#tech-stack)
* [Repository Structure](#repository-structure)
* [Dataset Description](#dataset-description)
* [Data Cleaning & SQL Preprocessing](#data-cleaning--sql-preprocessing)
* [Feature Engineering](#feature-engineering)
* [Exploratory Data Analysis (SQL Insights)](#exploratory-data-analysis-sql-insights)
* [Power BI Dashboard](#power-bi-dashboard)
* [Key Insights](#key-insights)
* [How to Reproduce](#how-to-reproduce)
* [Project Documentation](#project-documentation)
* [Resume Value](#resume-value)
* [Author](#author)

---

# **Project Overview 🚀**

Banks and financial institutions must evaluate whether a loan applicant is likely to be **approved** or **rejected**. This project performs a complete risk analysis workflow:

✔ SQL-based cleaning & preprocessing
✔ Feature engineering (DTI, income bands, total income)
✔ Exploratory SQL analysis
✔ Power BI dashboards & KPIs
✔ Findings relevant to credit underwriting

This project is a perfect demonstration of **BFSI domain knowledge**, **data analytics**, and **business reporting**.

---

# **Goals 🎯**

The primary objectives are:

* Clean and transform raw loan application data using SQL.
* Engineer new risk-related features:
  **Total Income**, **Debt-to-Income (DTI)**, **Income Bands**, etc.
* Understand approval patterns through SQL-based EDA.
* Build Power BI dashboards for business insights.
* Provide a replicable and professional BFSI analytics pipeline.

---

# **Tech Stack 🧰**

### 🗄 SQL (MySQL Workbench)

* Data cleaning
* Data validation
* Feature engineering
* Exploratory analysis

### 📊 Power BI Service

* Interactive dashboards
* KPI cards
* Segmentation analysis
* Risk visualization

### 📁 File Formats

* CSV (raw + cleaned data)
* SQL script (`project_credit_risk_analysis.sql`)
* Power BI exported PDF

---

# **Repository Structure 📂**

```
Credit-Risk-Analysis/
│
├── Data/
│   ├── loan.csv
│   ├── loan_cleaned_data.csv
│
├── SQL_Queries/
│   └── project_credit_risk_analysis.sql
│
├── PowerBI/
│   └── credit_risk_analysis_HM.pdf
│
├── Documentation/
│   └── Credit_Risk_Analysis_Project_Documentation.doc
│
└── README.md
```

---

# **Dataset Description 📙**

The dataset includes demographic, financial, and loan-related information such as:

* **ApplicantIncome**
* **CoapplicantIncome**
* **LoanAmount**
* **Loan_Amount_Term**
* **Credit_History**
* **Property_Area**
* **Dependents**
* **Education**
* **Self_Employed**
* **Loan_Status (Approved / Rejected)**

These variables are used to evaluate the risk of default and loan approval likelihood.

---

# **Data Cleaning & SQL Preprocessing 🧹**

Performed completely in **MySQL Workbench**, documented in:

📄 `SQL_Queries/project_credit_risk_analysis.sql`

### Key steps:

* Handling missing values (LoanAmount, Loan_Term, Credit_History)
* Cleaning categorical fields (Dependents = "3+" → 3)
* Standardizing strings
* Converting numeric text to integer/float
* Extracting engineered fields for risk analysis

---

# **Feature Engineering ✨**

The following new fields were created using SQL:

### ➤ **Total_Income**

```
ApplicantIncome + CoapplicantIncome
```

### ➤ **DTI (Debt-to-Income Ratio)**

```
(LoanAmount * 1000) / Total_Income
```

### ➤ **Income Bands**

* Low
* Medium
* High

### ➤ **DTI Bands**

* Low Risk
* Medium Risk
* High Risk

These transformations significantly improved insight into credit behavior.

---

# **Exploratory Data Analysis (SQL Insights) 🔍**

Examples of SQL insights performed:

### ✔ Overall Approval Rate

```sql
SELECT 
  COUNT(*) AS total,
  SUM(Loan_Status = 'Y') AS approved,
  ROUND(SUM(Loan_Status = 'Y') / COUNT(*) * 100, 2) AS approval_rate
FROM loan_cleaned;
```

### ✔ Approval by Credit History

```sql
SELECT Credit_History,
       COUNT(*) AS total,
       ROUND(SUM(Loan_Status='Y') / COUNT(*) * 100, 2) AS approval_pct
FROM loan_cleaned
GROUP BY Credit_History;
```

### ✔ Income Band Analysis

Applicants with **higher income bands** consistently show better approval chances.

### ✔ DTI Risk Segmentation

Lower DTI → Higher approval
Higher DTI → Higher risk → Lower approval

---

# **Power BI Dashboard 📊**

The full visualization is available here:

👉 **[Credit Risk Dashboard (PDF)](PowerBI/credit_risk_analysis_HM.pdf)**

### Dashboard Highlights:

* Overall approval rate
* Average loan amount
* Approval by:

  * Credit history
  * Income band
  * Property area
  * Dependents
* DTI distribution
* Drill-down for individual applicants

---

# **Key Insights 💡**

### 🔹 **Credit history is the strongest predictor of approval**

Applicants with *Credit_History = 1* show very high approval percentages.

### 🔹 **Higher income → Higher approval probability**

Low-income groups show significantly lower approval rates.

### 🔹 **DTI (Debt-to-Income) is a critical risk indicator**

Applicants with high DTI are more frequently rejected.

### 🔹 **Property area and dependents influence approval**

Urban areas and applicants with fewer dependents show higher approval chances.

### 🔹 **Simple rule-based screening model can automate initial filtering**

---

# **How to Reproduce 🧪**

### **1️⃣ Run SQL Preprocessing**

Load the dataset and execute:

```
project_credit_risk_analysis.sql
```

This generates `loan_cleaned` table.

### **2️⃣ Export Cleaned Dataset**

Export the SQL result to:

```
Data/loan_cleaned_data.csv
```

### **3️⃣ Load into Power BI**

Import the cleaned CSV and recreate visuals (or view exported PDF).

---

# **Project Documentation 📁**

### 📘 Full Report

`Documentation/Credit_Risk_Analysis_Project_Documentation.doc`
Contains methodology, screenshots, queries, and explanations.

### 📊 Dashboard PDF

`PowerBI/credit_risk_analysis_HM.pdf`

---

# **Resume Value ⭐**

This project highlights your strength in:

* ✔ SQL Data Cleaning & EDA
* ✔ Power BI Dashboard Development
* ✔ BFSI Domain Understanding
* ✔ Credit Risk Analytics
* ✔ Feature Engineering
* ✔ Realistic Approval Pattern Insights

This is a **perfect portfolio project** for roles in:

* Data Analysis
* Business Intelligence
* Risk Analytics
* Banking & Financial Analytics

---

# **Author 👨‍💻**

**Harinath Makka**
BFSI Analyst • SQL Developer • Power BI Specialist
*(From Hyderabad, India)*
