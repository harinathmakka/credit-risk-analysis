-- ============Credit Risk Analysis================

-- create a database
CREATE DATABASE IF NOT EXISTS Credit_Risk_Analysis;
  
-- use the database
USE Credit_Risk_Analysis;

-- turn off safe mode (1 - on)
SET SQL_SAFE_UPDATES = 0;

-- creating a table to import raw data
CREATE TABLE staging_loan_raw (
  idx VARCHAR(100),                -- will store 'Unnamed: 0' index if present
  Loan_ID VARCHAR(32),
  Gender VARCHAR(32),
  Married VARCHAR(32),
  Dependents VARCHAR(32),
  Education VARCHAR(64),
  Self_Employed VARCHAR(32),
  ApplicantIncome VARCHAR(64),
  CoapplicantIncome VARCHAR(64),
  LoanAmount VARCHAR(64),
  Loan_Amount_Term VARCHAR(64),
  Credit_History VARCHAR(32),
  Property_Area VARCHAR(32),
  Loan_Status VARCHAR(8),
  Total_Income VARCHAR(64)
);

select * from staging_loan_raw;  -- display all rows and columns in a data set

SELECT COUNT(*) AS staging_rows FROM staging_loan_raw;  -- 500 rows

SELECT * FROM staging_loan_raw LIMIT 10; -- display first 10 rows 

SELECT COUNT(*) AS missing_loanid
FROM staging_loan_raw
WHERE Loan_ID IS NULL OR TRIM(Loan_ID) = '';  -- check loan_id has null values	

SELECT * FROM staging_loan_raw WHERE Loan_ID IS NULL OR TRIM(Loan_ID) = '' LIMIT 10;

SELECT Loan_ID, COUNT(*) as cnt
FROM staging_loan_raw
GROUP BY Loan_ID
HAVING cnt > 0;                                -- ckeck loan_id has dupliocant values

-- returns all the unique values(distinct) from that column
SELECT DISTINCT Dependents FROM staging_loan_raw;     
SELECT DISTINCT Credit_History FROM staging_loan_raw;
SELECT DISTINCT Gender FROM staging_loan_raw;
SELECT DISTINCT Property_Area FROM staging_loan_raw;
SELECT DISTINCT Loan_Status FROM staging_loan_raw;         

-- returns rows where ApplicantIncome contains characters other than digits and dot (ignores blanks)
SELECT ApplicantIncome FROM staging_loan_raw
WHERE TRIM(ApplicantIncome) <> ''
  AND ApplicantIncome NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
LIMIT 50;                                                 

SELECT LoanAmount FROM staging_loan_raw
WHERE TRIM(LoanAmount) <> ''
  AND LoanAmount NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
LIMIT 50;

SELECT LoanAmount FROM staging_loan_raw
WHERE TRIM(CoapplicantIncome) <> ''
  AND LoanAmount NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
LIMIT 50;

SELECT LoanAmount FROM staging_loan_raw
WHERE TRIM(Credit_History) <> ''
  AND LoanAmount NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
LIMIT 50;

SELECT LoanAmount FROM staging_loan_raw
WHERE TRIM(Loan_Amount_Term) <> ''
  AND LoanAmount NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
LIMIT 50;

SELECT LoanAmount FROM staging_loan_raw
WHERE TRIM(Total_Income) <> ''
  AND LoanAmount NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
LIMIT 50;

-- counts the nnumber of values in the distinct values and order by high to low
SELECT Dependents, COUNT(*) FROM staging_loan_raw GROUP BY Dependents ORDER BY COUNT(*) DESC;  

-- ============== modifying the raw data ==================
-- remove the '$' from the total income
UPDATE staging_loan_raw
SET Total_Income = REPLACE(TRIM(Total_Income), '$', '')
WHERE TRIM(Total_Income) <> '';

-- First replace 3+ with 3
UPDATE staging_loan_raw
SET Dependents = REPLACE(Dependents, '3+', '3');

SELECT * FROM staging_loan_raw;

-- =================Create the clean table schema =======================

CREATE TABLE loan_cleaned (
    Loan_ID VARCHAR(32),
    Gender VARCHAR(16),
    Married VARCHAR(16),
    Dependents VARCHAR(8),
    Education VARCHAR(32),
    Self_Employed VARCHAR(16),
    ApplicantIncome DECIMAL(12,2),
    CoapplicantIncome DECIMAL(12,2),
    LoanAmount DECIMAL(12,2),
    Loan_Amount_Term INT UNSIGNED,
    Credit_History TINYINT(1) UNSIGNED,
    Property_Area VARCHAR(32),
    Loan_Status VARCHAR(8),
    Total_Income DECIMAL(12,2)
);

-- insert the values from the staging loan raw table

INSERT INTO loan_cleaned
SELECT 
    Loan_ID,
    NULLIF(TRIM(Gender), '') AS Gender,
    NULLIF(TRIM(Married), '') AS Married,
    NULLIF(TRIM(Dependents), '') AS Dependents,
    NULLIF(TRIM(Education), '') AS Education,
    NULLIF(TRIM(Self_Employed), '') AS Self_Employed,

    CAST(NULLIF(REGEXP_REPLACE(ApplicantIncome, '[^0-9.]', ''), '') AS DECIMAL(12,2)) AS ApplicantIncome,
    CAST(NULLIF(REGEXP_REPLACE(CoapplicantIncome, '[^0-9.]', ''), '') AS DECIMAL(12,2)) AS CoapplicantIncome,
    CAST(NULLIF(REGEXP_REPLACE(LoanAmount, '[^0-9.]', ''), '') AS DECIMAL(12,2)) AS LoanAmount,

    CAST(NULLIF(REPLACE(TRIM(Loan_Amount_Term), '.0', ''), '') AS UNSIGNED) AS Loan_Amount_Term,
    CAST(NULLIF(REPLACE(TRIM(Credit_History), '.0', ''), '') AS UNSIGNED) AS Credit_History,

    NULLIF(TRIM(Property_Area), '') AS Property_Area,
    NULLIF(TRIM(Loan_Status), '') AS Loan_Status,

    CAST(NULLIF(REGEXP_REPLACE(Total_Income, '[^0-9.]', ''), '') AS DECIMAL(12,2)) AS Total_Income
FROM staging_loan_raw;

select * from loan_cleaned;

-- ====================== checking and filling NULL VALUES & BLANK VALUES ==================================
-- mostly null values are checked for numerical columns only because they effect in data analysis
-- for string columns we add the blank values with appropiate names
-- IS NULL finds null values & TRIM(..) = "" finds blank string values(no blank values , already we inserted with null values if there is balnk at insert values only)

-- ApplicantIncome:
SELECT * FROM loan_cleaned where ApplicantIncome IS NULL or TRIM(ApplicantIncome) = "";  -- no null or blank values

-- CoapplicantIncome:
SELECT * FROM loan_cleaned where CoapplicantIncome IS NULL or TRIM(CoapplicantIncome) = "";  -- no null or blank values

-- LoanAmount: 
SELECT * FROM loan_cleaned where LoanAmount IS NULL or TRIM(LoanAmount) = "";  -- 18 null or blank values

-- Step 1: count the number of values without null values
SELECT count(*)
FROM loan_cleaned
WHERE LoanAmount IS NOT NULL;  -- 482

-- Step 2: Pick the middle value using OFFSET
SELECT LoanAmount
FROM loan_cleaned
WHERE LoanAmount IS NOT NULL
ORDER BY LoanAmount
LIMIT 2 OFFSET 240; -- show the values at 241, and 242  | median is average of 126,127

-- Step 3: Update nulls with that median value
UPDATE loan_cleaned
SET LoanAmount = 127  -- taking median as 127, to avoid decimal values
WHERE LoanAmount IS NULL;

-- Loan_Amount_Term:
SELECT * FROM loan_cleaned where Loan_Amount_Term IS NULL or TRIM(Loan_Amount_Term) = "";  -- 14 null or blank values

-- Step 1: find most frequent term
SELECT Loan_Amount_Term, COUNT(*) AS freq
FROM loan_cleaned
WHERE Loan_Amount_Term IS NOT NULL
GROUP BY Loan_Amount_Term
ORDER BY freq DESC
LIMIT 1;                                   -- mode is 360

-- Step 2: update NULLs with that value (say 360)
UPDATE loan_cleaned
SET Loan_Amount_Term = 360
WHERE Loan_Amount_Term IS NULL;  


-- Credit_History:
SELECT * FROM loan_cleaned where Credit_History IS NULL or TRIM(Credit_History) = "";  -- 41 null or blank values

-- Step 1: check distribution
SELECT Credit_History, COUNT(*) 
FROM loan_cleaned
GROUP BY Credit_History;

-- Step 2: update NULLs with majority (say 1)
UPDATE loan_cleaned
SET Credit_History = 1
WHERE Credit_History IS NULL;


-- Total_Income:(actually we do not need to check for this, because in farture will add Applicant and Coapplicant income to get total income)
SELECT * FROM loan_cleaned where Total_Income IS NULL or TRIM(Total_Income) = "";  -- 0 null or blank values

UPDATE loan_cleaned
SET Total_Income = ApplicantIncome + CoapplicantIncome;

-- Loan_ID:
SELECT * FROM loan_cleaned where Loan_ID IS NULL or TRIM(Loan_ID) = "";  -- 0 null values

-- Gender:
SELECT * FROM loan_cleaned where Gender IS NULL or TRIM(Gender) = "";  -- 9 null values

UPDATE loan_cleaned
SET Gender = 'others'
WHERE Gender IS NULL OR TRIM(Gender) = '';

-- Married:
SELECT * FROM loan_cleaned where Married IS NULL or TRIM(Married) = "";  -- 3 null values

UPDATE loan_cleaned
SET Married = 'unknown'
WHERE Married IS NULL OR TRIM(Married) = '';

-- Dependents:
SELECT * FROM loan_cleaned where Dependents IS NULL or TRIM(Dependents) = "";  -- 12 null values

UPDATE loan_cleaned
SET Dependents = 0                                    -- mostly dependents are considers 0
WHERE Dependents IS NULL OR TRIM(Dependents) = "";

-- Education:
SELECT * FROM loan_cleaned where Education IS NULL or TRIM(Education) = "";  -- no null values

-- Self_Employed:
SELECT * FROM loan_cleaned where Self_Employed IS NULL or TRIM(Self_Employed) = "";  -- 27 null values

SELECT Self_Employed, COUNT(*) AS freq
FROM loan_cleaned
GROUP BY Self_Employed
ORDER BY freq DESC;

UPDATE loan_cleaned
SET Self_Employed = 'No'
WHERE Self_Employed IS NULL OR TRIM(Self_Employed) = '';

-- Property_Area:
SELECT * FROM loan_cleaned where Property_Area IS NULL or TRIM(Property_Area) = "";  -- no null values

-- Loan_Status:
SELECT * FROM loan_cleaned where Loan_Status IS NULL or TRIM(Loan_Status) = "";  -- no null values

-- check whether null values are lef or not
SELECT 
    SUM(CASE WHEN Loan_ID IS NULL THEN 1 ELSE 0 END) AS Loan_ID_nulls,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_nulls,
    SUM(CASE WHEN Married IS NULL THEN 1 ELSE 0 END) AS Married_nulls,
    SUM(CASE WHEN Dependents IS NULL THEN 1 ELSE 0 END) AS Dependents_nulls,
    SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS Education_nulls,
    SUM(CASE WHEN Self_Employed IS NULL THEN 1 ELSE 0 END) AS Self_Employed_nulls,
    SUM(CASE WHEN ApplicantIncome IS NULL THEN 1 ELSE 0 END) AS ApplicantIncome_nulls,
    SUM(CASE WHEN CoapplicantIncome IS NULL THEN 1 ELSE 0 END) AS CoapplicantIncome_nulls,
    SUM(CASE WHEN LoanAmount IS NULL THEN 1 ELSE 0 END) AS LoanAmount_nulls,
    SUM(CASE WHEN Loan_Amount_Term IS NULL THEN 1 ELSE 0 END) AS Loan_Amount_Term_nulls,
    SUM(CASE WHEN Credit_History IS NULL THEN 1 ELSE 0 END) AS Credit_History_nulls,
    SUM(CASE WHEN Property_Area IS NULL THEN 1 ELSE 0 END) AS Property_Area_nulls,
    SUM(CASE WHEN Loan_Status IS NULL THEN 1 ELSE 0 END) AS Loan_Status_nulls,
    SUM(CASE WHEN Total_Income IS NULL THEN 1 ELSE 0 END) AS Total_Income_nulls
FROM loan_cleaned;


select * from loan_cleaned;	

-- ============== creating tables for data analysis =============================== 

CREATE TABLE applicant (
    applicant_id INT AUTO_INCREMENT PRIMARY KEY,
    Loan_ID VARCHAR(32) UNIQUE,
    Gender VARCHAR(16),
    Married VARCHAR(16),
    Dependents VARCHAR(8),
    Education VARCHAR(32),
    Self_Employed VARCHAR(16)
);

INSERT INTO applicant (Loan_ID, Gender, Married, Dependents, Education, Self_Employed)
SELECT DISTINCT
    Loan_ID,
    Gender,
    Married,
    Dependents,
    Education,
    Self_Employed
FROM loan_cleaned;

CREATE TABLE loan (
    Loan_ID VARCHAR(32) PRIMARY KEY,
    applicant_id INT,
    ApplicantIncome DECIMAL(12,2),
    CoapplicantIncome DECIMAL(12,2),
    LoanAmount DECIMAL(12,2),
    Loan_Amount_Term INT,
    Property_Area VARCHAR(32),
    Loan_Status VARCHAR(8),
    FOREIGN KEY (applicant_id) REFERENCES applicant(applicant_id)
);

INSERT INTO loan (Loan_ID, applicant_id, ApplicantIncome, CoapplicantIncome, LoanAmount, Loan_Amount_Term, Property_Area, Loan_Status)
SELECT 
    lc.Loan_ID,
    a.applicant_id,
    lc.ApplicantIncome,
    lc.CoapplicantIncome,
    lc.LoanAmount,
    lc.Loan_Amount_Term,
    lc.Property_Area,
    lc.Loan_Status
FROM loan_cleaned lc
JOIN applicant a ON lc.Loan_ID = a.Loan_ID;

CREATE TABLE credit_history (
    applicant_id INT,
    Loan_ID VARCHAR(32),
    Credit_History TINYINT(1),
    PRIMARY KEY (applicant_id, Loan_ID),
    FOREIGN KEY (applicant_id) REFERENCES applicant(applicant_id),
    FOREIGN KEY (Loan_ID) REFERENCES loan(Loan_ID)
);

INSERT INTO credit_history (applicant_id, Loan_ID, Credit_History)
SELECT 
    a.applicant_id,
    lc.Loan_ID,
    lc.Credit_History
FROM loan_cleaned lc
JOIN applicant a ON lc.Loan_ID = a.Loan_ID;

SELECT * FROM applicant;
SELECT COUNT(*) FROM applicant;
SELECT COUNT(*) FROM loan;
SELECT * FROM loan;
SELECT COUNT(*) FROM credit_history;
SELECT * FROM credit_history;

-- ========================Check for NULLs in each table============================

-- Applicant table
SELECT 
    SUM(Gender IS NULL) AS null_gender,
    SUM(Married IS NULL) AS null_married,
    SUM(Dependents IS NULL) AS null_dependents,
    SUM(Education IS NULL) AS null_education,
    SUM(Self_Employed IS NULL) AS null_self_employed
FROM applicant;

-- Loan table
SELECT 
    SUM(ApplicantIncome IS NULL) AS null_applicant_income,
    SUM(CoapplicantIncome IS NULL) AS null_coapplicant_income,
    SUM(LoanAmount IS NULL) AS null_loan_amount,
    SUM(Loan_Amount_Term IS NULL) AS null_loan_term,
    SUM(Property_Area IS NULL) AS null_property_area,
    SUM(Loan_Status IS NULL) AS null_loan_status
FROM loan;

-- Credit history table
SELECT 
    SUM(Credit_History IS NULL) AS null_credit_history
FROM credit_history;

-- ======================= Exploratory Data Analysis (EDA) ======================
/*EDA (Exploratory Data Analysis) is the process of examining a dataset using 
statistical summaries, visualizations, and queries to understand 
its structure, detect patterns, spot anomalies, check assumptions, and identify key relationships 
that help guide deeper analysis or modeling.*/

-- 1. Overall Loan Approval Rate
SELECT Loan_Status, COUNT(*) AS total
FROM loan
GROUP BY Loan_Status;

-- 2. Approval Rate by Credit History
SELECT c.Credit_History, l.Loan_Status, COUNT(*) AS total
FROM loan l
JOIN credit_history c ON l.Loan_ID = c.Loan_ID
GROUP BY c.Credit_History, l.Loan_Status
ORDER BY c.Credit_History, l.Loan_Status;

-- 3. Approval Rate by Income Band
SELECT 
    CASE 
        WHEN (ApplicantIncome + CoapplicantIncome) < 2500 THEN 'Low Income (<2500)'
        WHEN (ApplicantIncome + CoapplicantIncome) BETWEEN 2500 AND 5000 THEN 'Medium Income (2500-5000)'
        WHEN (ApplicantIncome + CoapplicantIncome) BETWEEN 5001 AND 10000 THEN 'High Income (5001-10000)'
        ELSE 'Very High Income (>10000)'
    END AS income_band,
    Loan_Status,
    COUNT(*) AS total
FROM loan
GROUP BY income_band, Loan_Status
ORDER BY income_band, Loan_Status;

-- 4. Debt-to-Income Ratio (DTI) Analysis
SELECT 
    Loan_ID,
    ROUND(LoanAmount / NULLIF(ApplicantIncome + CoapplicantIncome,0),2) AS dti_ratio,
    Loan_Status
FROM loan
WHERE (ApplicantIncome + CoapplicantIncome) > 0;

-- 4b. Grouped DTI
SELECT 
    CASE 
        WHEN (LoanAmount / (ApplicantIncome + CoapplicantIncome)) < 0.2 THEN 'Low Risk (<20%)'
        WHEN (LoanAmount / (ApplicantIncome + CoapplicantIncome)) BETWEEN 0.2 AND 0.4 THEN 'Medium Risk (20-40%)'
        ELSE 'High Risk (>40%)'
    END AS dti_band,
    Loan_Status,
    COUNT(*) AS total
FROM loan
WHERE (ApplicantIncome + CoapplicantIncome) > 0
GROUP BY dti_band, Loan_Status
ORDER BY dti_band, Loan_Status;

-- 5. Approval by Loan Amount Size
SELECT 
    CASE 
        WHEN LoanAmount < 100 THEN 'Small Loan (<100k)'
        WHEN LoanAmount BETWEEN 100 AND 200 THEN 'Medium Loan (100k-200k)'
        ELSE 'Large Loan (>200k)'
    END AS loan_size,
    Loan_Status,
    COUNT(*) AS total
FROM loan
WHERE LoanAmount IS NOT NULL
GROUP BY loan_size, Loan_Status
ORDER BY loan_size, Loan_Status;

-- 6. Approval by Property Area
SELECT Property_Area, Loan_Status, COUNT(*) AS total
FROM loan
GROUP BY Property_Area, Loan_Status
ORDER BY Property_Area, Loan_Status;

-- 7. Approval by Dependents
SELECT Dependents, Loan_Status, COUNT(*) AS total
FROM applicant a
JOIN loan l ON a.applicant_id = l.applicant_id
GROUP BY Dependents, Loan_Status
ORDER BY Dependents, Loan_Status;

-- 8. Approval by Education Level
SELECT a.Education, l.Loan_Status, COUNT(*) AS total
FROM applicant a
JOIN loan l ON a.applicant_id = l.applicant_id
GROUP BY a.Education, l.Loan_Status
ORDER BY a.Education, l.Loan_Status;

-- 9. Approval by Employment Status (Self Employed)
SELECT a.Self_Employed, l.Loan_Status, COUNT(*) AS total
FROM applicant a
JOIN loan l ON a.applicant_id = l.applicant_id
GROUP BY a.Self_Employed, l.Loan_Status
ORDER BY a.Self_Employed, l.Loan_Status;

-- 10. Combine Credit History + DTI
SELECT 
    c.Credit_History,
    CASE 
        WHEN (LoanAmount / (ApplicantIncome + CoapplicantIncome)) < 0.2 THEN 'Low DTI'
        WHEN (LoanAmount / (ApplicantIncome + CoapplicantIncome)) BETWEEN 0.2 AND 0.4 THEN 'Medium DTI'
        ELSE 'High DTI'
    END AS dti_band,
    Loan_Status,
    COUNT(*) AS total
FROM loan l
JOIN credit_history c ON l.Loan_ID = c.Loan_ID
WHERE (ApplicantIncome + CoapplicantIncome) > 0
GROUP BY c.Credit_History, dti_band, Loan_Status
ORDER BY c.Credit_History, dti_band, Loan_Status;


-- ========================== outliers ==============================
-- An outlier is a data point that is significantly different from the majority of values in a dataset much higher or lower than what is typical.
-- no need in this credit risk analysis project. because project looks so reality with real values
