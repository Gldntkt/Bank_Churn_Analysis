#----------------   EXPLORATORY DATA ANALYSIS: BANK CHURN CUSTOMERS   ----------------#

CREATE DATABASE bank_project;
USE bank_project;

-- First ten rows
SELECT * FROM churn_data LIMIT 10;

-- about data;
DESCRIBE churn_data;

-- Checked fro duplicates
SELECT customer_id,COUNT(*)
FROM churn_data
GROUP BY customer_id
HAVING COUNT(*) > 1;
# No duplicates founded in data

-- Checking for missing values
SELECT 
COUNT(*) - COUNT(customer_id) AS customer_id_null,
COUNT(*) - COUNT(age) AS age_null,
COUNT(*) - COUNT(balance) AS balance_null,
COUNT(*) - COUNT(credit_score) AS credit_null,
COUNT(*) - COUNT(tenure) AS tenure_null
FROM churn_data;
# There is no missing values

-- How many customers are there ?
SELECT COUNT(*) FROM churn_data;
# There are 10000 Customers in churn_data 

-- What is the average balance ?
SELECT ROUND(AVG(balance),2) FROM churn_data;
# The average balance is 76,485.89


#---------------- CUSTOMERS DEMOGRAPHICS ----------------#

-- Customer count  per country
SELECT country, COUNT(*) AS total_customer FROM churn_data
GROUP BY country;
# France	5014
# Spain	    2477
# Germany	2509

-- Customers's sex
SELECT gender,COUNT(*) AS total_customer FROM churn_data
GROUP BY gender;
# Female	4543
# Male	    5457

-- Age distrubution
SELECT MIN(age),MAX(age) FROM churn_data;
# 18,92 

-- Adding a new column to categorized ages
ALTER TABLE churn_data
ADD age_group VARCHAR(50); 

UPDATE churn_data
SET age_group = CASE 
WHEN age < 30 then 'Young (18-29)'
WHEN age < 50 THEN 'Middle-aged (30-50)'
WHEN age < 65 THEN 'Mature Adult (50-65)'
else 'Senior 65-92' 
END
 ;

-- Some of the category explanations is wrong and needed to change
UPDATE churn_data
SET age_group = CASE 
WHEN age < 30 then 'Young (18-29)'
WHEN age < 50 THEN 'Middle-aged (30-49)'
WHEN age < 65 THEN 'Mature Adult (50-64)'
else 'Senior (65-92)' 
END
;

-- Credit score distrubution 
SELECT MIN(credit_score),MAX(credit_score) FROM churn_data;
#30,850

-- Adding a new column to categorized credit scores
ALTER TABLE churn_data
ADD credit_score_category VARCHAR(50);

UPDATE churn_data
SET credit_score_category = CASE 
WHEN credit_score < 500 THEN 'Very Poor (350,499)'
WHEN credit_score < 600 THEN 'Poor (500,599)'
WHEN credit_score < 700 THEN 'Fair (600,699)'
WHEN credit_score < 800 then 'Good (700,799)'
ELSE 'Excellent (800,850)'
END;


#---------------- CHURN ANALYSIS ----------------#

-- churn rate
SELECT churn, COUNT(churn) FROM churn_data
GROUP BY churn;
# 1:2037 , 0:7963

-- Churn percentages
SELECT 
	churn,
    COUNT(churn) as total_customer,
    CONCAT(ROUND( COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () ,2) , '%') AS churn_percentage
FROM churn_data 
GROUP BY churn;
# 1: %20.37 , 0: %79.63 


-- Churn rate based on country 
SELECT country, AVG(churn) as churn_rate 
FROM churn_data 
GROUP BY country
ORDER BY churn_rate DESC;
# GERMANY: 0.3244
# SPAİN: 0.1667
# FRANCE: 0.1615

-- Churn rate based on age
SELECT age,AVG(churn) as churn_rate 
FROM churn_data
GROUP BY age 
ORDER BY churn_rate DESC;
#The top 3 highest churn rates based on age are:
# 1: Age 56: 0.71
# 2: Age 52: 0.63
# 3: Age 54: 0.61

SELECT age_group,AVG(churn) AS churn_rate
FROM churn_data
GROUP BY age_group
ORDER BY churn_rate DESC;
# Age group with the highest churn rate: Mature Adult (0.53)

-- Churn rate based on active customers
SELECT 
	active_member,
	CONCAT(ROUND(AVG(churn)*100.0 ,2),'%') as churn_rate 
FROM churn_data
GROUP BY active_member;
# The highest churn rate belongs to the non_active members with the rate of %26.85


-- Churn rate based on credit card 
SELECT credit_card, AVG(churn) as churn_rate
FROM churn_data 
GROUP BY credit_card
ORDER BY churn_rate;
# Customers who have credit card have slightly lower churn rate (1: 0.2018 , 0: 0.2081)

-- Churn variation with credit score category
SELECT
	credit_score_category,
    COUNT(CASE WHEN churn=1 THEN 1 END) AS num_of_churn_customer 
FROM churn_data
GROUP BY credit_score_category
ORDER BY num_of_churn_customer DESC;
# Fair (600,699):	     753
# Poor (500,599):	     510
# Good (700,799):	     496
# Very Poor (350,499):   150
# Excellent (800,850):   128

-- Churn variation with age category
SELECT age_group, COUNT(CASE WHEN churn=1 THEN 1 END) AS num_of_churn_customer
FROM churn_data
GROUP BY age_group
ORDER BY num_of_churn_customer DESC;
# Middle-aged (30-49):	1279
# Mature Adult (50-64):	591
# Young (18-29):        124
# Senior (65-92):       43

-- churn with gender
SELECT gender, COUNT(CASE WHEN churn=1 THEN 1 END) AS num_of_churn_customer
FROM churn_data
GROUP BY gender
ORDER BY num_of_churn_customer DESC;
# Female: 1139
# Male:	898

-- churn with country
SELECT country, COUNT(CASE WHEN churn=1 THEN 1 END) AS num_of_churn_customer
FROM churn_data
GROUP BY country
ORDER BY num_of_churn_customer DESC;
# Germany: 814
# France:  810
# Spain:   413

-- Churn with estimated_salary 
SELECT MIN(estimated_salary),ROUND(AVG(estimated_salary),2),MAX(estimated_salary) FROM churn_data;
# MIN: 11.58 ,	AVG: 100090.24 ,	MAX: 199992.48

-- Categorizating estimated_salary column to make anlysis
ALTER TABLE churn_data
ADD COLUMN salary_quartile INT;

UPDATE churn_data cd 
JOIN 
(SELECT customer_id, NTILE(4) OVER (ORDER BY estimated_salary) AS salary_quartile
FROM churn_data) sd 
ON cd.customer_id = sd.customer_id 
SET cd.salary_quartile = sd.salary_quartile;

SELECT 
	salary_quartile,
    MIN(estimated_salary) AS min_estimated_salary,
    Max(estimated_salary) AS max_estimated_salary,
    COUNT(*) AS total_customer,
    CONCAT(ROUND(SUM(churn)*100.0/COUNT(*),2),'%')as churn_rate FROM churn_data
GROUP BY salary_quartile 
ORDER BY salary_quartile;
# 1	11.58	    50974.57	2500	20.00% 
# 2	51011.29	100187.43	2500	19.80%
# 3	100200.4	149384.43	2500	20.12%
# 4	149399.7	199992.48	2500	21.56% 
# The fourth quartile highest estimated salary value has the highest percentage of churn.
# Nevertheless all percentages are so close to each other.


-- Churn with products_number
SELECT DISTINCT (products_number) FROM churn_data;

SELECT products_number,ROUND(AVG(churn),2) AS churn_rate
FROM churn_data
GROUP BY products_number
ORDER BY churn_rate;
# 2	 0.08
# 1	 0.28
# 3	 0.83
# 4  1.00
				
SELECT tenure, COUNT(CASE WHEN churn=1 THEN 1 END) AS num_of_churn_customer
FROM churn_data
GROUP BY tenure
ORDER BY num_of_churn_customer DESC;             
                
SELECT ROUND(AVG(balance),2) FROM churn_data;
# 76485.89

ALTER TABLE churn_data
ADD balance_group VARCHAR(20);

UPDATE churn_data
SET balance_group = 
CASE
    WHEN balance = 0 THEN '0'
    WHEN balance <= 50000 THEN '0-50K'
    WHEN balance <= 100000 THEN '50K-100K'
    ELSE '100K+'
END;

SELECT balance_group, AVG(churn) as churn_rate FROM churn_data
GROUP BY balance_group
ORDER BY churn_rate;
# 0	        0.1382
# 50K-100K	0.1988
# 100K+	    0.2523
# 0-50K	    0.3467

# -------------- For a visual overview of the analysis, pleas refer to the Power BI file. -------------- #


 


