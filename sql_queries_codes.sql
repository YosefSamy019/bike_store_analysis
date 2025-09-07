-- Use database
use BikeStores

-- Explore database
select top(5) * from sales.customers
select top(5) * from sales.order_items
select top(5) * from sales.orders
select top(5) * from sales.staffs
select top(5) * from sales.stores

select top(5) * from production.brands
select top(5) * from production.categories
select top(5) * from production.products
select top(5) * from production.stocks


-- Avg list price for each Brand
select b.brand_name as [Brand Name], AVG(p.list_price) as [AVG Price]
from production.products p
inner join production.brands b
on p.brand_id = b.brand_id
group by b.brand_name
order by [AVG Price] desc


-- Avg list price for each Category
select c.category_name as [Category Name], AVG(p.list_price) as [AVG Price]
from production.products p
inner join production.categories c
on p.brand_id = c.category_id
group by c.category_name
order by [AVG Price] desc

-- Quantity stored for each store
select ss.store_name as [Store Name], SUM(ps.quantity) as [Total Quantity]
from production.stocks ps
inner join sales.stores ss
on ps.store_id = ss.store_id
group by ss.store_name
order by [Total Quantity]

-- N Customers
select count(distinct sc.customer_id) as [Total Customers]
from sales.customers sc

-- Avg (delivery take, from order date to shipping date) per each store
select AVG(1.0 * DATEDIFF(DAY, so.order_date, so.shipped_date)) as [Avg taken days to ship]
from sales.orders so
where so.shipped_date > so.order_date
group by so.store_id
order by [Avg taken days to ship] desc

-- N Staff for each store
select sto.store_name as [Store Name], count(sta.staff_id) as [N Staffs]
from sales.staffs sta
inner join sales.stores as sto
on sta.store_id = sto.store_id
group by sto.store_name

-- N stores
select count(distinct ss.store_id) as [N stores]
from sales.stores ss

-- Total Sales per each store
select ss.store_name as [Store Name], SUM(soi.quantity * soi.list_price * (1.0 - soi.discount)) as [Total Sales after discount]
from sales.order_items soi
inner join sales.orders so
on so.order_id = soi.order_id
inner join sales.stores ss
on ss.store_id = so.store_id
group by ss.store_name

-- Total Sales per each staff
select 
	ss.first_name + ' ' + ss.last_name as [Staff Name], 
	SUM(soi.quantity * soi.list_price * (1.0 - soi.discount)) as [Total Sales after discount]
from sales.order_items soi
inner join sales.orders so
on so.order_id = soi.order_id
inner join sales.staffs ss
on ss.store_id = so.store_id
group by ss.first_name + ' ' + ss.last_name
order by [Total Sales after discount] desc


-- Total Buy per each customer, TOP(10) only
select top(10) 
	sc.first_name + ' ' + sc.last_name as [Store Name], 
	SUM(soi.quantity * soi.list_price * (1.0 - soi.discount)) as [Total Buy after discount],
	COUNT(distinct so.order_id) as [N Orders paid],
	COUNT(soi.item_id) as [N items paid]
from sales.order_items soi
inner join sales.orders so
on so.order_id = soi.order_id
inner join sales.customers sc
on sc.customer_id = so.customer_id
group by sc.first_name + ' ' + sc.last_name
order by [Total Buy after discount] desc

