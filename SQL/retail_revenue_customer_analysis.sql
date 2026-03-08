-- ===================================
-- Online Retail SQL Analysis Project
-- Dataset: Online Retail
-- Author: Manas Joshi
-- Tool: DBeaver
-- Database: PostgreSQL
-- ===================================


-- 1. Preview data

select * 
from online_retail_v2 orv 
limit 10;

-- 2. Row Count
select count(*)
from online_retail_v2 orv;

-- 3. Total Revenue
select sum(quantity*unitprice) as total_revenue from online_retail_v2 orv

-- 4. Revenue by country
select country, sum(unitprice*quantity) as revenue 
from online_retail_v2 orv
group by country
order by revenue desc;

-- 5. Top 10 selling products
select description, sum(quantity) as total_quantity
from online_retail_v2 orv 
group by description
order by sum(quantity) desc
limit 10;

-- 6. Highest Revenue Products
select description, sum(quantity) as total_quantity, sum(quantity*unitprice) as total_revenue
from online_retail_v2 orv 
group by description 
order by total_revenue desc
limit 10;

-- 7. Month wise revenue
select date_trunc('month', to_timestamp(invoicedate, 'MM/DD/YYYY H24:MI')) as month,
sum(unitprice*quantity)as revenue
from online_retail_v2 orv 
group by month
order by revenue desc;

-- 8. Total number of cancellations

select count(*) from online_retail_v2 orv
where orv.invoiceno like 'C%';


-- 9. Return Rate
select 
count(*) filter(where invoiceno like 'C%')* 100.0 / count(*) as return_rate
from online_retail_v2;


-- 10. Repeat Customer behaviour
select customerid, count(distinct invoiceno), sum(quantity*unitprice) as revenue
from online_retail_v2
where customerid is not null and invoiceno not like 'C%'
group by customerid
having count(invoiceno) > 1
order by revenue desc


-- 11. Revenue lost due to cancellations

select customerid, sum(quantity * unitprice)as revenue, count(distinct invoiceno) as count
from online_retail_v2 orv 
where invoiceno like 'C%'
group by customerid
order by count desc, revenue


-- 12. Normal vs cancelled transactions

select 
case when invoiceno like 'C%' then 'Cancelled'
else 'Completed'
end as order_status,
count(*) as transaction_count,
sum(quantity*unitprice) as revenue
from online_retail_v2
group by order_status 
