 -- # Análise do perfil de clientes do e-commerce
 --1) Gênero dos leads

select * from temp_tables.ibge_genders limit 5;
 select * from sales.funnel limit 5;
 select * from sales.customers limit 5;

 from sales.funel as fun
 left join sales.customers as cus
 on fun.customer_id = cus.customer_id

--visitas por genero
with gender as (
	select fun.first_name, gender.gender,fun.customer_id
	from sales.customers as fun
	left join temp_tables.ibge_genders as gender
	on lower(fun.first_name) = lower(gender.first_name))
	
select count(fun2.visit_page_date) as visitas,
gender.gender 
from sales.funnel as fun2
left join gender
on fun2.customer_id = gender.customer_id
group by gender;


--total de clientes por genero
select gender.gender as genero, count(*) as total
	from sales.customers as fun
	left join temp_tables.ibge_genders as gender
	on lower(fun.first_name) = lower(gender.first_name)
group by genero;


with status_profissional as (
	select professional_status, count(*) as quantidade
	from sales.customers
	group by professional_status
)
select 
professional_status, (quantidade * 100)::float/(select sum(quantidade) from status_profissional)::float as "leads (%)"
from status_profissional
order by "leads (%)" desc;




