use sakila;

describe actor;

-- 1a) 
select first_name, last_name from actor;

-- 1b)
select upper(concat(first_name, " ", last_name)) AS Actor_Name
FROM actor;

-- 2a)
select actor_id, first_name, last_name
from actor
where upper(first_name)="JOE";

-- 2b)
select actor_id, first_name, last_name
from actor
where upper(last_name) like "%GEN%";

-- 2c)
select actor_id, first_name, last_name
from actor
where upper(last_name) like "%LI%"
order by last_name, first_name;


describe country;

-- 2d)
select country_id, country
from country
where country in ("Afghanistan", "Bangladesh", "China");

-- 3a)
alter table actor
add description blob;

-- 3b)
alter table actor
drop description;

-- 4a)
select count(actor_id), last_name
FROM actor
group by last_name;

-- 4b)
select count(actor_id), last_name
from actor
group by last_name
having count(actor_id)>=2;

-- 4c)
update actor
set first_name = 'HARPO', last_name= 'WILLIAMS'
where first_name = 'GROUCHO'and last_name= 'WILLIAMS';

-- 4d)
update actor
set first_name = 'GROUCHO'
where first_name = 'HARPO'and last_name= 'WILLIAMS';

-- 5a)
create table address1 (
  address_id smallint(5) unsigned not null auto_increment,
  address char(50) not null,
  address2 char(50) null,
  district char(20) not null,
  city_id smallint(5) unsigned null,
  postal_code char(10) null,
  phone char(20) null,
  location geometry not null,
  last_update timestamp not null default current_timestamp,
  primary key (address_id),
  key (city_id),
  key (location)  
  );
  
  -- inspecting tables
describe address;
describe staff;
select count(address_id)
from address;
select count(address_id)
from staff;

-- 6a)
select first_name, last_name, address
from staff
inner join address
on staff.address_id = address.address_id;

-- inspecting tables
describe payment;
describe staff;

select count(staff_id)
from payment;

select count(staff_id)
from staff;

-- 6b)
select first_name, last_name, sum(amount) as total
from staff
join payment
on staff.staff_id = payment.staff_id
and payment_date like "2005-08%"
group by last_name;

-- 6c)
select title, count(actor_id) as num_actors
from film_actor
inner join film
on film_actor.film_id = film.film_id
group by title;

-- inspecting tables
select *
from film_actor;

select *
from film;

-- 6d)
select count(film_id) as "number of hunchback impossible movies"
from inventory
where film_id in (
        select film_id
        from film
		where title="Hunchback Impossible");
        
-- inspecting tables
describe payment;
describe customer;

-- 6e)
select first_name, last_name, sum(amount) as "Total Amount Paid"
from customer
join payment
on customer.customer_id = payment.customer_id
group by first_name, last_name
order by last_name;


-- 7a)
select *
from language;

select title, language_id
from film
where title like "K%" or title like "Q%"
group by title
having language_id=1;

-- inspecting tables
select *
from actor;

select *
from film_actor;

select *
from film;

-- 7b)
select first_name, Last_name, actor_id
from actor
where actor_id in (
select actor_id
from film_actor
where film_id in (
	select film_id
    from film
    where title="ALONE TRIP"));
    
 -- inspecting variables
select *
from customer;

select *
from country;

select *
from city;

select *
from address;

-- 7c)
select customer.first_name, customer.last_name, customer.email, country.country
from customer
join address
on customer.address_id=address.address_id
join city
on address.city_id=city.city_id
join country
on city.country_id=country.country_id
and country="CANADA";

 -- inspecting variables
select *
from category;

select *
from film;

select *
from film_category;

-- 7d)
select title
from film
where film_id in (
select film_id
from film_category
where category_id in (
	select category_id
    from category
    where name="Family"));
 
 -- inspecting variables
select *
from rental;

select *
from inventory;

select *
from film;

-- 7e)
select film.title, count(rental.inventory_id) as rent_numbers
from film
join inventory
on film.film_id=inventory.film_id
join rental
on inventory.inventory_id=rental.inventory_id
group by inventory.film_id
order by rent_numbers desc;

-- How to see how the view was created
#select view_definition
#from information_schema.views
#where table_name="sales_by_store";

-- checking views already in the schema
select *
from sales_amount_by_store;

select *
from sales_by_store;

select *
from sales_by_film_category
order by total_sales desc;

-- inspecting tables
select *
from payment;

select *
from inventory;

select *
from rental;

-- 7f)
select inventory.store_id,  sum(payment.amount) as sales_amount
from payment
join rental
on payment.rental_id=rental.rental_id
join inventory
on rental.inventory_id=inventory.inventory_id
group by inventory.store_id;

-- inspecting tables

select *
from store;

select *
from country;

select *
from city;

select *
from address;

-- 7g)
select store_id, city, country 
from store
join address
on store.address_id=address.address_id
join city
on address.city_id=city.city_id
join country
on city.country_id=country.country_id;

-- 7h)
select category.name,  sum(payment.amount) as sales_amount
from payment
join rental
on payment.rental_id=rental.rental_id
join inventory
on rental.inventory_id=inventory.inventory_id
join film_category
on inventory.film_id=film_category.film_id
join category
on film_category.category_id=category.category_id
group by category.category_id
order by sales_amount desc limit 5;

-- inspecting tables
select *
from payment;

select *
from inventory;

select *
from rental;

select *
from category;

select *
from film_category;

-- 8a)
create view top_five_genres as
select category.name,  sum(payment.amount) as sales_amount
from payment
join rental
on payment.rental_id=rental.rental_id
join inventory
on rental.inventory_id=inventory.inventory_id
join film_category
on inventory.film_id=film_category.film_id
join category
on film_category.category_id=category.category_id
group by category.category_id
order by sales_amount desc limit 5;

-- 8b)
select *
from top_five_genres;

-- 8c)
drop view top_five_genres;
