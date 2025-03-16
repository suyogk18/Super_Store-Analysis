
create table store_record(
order_id int primary key,
order_date date,
ship_mode varchar(50),
segment varchar(50),
country varchar(50),
city varchar(50),
state varchar(50),
region varchar(50),
product_id varchar(50),
category varchar(50),
sub_category varchar(50),
product_name varchar(100),
sales decimal(7,2),
quantity int,
profit decimal(7,2),
payment_mode varchar(50)
)

alter table store_record alter column product_name type  varchar(255)

select * from store_record

Q1. Find the top 10 highest selling product?

select product_id, sum(sales) as S
from store_record
group by product_id
order by S desc limit 10

Q2. Find top 5 highest selling product in each region?

with cte as (
select region, product_id, sum(sales) as S
from store_record
group by region, product_id)
select * from(
select * ,
row_number () over (partition by region order by S desc) as rn
from cte ) A
where rn<=5

Q3. Find MOM growth comparison od 2019 and 2020 sales?

select * from store_record

with cte AS (
    select 
        EXTRACT(YEAR FROM order_date) AS year, 
        EXTRACT(MONTH FROM order_date) AS month, 
        sum(sales) AS total_sales
    from store_record
    group by year, month
    order by year, month
)
select 
    month,
    sum(case WHEN year = 2019 THEN total_sales ELSE 0 END) AS sales_2019,
    sum(case WHEN year = 2020 THEN total_sales ELSE 0 END) AS sales_2020
from cte
group by month
order by month

Q4. Find the highest monthly sales for each category?

select category from store_record

with cte as(
select category, To_char (order_date, 'yyyymm') as format_date,
sum(sales) as S 
from store_record
group by category, To_char (order_date, 'yyyymm')
-- order by category, To_char (order_date, 'yyyymm')
)
select * from (
select * ,
row_number () over (partition by category order by S desc) as rn
from cte)
A
where rn=1


Q5. Which sub category has highest growth by profit in 2020 compare to 2019?

select * from store_record

WITH cte AS (
    SELECT 
        sub_category,
        EXTRACT(YEAR FROM order_date) AS year, 
        -- EXTRACT(MONTH FROM order_date) AS month, 
        SUM(sales) AS total_sales
    FROM store_record
    GROUP BY sub_category, year
)
SELECT 
    sub_category,
    -- month,
    SUM(CASE WHEN year = 2019 THEN total_sales ELSE 0 END) AS sales_2019,
    SUM(CASE WHEN year = 2020 THEN total_sales ELSE 0 END) AS sales_2020
FROM cte
GROUP BY sub_category, year
ORDER BY sub_category, year;



