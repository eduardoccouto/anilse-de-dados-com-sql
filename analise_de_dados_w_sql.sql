select * 
from sales.products
where price not between 100000 and 20000;

select *
from sales.products
where brand in ('HONDA', 'TOYOTA');

select *
from sales.products
where brand not in ('HONDA', 'TOYOTA');


select distinct first_name
from sales.customers
where first_name like 'ANA%';


select distinct first_name
from sales.customers
where first_name ilike 'ana%'; --nao diferencia letra

select * 
from temp_tables.regions
where state = 'RS' and city ilike'taqua%';

--EXERCICIOS #######################

select * from sales.customers
limit 10
-- (Exercício 1) Calcule quantos salários mínimos ganha cada cliente da tabela 
-- sales.customers. Selecione as colunas de: email, income e a coluna calculada "salários mínimos"
-- Considere o salário mínimo igual à R$1200
select 
	email, 
	income,
	(income / 1200) as salarios_minimos
from
	sales.customers;

-- (Exercício 2) Na query anterior acrescente uma coluna informando TRUE se o cliente
-- ganha acima de 5 salários mínimos e FALSE se ganha 4 salários ou menos.
-- Chame a nova coluna de "acima de 4 salários"
select 
	email, 
	income,
	(income / 1200) as salarios_minimos,
	(income/1200 > 4) as validate_
from
	sales.customers;

-- (Exercício 3) Na query anterior filtre apenas os clientes que ganham entre
-- 4 e 5 salários mínimos. Utilize o comando BETWEEN

select 
	email, 
	income,
	(income / 1200) as salarios_minimos,
	(income/1200 > 4) as "acima de 4 salários"
from
	sales.customers
where income / 1200 between 4 and 5;

	

-- (Exercício 4) Selecine o email, cidade e estado dos clientes que moram no estado de 
-- Minas Gerais e Mato Grosso. 

select * from sales.customers
limit 10;
----------------------
select email, city, state
from sales.customers
where state in ('MG', 'MT');

-- (Exercício 5) Selecine o email, cidade e estado dos clientes que não 
-- moram no estado de São Paulo.

SELECT 
	email, 
	city,
	state
from
	sales.customers
where
	state not in('SP');
	

-- (Exercício 6) Selecine os nomes das cidade que começam com a letra Z.
-- Dados da tabela temp_table.regions
select city 
from temp_tables.regions
where city ilike 'z%'

--------------------------------------------------------------------------------
--								FUNÇÕES AGREGADORAS						      -- 
--------------------------------------------------------------------------------

SELECT *
from sales.funnel
limit 5;

--/média - máximo - mínimo/--
select count(distinct product_id) --(Quantas produtos foram visitados (distinct)?)
from sales.funnel
where visit_page_date between '2021-01-01' and '2021-01-31';


select min(price), max(price), avg(price)
from sales.products;


select max(price)
from sales.products;

select *
from
	sales.products
where 
	price = (select max(price) from sales.products);

--/group by/----

select state,  count(*) as contagem
from sales.customers
group by(state) 
order by contagem desc;

--exemplo: contagem agrupada de várias colunas
-- calcule o nº de clientes por estado e status professional
select state, professional_status, count(*) as contagem
from sales.customers
group by state, professional_status 
order by state, contagem desc;

--selecione os estaddos distindos na tabela customers utilizando o group by
select state from sales.customers
group by state
order by state;

-- //HAVING
select state, count(*) as client_number
from sales.customers
where state not in ('MG') --WHERE NAO FUNCIONA COM COLUNAS AGREGADAS
group by state
having count(*) > 100;

--**EXERCICIOS*--
-- (Exercício 1) Conte quantos clientes da tabela sales.customers tem menos de 30 anos

SELECT *
from sales.customers
limit 5;

select count(*)--, (current_date - birth_date) / 365 as age
from sales.customers
where (current_date - birth_date) / 365 < 30
--group by(age);

select count(*)
from sales.customers
where ((current_date - birth_date) / 365 ) < 30

-- (Exercício 2) Informe a idade do cliente mais velho e mais novo da tabela sales.customers
select 
	((current_date - max(birth_date))/365) as mais_novo,
	((current_date - min(birth_date))/365) as mais_velho
from
	sales.customers;

select 
	max((current_date - birth_date) / 365 ),
	min((current_date - birth_date) / 365 )
from sales.customers

-- (Exercício 3) Selecione todas as informações do cliente mais rico da tabela sales.customers
-- (possívelmente a resposta contém mais de um cliente)


select * 
from sales.customers
where income = (select max(income) from sales.customers);



-- (Exercício 4) Conte quantos veículos de cada marca tem registrado na tabela sales.products
-- Ordene o resultado pelo nome da marca

select * from sales.products
limit 3

select count(*), brand
from sales.products
group by(brand)
order by brand;

-- (Exercício 5) Conte quantos veículos existem registrados na tabela sales.products
-- por marca e ano do modelo. Ordene pela nome da marca e pelo ano do veículo

select count(*), model_year, brand
from sales.products
group by brand, model_year
order by brand, model_year

-- (Exercício 6) Conte quantos veículos de cada marca tem registrado na tabela sales.products
-- e mostre apenas as marcas que contém mais de 10 veículos registrados

select count(*), brand 
from sales.products
group by brand
having count(*) > 10

-- JOINS #######################

select * from temp_tables.tabela_1;

select * from temp_tables.tabela_2;

--left join
select t1.cpf, t1.name, t2.state
from temp_tables.tabela_1 as t1
left join temp_tables.tabela_2 as t2
on t1.cpf = t2.cpf;

--inner join
select t1.cpf, t1.name, t2.state
from temp_tables.tabela_1 as t1
inner join temp_tables.tabela_2 as t2
on t1.cpf = t2.cpf;

--right join

select t1.cpf, t1.name, t2.state
from temp_tables.tabela_1 as t1
right join temp_tables.tabela_2 as t2
on t1.cpf = t2.cpf;

-- EXERCÍCIOS ########################################################################

-- (Exercício 1) Identifique quais as marcas de veículo mais visitada na tabela sales.funnel

select 
	pro.brand,
	count(*) as visitas

from sales.funnel as fun
left join sales.products as pro
	on fun.product_id = pro.product_id
group by pro.brand
order by visitas desc


-- (Exercício 2) Identifique quais as lojas de veículo mais visitadas na tabela sales.funnel

select 
	sto.store_name,
	count(*) as visitas

from sales.funnel as fun
left join sales.stores as sto
	on fun.store_id = sto.store_id
group by sto.store_name
order by visitas desc



-- (Exercício 3) Identifique quantos clientes moram em cada tamanho de cidade (o porte da cidade
-- consta na coluna "size" da tabela temp_tables.regions)

select
	reg.size,
	count(*) as contagem
from sales.customers as cus
left join temp_tables.regions as reg
	on lower(cus.city) = lower(reg.city)
	and lower(cus.state) = lower(reg.state)
group by reg.size
order by contagem;

-- UNION ###################################

--união simmples de duas tabelas 
select * from sales.products
union all
select * from temp_tables.products_2;


--subquery ################################

--ex 1: SubQuery no WHERE
--Informar o veóculo mais barato da tabela products
select *
from 
	sales.products
where price = (select min(price) from sales.products); --nao funciona se a subquery retornar mais de 1 valor

--ex 2: SubQuery com With
--calcular a idade media dos clientes por status profissional

with age_by_customer as(
select 
	(current_date - birth_date)/365 as age,
	professional_status	from sales.customers
	)
select avg(age) as media, professional_status
from age_by_customer
group by professional_status;


--ex3: SuqQuery no from (menos legível)
select avg(age) as media, professional_status
from (
	select 
		(current_date - birth_date)/365 as age,
		professional_status	
		from sales.customers
) as idades
group by professional_status;


--ex 4: SubQuery no SELECT
--Na tabela sales.funnel, crie uma coluna que informe o nº de visitas acumuladas que a loja visitada recebeu


select
	fun.visit_id,
	sto.store_name,
	fun.visit_page_date,
	(
		select count(*)
		from sales.funnel as fun2
		where fun2.visit_page_date <= fun.visit_page_date
			and fun2.store_id = fun.store_id
	) as visitas_acumuladas
from sales.funnel as fun
left join
	sales.stores as sto
on
	fun.store_id = sto.store_id
order by sto.store_name, fun.visit_page_date
limit 10;


--ex 2:
with preco_medio_produto as (
	select  avg(price) as average, brand
	from sales.products
	group by brand )
select
	fun.visit_id,
	fun.visit_page_date, pro.brand,
	medio.average, (pro.price * (1 + fun.discount)) as preco_final,
	((pro.price * (1 + fun.discount)) - medio.average) as diferenca
from sales.funnel as fun
left join sales.products as pro
	on fun.product_id = pro.product_id
left join preco_medio_produto as medio
	on medio.brand = pro.brand

select * from sales.funnel limit 2;


-- EXERCÍCIOS ########################################################################

-- (Exercício 1) Crie uma coluna calculada com o número de visitas realizadas por cada
-- cliente da tabela sales.customers

select * from sales.customers limit 2;
select * from sales.funnel limit 2;

with visitas as (
	select count(*) as visitNumber, 
	customer_id 
	from sales.funnel 
	group by customer_id
)
select cus.*, vis.visitNumber
from sales.customers as cus
left join visitas as vis
on cus.customer_id  = vis.customer_id
order by vis.visitNumber;


--TRATAMENTO DE DADOS
--Transformação de tipos
select   '2022-08-08'::date  - '2004-02-18'::date;

select '100'::numeric - '10'::numeric;

select replace(11121::text,'1','A')

select cast('2021-10-01'as date) - cast('2021-02-01' as date);

--Tratamento geral
--CASE WHEN

with faixa_de_renda as(

	select 
		income, 
		case
			when income < 5000 then '0 - 5000'
			when income >= 5000 and income <10000 then '5000 - 10000'
			when income >= 10000 and income <15000 then '10000 - 15000'
			else '15000 +'
			end as faixa_renda
	from sales.customers
)select 
	faixa_renda, count(*) as total
from faixa_de_renda
group by faixa_renda
order by total;

SELECT * FROM sales.customers limit 10;
--COALESCE(varifica qual o primeiro campo nao nulo)
select * from temp_tables.regions limit 10;
--**USANDO CASE WHEN
select *,
	case
		when population is not null then population
		else (select avg(population) from temp_tables.regions)
		end as populacao_ajustada
from temp_tables.regions;
--opção 2
select *,
	coalesce(population, (select avg(population) from temp_tables.regions)) as populacao_ajustada
from temp_tables.regions;

--Tratamento de texto 

select lower('São paulo' ) = 'são paulo';

select upper('São paulo') = 'SÃO PAULO';

SELECT trim('eduardo da costa couto     ') = 'eduardo da costa couto';

select replace('SAO PAULO', 'SAO', 'SÃO') = 'SÃO PAULO';

--Tratamento de datas
--ex1
select (current_date +  interval '10 weeks')::date;

select (current_date + interval '10 hours')

select current_date + interval '10hours';

--ex2

select * from sales.funnel;
select visit_page_date, count(*)
from sales.funnel
group by visit_page_date;

select
	count(*) as visitas,
	date_trunc('month',  visit_page_date)::date as month
from sales.funnel
group by month
order by month desc;

--ex3
--extração de unidades de uma data
--dia da semana que mais rebe visitar no site


select 
	extract('dow' from visit_page_date) as "dia da semana", --dow = day of week
	count(*) as visitas
from sales.funnel
group by "dia da semana"
order by visitas desc;

select (CURRENT_DATE - '01-06-2018')/7; --diferenca em semanas
select (CURRENT_DATE - '01-06-2018')/30; --diferenca em semanas
select (CURRENT_DATE - '01-06-2018')/365; --diferenca em semanas



select datediff('weeks', '01-06-2018', current_date)


create Function datediff(unidade varchar, data_inicial date, data_final date)
returns INTEGER
LANGUAGE SQL
AS
$$
	SELECT
		CASE 
			WHEN unidade in ('d', 'day', 'days') THEN (data_final - data_inicial) 
			WHEN unidade in ('w', 'week', 'weeks') THEN (data_final - data_inicial)/7 
			WHEN unidade in ('m', 'month', 'months') THEN (data_final - data_inicial)/30 
			WHEN unidade in ('y', 'year', 'years') THEN (data_final - data_inicial)/365 
		END as diferenca
$$

drop Function datediff;


-------MANIPULÇÃO DE TABELAS
SELECT
	customer_id,
	datediff('y', birth_date, CURRENT_DATE) as idade_cliente
	into temp_tables.customers_age -- cria uma tabela
from sales.customers

select * from temp_tables.customers_age

--ex2: 
select DISTINCT professional_status
from sales.customers

create table temp_tables.profissoes(
	professional_status VARCHAR,
	status_profissional VARCHAR
);

select * from temp_tables.profissoes;

insert into temp_tables.profissoes
(professional_status, status_profissional)
VALUES
(
	'freelancer', 'faz bicos'			
),
(
	'retired', 'aposentado'
),
(
	'clt', 'clt'
)

--deletar tabelas

drop table temp_tables.profissoes;

INSERT INTO temp_tables.profissoes
(professional_status, status_profissional)
VALUES
('trainee', 'estagiário');

update temp_tables.profissoes
set professional_status = 'intern'
WHERE professional_status = 'trainee';

DELETE FROM temp_tables.profissoes
where professional_status = 'clt';

--inserção de colunas
ALTER TABLE sales.customers
add customer_age int;

update sales.customers
set customer_age = datediff('y', birth_date, current_date)
where true

select * from sales.customers
limit 5;

--alter ot ipo de uma coluna

alter Table sales.customers
alter COLUMN customer_Age type VARCHAR;


-- alterar o nome da coluna

alter table sales.customers
reNAME column customer_age to age

alter table sales.customers
drop COLUMN age;


--leads

select * from sales.funnel limit 5;

select date_trunc('month', visit_page_date)::date as month_,
count(*) as leads
from sales.funnel 
group by month_
order by month_; 


--Pagamentos, receita, mÊs
select 
	date_trunc('month', fun.paid_date)::date as month_,
	count(fun.paid_date) as payments,
	sum(pro.price * (1 + fun.discount))
from 
	sales.funnel fun
left join 
	sales.products pro
on 
	pro.product_id = fun.product_id
WHERE	
	fun.paid_date is not NULL
group by 
	month_
order by 
	month_; 


--conversão
with 
leads as (
	select 
		date_trunc('month', visit_page_date)::date as month_,
	count(*) as leads
	from 
		sales.funnel 
	group by 
		month_
	order by 
		month_
),
payments_ as (
	select 
		date_trunc('month', fun.paid_date)::date as month_,
		count(*) as payments,
		sum(pro.price * (1 + fun.discount)) as receita
	from 
		sales.funnel fun
	left join 
		sales.products pro
	on 
		pro.product_id = fun.product_id
	WHERE	
		fun.paid_date is not NULL
	group by 
		month_
	order by 
		month_
)
select
	l.month_ as "mês", l.leads, p.payments as "Qnt. Pagamentos", (p.receita/1000) as "Receita",
	(p.receita/p.payments/1000)  as "Ticket Médio",
	(p.payments::float / l.leads::float) as "Conversão (%)"
from leads l 
left join payments_ p
on p.month_ = l.month_;

------------------------------------------------------

select * from temp_tables.regions limit 5;

select * from sales.funnel limit 5;

select * from sales.customers limit 5;


select 	
		'Brazil' as Pais,
		cus.state as Estado,				
		count(fun.paid_date) as Vendas			
	from 					
		sales.funnel fun							
	left join					
		sales.customers cus				
	on 					
		cus.customer_id = fun.customer_id				
	WHERE					
		fun.paid_date between '2021-08-01' and '2021-08-31'				
	group by 					
		Estado				
	order by Vendas desc;		




select * from sales.products limit 5;



select
	count(fun.paid_date) as "Vendas",
	pro.brand as "Marca"
from sales.funnel as fun 
left join sales.products as pro
on fun.product_id = pro.product_id
where 
	fun.paid_date between '2021-08-01' and '2021-08-31'
group by pro.brand
order by "Vendas" desc
limit 5;


select
	count(fun.paid_date) as "Vendas",
	sto.store_name as "Loja"
from sales.funnel as fun 
left join sales.stores as sto
on fun.store_id = sto.store_id
where 
	fun.paid_date between '2021-08-01' and '2021-08-31'
group by "Loja"
order by "Vendas" desc
limit 5;

select * from sales.stores limit 5;




with visit_semana as (select
	extract('dow' from visit_page_date) as dia_semana,
	count(visit_page_date) as visitas
from sales.funnel
where
	visit_page_date between '2021-08-01' and '2021-08-31'
group by
	dia_semana)
select
	visitas,
	case 
		when dia_semana = 0 then 'Domingo'
		when dia_semana = 1 then 'Segunda'
		when dia_semana = 2 then 'Terça'
		when dia_semana = 3 then 'Quarta'
		when dia_semana = 4 then 'Quinta'
		when dia_semana = 5 then 'Sexta'
		when dia_semana = 6 then 'Sabado'
	end as dia_da_semana
from visit_semana
order by dia_semana
;



