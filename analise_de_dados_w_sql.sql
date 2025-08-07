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
