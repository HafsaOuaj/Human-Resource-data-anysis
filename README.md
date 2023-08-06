# Human-Resource-data-anysis
### SQL(PostgreSQL) and data visualization with Power Bi

![Screenshot 2023-08-06 155802](https://github.com/HafsaOuaj/Human-Resource-data-anysis/assets/99544208/2f4bf877-91e9-40eb-83d6-96434a140d6a)
![Screenshot 2023-08-06 155829](https://github.com/HafsaOuaj/Human-Resource-data-anysis/assets/99544208/89c3db13-04de-49e4-b92d-842214040dc4)

## Data Used Project

* The data used is
* PostgreSQL for data cleaning and data anysis
* PowerBi for data visualization

## Question 
 In these project we want to answer the following questions :
   1. What is the gender and age distribution of the employees in the company?
   2. What is the race distribution of the employees in the company?
   3. How does the distribution of the job title in the company?
   4. How does the comapany's employee count changes by the time?
   5. What is the tenure distibution for each departement?
   6. hat is the average of the work years by gender and across the company?
![Screenshot 2023-08-06 130144](https://github.com/HafsaOuaj/Human-Resource-data-anysis/assets/99544208/7ba1f7b0-4985-40ec-8e7f-a7fd446cde0e)


## Summary 
* There are more male employees
* * The gender distribution across departments is fairly balanced but there are generally more male than female employees
*  5 age groups were created (18-25, 26-35, 36-45, 46-55, 56+). A large number of employees were between 25-34 followed by 36-45 while the smallest group was 56+.
* White race is the most dominant while Native Hawaiian and American Indian are the least dominant.
* A large number of employees work at the headquarters versus remotely.
* The Marketing department has the highest turnover rate followed by Training. The least turn over rate are in the Research and development, Support and Legal departments.
* A large number of employees come from the state of Ohio.
*The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales and Marketing having the lowest. 

## Limitations
* Some records had negative ages and these were excluded during querying(967 records).
* Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used were those less than or equal to the current date.
