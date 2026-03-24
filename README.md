# &#x20;        **BANK CUSTOMER CHURN ANALYSIS**





## Project Overview 

This Project analyzes customer churn behavior using SQL and Power BI. The goal is to identify key factors that influence customer churn and provide actionable insights.





## What is churn?

Churn refers to customers leaving bank or stopping usage of its services. Understanding churn helps in improving retention strategies.





## Dataset

The dataset contains information about bank customers including: 



* **customer\_id:** Unique identifier for each customer
* **credit\_score:** Customer's credit score
* **age:** Customer's age in years
* **gender:** Customer's gender (Male/Female)
* **country:** Country of the customer
* **tenure:** Number of years the customer has been with the bank
* **balance:** Account balance amount 
* **estimated\_salary**: Customer's estimated annual salary
* **product\_number:** Number of bank products the customer owns
* **credit\_card:** 1 = has credit card , 0 = no 
* **active\_member:** 1 = active customer , 0 = inactive 
* **churn:** 1 = customer churned , 0 = retained



###### Additional / Engineered Features:



* &#x20;**salary\_quartile:** Customer’s salary segment (1–4 quartiles)  
* &#x20;**age\_group:** Age category of the customer (Young, Middle Aged, Mature Adults, Senior)  
* &#x20;**credit\_score\_category:** Credit score segment (Very Poor, Poor, Fair, Good, Excellent)  
* &#x20;**balance\_group:** Account balance category (0, 0-50K, 50-100K, 100K+ ) 





> All dataset files are located in the `data` folder.  





## Tools \& Technologies

* MySQL – data extraction, aggregation, and exploratory data analysis  
* Power BI Desktop – dashboard visualization  
* CSV – data source 





## DASHBOARD



!\[Dashboard](images/Churn\_Analysis\_PowerBI.png)







## INSIGHTS / KEY FINDINGS 



* Non-active members have higher churn rates  
* Customers with credit cards show slightly lower churn  
* Higher salary quartiles have slightly higher churn, but differences are minimal  
* Mature adults have the highest churn among age groups  







## RECOMMENDATIONS / BUSSINES SUGGESTIONS



* Focus retention efforts on non-active members  
* Consider incentives for high-salary customers to reduce churn  
* Promote credit card adoption to potentially decrease churn rates  
* Customers with 2 products have the lowest churn rate, while churn increases significantly for customers with 3 or more products.
* \- High churn rates for customers with 3 and 4 products should be interpreted with caution due to small sample sizes.





## Conclusion



The analysis shows that behavioral factors, such as active membership, influence churn more than demographics.  

These insights can guide targeted marketing and retention strategies for the bank.























































