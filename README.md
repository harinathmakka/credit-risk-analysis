# Credit Risk Analysis for Loan Applicants

## Project Overview
Banks and financial institutions face the challenge of evaluating whether a loan applicant is likely to be approved or rejected.  
This project uses **SQL for data cleaning and exploration** and **Power BI for visualization** to provide insights into loan approval trends and applicant risk profiles.  

The goal is to demonstrate strong **data analysis, SQL, and reporting skills** in the BFSI (Banking, Financial Services, Insurance) domain.

---

## Tech Stack
- **SQL (MySQL Workbench)** → Data cleaning, preprocessing, and exploratory data analysis  
- **Power BI Service** → Interactive dashboards and reports  
- **CSV** → Initial dataset  

---

## Repository Structure
Credit_Risk_Analysis_Project/
├── Data/ # Raw + cleaned datasets
├── SQL_Queries/ # SQL scripts for preprocessing and EDA
├── PowerBI/ # Power BI exports
│ └── credit_risk_analysis_HM.pdf # Final dashboard report (all visuals)
├── Documentation/ # Final project report (Word)
└── README.md # Project overview


---

## Dashboard Preview
The interactive dashboards were built in **Power BI Service** and exported as PDF.  
You can view the complete report here:

👉 [Loan Approval Dashboard (PDF)](PowerBI/credit_risk_analysis_HM.pdf)

---

## Key Insights
- **Overall Loan Approval Rate** — What percentage of applicants were approved.  
- **Credit History Impact** — Strong influence on approval likelihood.  
- **Income Band Trends** — Relationship between applicant income and approvals.  
- **Debt-to-Income (DTI) Segments** — Risk distribution by repayment capacity.  
- **Property Area & Dependents** — Approval variation across demographic factors.  
- **KPI Cards** — Total applications, approval percentage, average loan amount.  

---

## How to Reproduce
1. Load the raw dataset into SQL (scripts available in `SQL_Queries/`).  
2. Run preprocessing queries (handle NULLs, create new columns like `Total_Income`, `Income_Band`, `DTI_Band`).  
3. Export the cleaned dataset and load into Power BI.  
4. Recreate the visuals as per the documentation OR directly view the exported PDF in `/PowerBI/`.

---

## Documentation
For a detailed explanation of problem statement, methodology, SQL steps, and dashboard visuals, see:  
📄 [Final Project Report](Documentation/Credit_Risk_Analysis_Project_Documentation.doc)

---

## Resume Value
This project demonstrates:  
✔ SQL data cleaning & EDA in BFSI domain  
✔ Building executive-ready dashboards in Power BI  
✔ Domain knowledge of loan approval risk analysis  
