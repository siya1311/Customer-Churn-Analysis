create database telco_churn;
use telco_churn;

-- Verfying if the database worked.
select database();

-- Checking the table
show tables;

select * from customers 
limit 5;

-- Overall Churn Rate 
select count(*) as total_customers,
sum(`Churn Value`) as customers_churned,
round(sum(`Churn Value`) / count(*) * 100, 2) as churn_rate
from customers;

-- Churn Rate by Contract Type
select contract, 
count(*) as total_customers, 
sum(`Churn Value`) as customers_churned,
round(sum(`Churn Value`) / count(*) * 100, 2) as churn_rate
from customers
group by contract 
order by churn_rate desc;

-- Churn Rate by Internet Service 
select `Internet Service`,
count(*) as total_customers,
sum(`Churn Value`) as customers_churned, 
round(sum(`Churn Value`) / count(*) * 100, 2) as churn_rate
from customers
group by `Internet Service` 
order by churn_rate desc;

-- Churn by Payment Method 
select `Payment Method`,
count(*) as total_customers,
sum(`Churn Value`) as customers_churned, 
round(sum(`Churn Value`) / count(*) * 100, 2) as churn_rate
from customers
group by `Payment Method` 
order by churn_rate desc;

-- Churn by Tenure Group 
select `Tenure Group`,
count(*) as total_customers,
sum(`Churn Value`) as customers_churned, 
round(sum(`Churn Value`) / count(*) * 100, 2) as churn_rate
from customers
group by `Tenure Group` 
order by churn_rate desc;
/* Churn decreases as customer tenure increases */

-- Churn by Contract & Internet Service
select contract, `Internet Service`,
count(*) as total_customers,
sum(`Churn Value`) as customers_churned, 
round(sum(`Churn Value`) / count(*) * 100, 2) as churn_rate
from customers
group by contract, `Internet Service` 
order by churn_rate desc;
/* Month-to-month + fiber optic customers have a 54.61% churn rate */

-- Do customers paying more each month churn more?
select `Churn Label`,
count(*) as total_customers,
round(avg(`Monthly Charges`), 2) as avg_monthly_charges,
round(avg(`Total Charges`), 2) as avg_total_charges
from customers
group by `Churn Label`;
/* Customers with higher monthly charges may require additional retention attention, especially when 
combined with other high-risk characteristics such as month-to-month contracts and shorter tenure. */

/* For the customers who haven't churnet yet, which customer segements have a combination of 
potentially risky characteristics and higher monthly charges? */
select Contract, `Internet Service`, `Tenure Group`,
count(*) as current_customers,
round(avg(`Monthly Charges`), 2) as avg_monthly_charges
from customers
where `Churn Label` = 'No'
group by Contract, `Internet Service`, `Tenure Group`
having count(*) >= 100
order by avg_monthly_charges desc;
/* Among customers who have not churned, the highest average monthly charges are within
fiber optic customers, especially those with longer term contracts. */ 

-- month-to-month + fiber optic + 0-6 months = 74.15% churn 