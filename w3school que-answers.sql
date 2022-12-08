
USE `w3schools`;


select * from Customers;
select * from Categories; 
select * from Employees; 
select * from Order_Details;
select * from Orders;
select * from Products;
select * from Shippers; 

/*1. Select customer name together with each order the customer made*/
select c.customername, o.orderid, employeeid, o.orderdate from customers as c
right join
orders as o on c.customerid=o.customerid
group by orderid order by customername;

-----------------------------------------------------------------------------------
/*2. Select order id together with name of employee who handled the order*/
select o.orderid, o.employeeid, o.orderdate, e.firstname, e.lastname from orders as o
inner join
employees as e on o.employeeid=e.employeeid;

--------------------------------------------------------------------------------------
/*3. Select customers who did not placed any order yet*/
select c.customername, c.city, c.country, o.orderid from customers as c
left join
orders as o on c.customerid=o.customerid
where o.customerid is NULL;

---------------------------------------------------------------------------------------
/*4. Select order id together with the name of products*/
select * from products;
select * from orders;
select distinct(productid) from order_details ;
select od.orderid, p.productname from order_details as od
join products as p on od.productid = p.productid
order by productname;

-------------------------------------------------------------------------------------------------
/*5. Select products that no one bought*/
select p.productid, p.productname, od.orderid from order_details as od
right join products as p on od.productid=p.productid
where od.orderid is NULL;

--------------------------------------------------------------------------------------------------
/*6. Select customer together with the products that he bought*/
select c.customerid, c.customername, p.productid, p.productname, o.orderid from customers as c
join orders as o on c.customerid=o.customerid
join order_details as od on o.orderid=od.orderid
right join products as p on od.productid = p.productid
order by c.customerid;

-----------------------------------------------------------------------------------------------------
/*7. Select product names together with the name of corresponding category*/
select p.productid, p.productname, c.categoryid, c.categoryname, c.`description` from products as p
join categories as c on p.categoryid=c.categoryid
order by c.categoryid;

------------------------------------------------------------------------------------------------------
/*8. Select orders together with the name of the shipping company*/
select o.orderid, s.shipperid, s.shippername, s.phone from orders as o
inner join shippers as s on o.shipperid=s.shipperid;

-------------------------------------------------------------------------------------------------------
/*9. Select customers with id greater than 50 together with each order they made*/
select * from customers as c
join orders as o on c.customerid=o.customerid
where c.customerid > 50;

--------------------------------------------------------------------------------------------------------
/*10. Select employees together with orders with order id greater than 10400*/
select e.employeeid, e.firstname, e.lastname, o.orderid, o.orderdate from employees as e
join orders as o on e.employeeid=o.employeeid
where o.orderid>10400;

---------------------------------------------------------------------------------------------------------
-- expert
/*1. Select the most expensive product*/
select * from products order by price desc limit 1;

----------------------------------------------------------------------------------------------------------
/*2. Select the second most expensive product*/
-- version 1
select * from products order by price desc limit 1,1;
-- version 2
select * from products order by price desc limit 1 offset 1;

----------------------------------------------------------------------------------------------------------
/*3. Select name and price of each product, sort the result by price in decreasing order*/
select productname, price from products order by price desc;

----------------------------------------------------------------------------------------------------------
/*4. Select 5 most expensive products*/
select productid, productname, price from products order by price desc limit 5;

---------------------------------------------------------------------------------------------------------
/*5. Select 5 most expensive products without the most expensive (in final 4 products)*/
select productid, productname, price from products order by price desc limit 5 offset 1;

---------------------------------------------------------------------------------------------------------
/*6. Select name of the cheapest product (only name) without using LIMIT and OFFSET*/
select productname from products where price = (select min(price) from products);

----------------------------------------------------------------------------------------------------------
/*7. Select name of the cheapest product (only name) using subquery*/
select productname from products  where price in ( select min(price) from products);

----------------------------------------------------------------------------------------------------------
/*8. Select number of employees with LastName that starts with 'D'*/
select count(employeeid) from employees where lastname like 'D%';

----------------------------------------------------------------------------------------------------------
/* BONUS : same question for Customer this time */
select count(customername) from customers where customername like 'D%';
select * from customers;
select customername, substring_index(customername," ",1) as first_name, substring_index(customername," ",-1) as last_name from customers
where substring_index(customername," ",-1) like "D%";

--------------------------------------------------------------------------------------------------------
/*9. Select customer name together with the number of orders made by the corresponding customer 
sort the result by number of orders in decreasing order*/
select c.customername, count(orderid) as total_orders from customers as c
join orders as o
on c.customerid=o.customerid
group by customername order by total_orders desc;

select c.customername, count(orderid) as total_orders from customers as c
join orders as o
on c.customerid=o.customerid
group by customername order by 2 desc, 1 asc;   # 2 desc means total_orders desc & 1 asc - customername asc

-------------------------------------------------------------------------------------------------------
/*10. Add up the price of all products*/
select sum(price) from products;

------------------------------------------------------------------------------------------------------------
/*11. Select orderID together with the total price of  that Order, order the result by total price of order in increasing order*/
select od.orderid, sum(p.price*od.quantity) as total_price from order_details as od
join products as p 
on od.productid=p.productid
group by od.orderid order by total_price;

---------------------------------------------------------------------------------------------------------------
/*12. Select customer who spend the most money*/
select c.customerid, c.customername, sum(od.quantity*p.price) as totalspend from customers as c
join orders as o on c.customerid=o.customerid
join order_details as od on o.orderid=od.orderid
join products as p on od.productid=p.productid
group by c.customerid order by totalspend desc limit 1;

----------------------------------------------------------------------------------------------------------
/*13. Select customer who spend the most money and lives in Canada*/
select c.customerid, c.customername, c.country, sum(od.quantity*p.price) as totalspend from customers as c
join orders as o on c.customerid=o.customerid
join order_details as od on o.orderid=od.orderid
join products as p on od.productid=p.productid
where c.country = 'canada'
group by c.customerid order by totalspend desc limit 1;

---------------------------------------------------------------------------------------------------
/*14. Select customer who spend the second most money*/

select c.customerid, c.customername, sum(od.quantity*p.price) as totalspend from customers as c
join orders as o on c.customerid=o.customerid
join order_details as od on o.orderid=od.orderid
join products as p on od.productid=p.productid
group by c.customerid order by totalspend desc limit 1 offset 1;

-----------------------------------------------------------------------------------------------------------
/*15. Select shipper together with the total price of proceed orders*/
select s.shipperid, s.shippername, sum(od.quantity*p.price) as orderprice from shippers as s
join orders as o on s.shipperid=o.shipperid
join order_details as od on o.orderid=od.orderid
join products as p on od.productid=p.productid
group by s.shipperid order by orderprice;
