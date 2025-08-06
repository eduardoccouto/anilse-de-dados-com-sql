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


