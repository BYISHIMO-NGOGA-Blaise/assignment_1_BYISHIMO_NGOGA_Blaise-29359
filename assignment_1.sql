-- assignment 1 - sunrise supermarket
-- run everything from top to bottom
-- database name: supermarket (created by admin, not runnable here)

set define off;

-- remove old tables so we can run again
drop table order_items cascade constraints;
drop table orders cascade constraints;
drop table products cascade constraints;
drop table customers cascade constraints;

-- create tables
create table customers (
    customer_id number primary key,
    customer_name varchar2(100),
    email varchar2(100),
    city varchar2(50)
);

create table products (
    product_id number primary key,
    product_name varchar2(100),
    category varchar2(50),
    price number(10,2)
);

create table orders (
    order_id number primary key,
    customer_id number references customers(customer_id),
    order_date date
);

create table order_items (
    order_item_id number primary key,
    order_id number references orders(order_id),
    product_id number references products(product_id),
    quantity number
);

-- add sample data
insert into customers values (1, 'Alice Uwase',   'alice.uwase@mail.com',   'Kigali');
insert into customers values (2, 'Bob Mugisha',   'bob.mugisha@mail.com',   'Kigali');
insert into customers values (3, 'Carol Keza',    'carol.keza@mail.com',    'Huye');
insert into customers values (4, 'David Nshuti',  'david.nshuti@mail.com',  'Musanze');
insert into customers values (5, 'Eve Ingabire',  'eve.ingabire@mail.com',  'Kigali');
insert into customers values (6, 'Frank Habimana','frank.habimana@mail.com','Rubavu');

insert into products values (101, 'Fresh Milk 1L',      'Dairy & Eggs', 1.80);
insert into products values (102, 'Cheddar Cheese 200g', 'Dairy & Eggs', 4.50);
insert into products values (103, 'White Bread',         'Bakery',       1.50);
insert into products values (104, 'Croissant',           'Bakery',       2.00);
insert into products values (105, 'Ground Coffee 250g',  'Beverages',    6.20);
insert into products values (106, 'Green Tea 20 bags',   'Beverages',    3.40);
insert into products values (107, 'Orange Juice 1L',     'Beverages',    2.90);
insert into products values (108, 'Potato Chips',        'Snacks',       1.25);
insert into products values (109, 'Chocolate Bar',       'Snacks',       1.10);
insert into products values (110, 'Dish Soap',           'Household',    2.30);

insert into orders values (1,  1, date '2026-08-01');
insert into orders values (2,  2, date '2026-08-02');
insert into orders values (3,  3, date '2026-08-04');
insert into orders values (4,  4, date '2026-08-05');
insert into orders values (5,  5, date '2026-08-07');
insert into orders values (6,  1, date '2026-08-10');
insert into orders values (7,  2, date '2026-08-12');
insert into orders values (8,  3, date '2026-08-15');
insert into orders values (9,  4, date '2026-08-16');
insert into orders values (10, 5, date '2026-08-19');
insert into orders values (11, 1, date '2026-08-22');
insert into orders values (12, 2, date '2026-08-25');
insert into orders values (13, 3, date '2026-08-28');
insert into orders values (14, 4, date '2026-09-01');
insert into orders values (15, 5, date '2026-09-03');
insert into orders values (16, 1, date '2026-09-08');

insert into order_items values (1,  1,  101, 2);
insert into order_items values (2,  1,  103, 3);
insert into order_items values (3,  1,  105, 1);
insert into order_items values (4,  2,  107, 2);
insert into order_items values (5,  2,  108, 4);
insert into order_items values (6,  3,  102, 1);
insert into order_items values (7,  3,  104, 2);
insert into order_items values (8,  4,  106, 2);
insert into order_items values (9,  4,  109, 3);
insert into order_items values (10, 5,  105, 2);
insert into order_items values (11, 5,  110, 1);
insert into order_items values (12, 6,  101, 3);
insert into order_items values (13, 6,  103, 2);
insert into order_items values (14, 6,  107, 1);
insert into order_items values (15, 7,  102, 2);
insert into order_items values (16, 7,  108, 2);
insert into order_items values (17, 8,  105, 1);
insert into order_items values (18, 8,  109, 2);
insert into order_items values (19, 8,  104, 3);
insert into order_items values (20, 9,  103, 4);
insert into order_items values (21, 9,  106, 1);
insert into order_items values (22, 9,  110, 2);
insert into order_items values (23, 10, 107, 3);
insert into order_items values (24, 10, 108, 3);
insert into order_items values (25, 11, 102, 3);
insert into order_items values (26, 11, 105, 1);
insert into order_items values (27, 11, 103, 2);
insert into order_items values (28, 12, 101, 5);
insert into order_items values (29, 13, 106, 3);
insert into order_items values (30, 13, 104, 4);
insert into order_items values (31, 14, 105, 2);
insert into order_items values (32, 14, 109, 4);
insert into order_items values (33, 15, 110, 3);
insert into order_items values (34, 15, 107, 2);
insert into order_items values (35, 16, 105, 3);
insert into order_items values (36, 16, 102, 2);
insert into order_items values (37, 16, 104, 2);

commit;

-- question 1: join orders and customers
select o.order_id, c.customer_name, c.city, o.order_date
from orders o
inner join customers c on o.customer_id = c.customer_id
order by o.order_id;

-- question 2: join order_items and products
select oi.order_item_id, oi.order_id, p.product_name,
p.category, p.price, oi.quantity
from order_items oi
join products p on oi.product_id = p.product_id
order by oi.order_id, oi.order_item_id;

-- question 3: all customers even the ones with no order
select c.customer_id, c.customer_name, c.city, o.order_id, o.order_date
from customers c
left join orders o on c.customer_id = o.customer_id
order by c.customer_id, o.order_id;

-- question 4: customers who spent more than the average (cte)
with totals as (
    select c.customer_name,
    nvl(sum(oi.quantity * p.price), 0) as total_spent
    from customers c
    left join orders o on c.customer_id = o.customer_id
    left join order_items oi on o.order_id = oi.order_id
    left join products p on oi.product_id = p.product_id
    group by c.customer_name
)
select customer_name, round(total_spent, 2) as amount
from totals
where total_spent > (select avg(total_spent) from totals)
order by total_spent desc;

-- question 5: rank customers by how much they spent (rank)
with totals as (
    select c.customer_name,
    nvl(sum(oi.quantity * p.price), 0) as total_spent
    from customers c
    left join orders o on c.customer_id = o.customer_id
    left join order_items oi on o.order_id = oi.order_id
    left join products p on oi.product_id = p.product_id
    group by c.customer_name
)
select customer_name, round(total_spent, 2) as amount,
rank() over (order by total_spent desc) as position
from totals
order by position;

-- question 6: number of each customer's orders (row_number)
select c.customer_name, o.order_id, o.order_date,
row_number() over (partition by c.customer_id order by o.order_date) as order_no
from customers c
join orders o on c.customer_id = o.customer_id
order by c.customer_name, o.order_date;

-- question 7: running total of revenue (sum over)
with rev as (
    select o.order_id, o.order_date,
    sum(oi.quantity * p.price) as total
    from orders o
    join order_items oi on o.order_id = oi.order_id
    join products p on oi.product_id = p.product_id
    group by o.order_id, o.order_date
)
select order_id, order_date, round(total, 2) as revenue,
round(sum(total) over (order by order_date), 2) as running_total
from rev
order by order_date;

-- question 8: days between current and previous order (lag)
with gaps as (
    select o.customer_id, o.order_id, o.order_date,
    lag(o.order_date) over (partition by o.customer_id order by o.order_date) as prev_date
    from orders o
)
select c.customer_name, g.order_id, g.order_date, g.prev_date,
(g.order_date - g.prev_date) as days_between
from gaps g
join customers c on g.customer_id = c.customer_id
where g.prev_date is not null
order by c.customer_name, g.order_date;