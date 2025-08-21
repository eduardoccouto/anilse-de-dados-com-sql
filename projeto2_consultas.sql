 -- # Análise do perfil de clientes do e-commerce
 --1) Gênero dos leads

select 
	gender.gender as "gênero",
	count(*) as "leads(#)"
	
from 
	sales.customers as cus
left join 
	temp_tables.ibge_genders as gender
on 
	lower(gender.first_name) = lower(cus.first_name)
group by 
	"gênero";

-- 2)status profissional dos leads

select ((count(*)::float * 100) / (select count(*) from sales.customers))/100 as "lead(%)",
case
	when professional_status = 'freelancer' then 'Freelancer'
	when professional_status = 'retired' then 'Aposentado'
	when professional_status = 'clt' then 'CLT'
	when professional_status = 'self_employed' then 'Autônomo'
	when professional_status = 'other' then 'Outro'
	when professional_status = 'businessman' then 'Empresário'
	when professional_status = 'civil_servant' then 'Funcionário público'
	when professional_status = 'student' then 'Estudante'
	end as "status profissional",
count(*) as qnt
from sales.customers 
group by professional_status
order by "lead(%)";


-- 3) idade dos leads


select
count(*)::float  / (select count(*) from sales.customers) as "lead(%)",
	case
		when (current_date - birth_date)/365 < 20 then '0-20'
		when (current_date - birth_date)/365 < 40 then '20-40'
		when (current_date - birth_date)/365 < 60 then '40-60'
		when (current_date - birth_date)/365 < 80 then '60-80'
		else '80+'
		end as idade
	
from sales.customers
group by idade ;


--4) Faixa salarial dos leads
select
	count(*)::float / (select count(*) from sales.customers) as "leads(%)",
	case 
		when income < 2000 then '0-2000'
		when income <4000 then '2000-4000'
		when income <6000 then '4000-6000'
		when income <10000 then '6000-10000'
		else '+ 10000'
		end as "Faixa salarial"
from sales.customers
group by "Faixa salarial";

--5) classificação dos veículos (novom seminovo)


with classificacao_ as 
(
select 
	(extract('year' from fun.visit_page_date)::int - pro.model_year::int) as "idade do veiculo",
	fun.visit_page_date,
		case 
			when extract('year' from fun.visit_page_date)::int - pro.model_year::int < 3  then 'Novo'
			else 'Seminovo'
		end as classificacao
	from sales.products as pro
	left join sales.funnel as fun
	on pro.product_id = fun.product_id
)
select 
	count(*) as visitas,
	classificacao
from 
	classificacao_
group by 
	classificacao;


--6)idade dos veiculos visitados
with classificacao_ as 
(
s
select 
	count(*) as visitas,
	classificacao
from 
	classificacao_
group by 
	classificacao;
	



with visitas_ as (select 
	fun.visit_page_date,
	(extract('year' from fun.visit_page_date)::int - pro.model_year::int) as "idade do veiculo",
	
	
	case 
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 2 then 'até 2 anos'
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 4 then 'de 2 à 4 anos'
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 6 then 'de 4 à 6 anos'
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 8 then 'de 6 à 8 anos'
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 10 then 'de 8 à 10 anos'
		
		else 'acima de 10 anos'
	end as idade_veiculo,
	case 
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 2 then 1
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 4 then 2
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 6 then 3
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 8 then 4
		when (extract('year' from fun.visit_page_date)::int - pro.model_year::int) <= 10 then 5
		
		else 6
	end as ordem

	
	from sales.products as pro
	left join sales.funnel as fun
	on pro.product_id = fun.product_id
	
)	
select
	count(*)::float/(select count(*) from sales.funnel) as "veículos visitados (%)",
	idade_veiculo, ordem
from visitas_
group by idade_veiculo, ordem
order by ordem;


--Veículos mais visitador por marca

select * from sales.products limit 5;


select * from sales.funnel limit 5;


select 
	count(*) as visitas,
	pro.brand,
	pro.model

from sales.funnel as fun
left join sales.products as pro
on fun.product_id = pro.product_id
group by pro.brand, pro.model
order by pro.brand

