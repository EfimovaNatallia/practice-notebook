-- Задача 1 - User's Third Transaction
-- Источник - https://datalemur.com/questions/sql-third-transaction
-- Дата 27.04.2026

select 
user_id,
spend, 
transaction_date
from (select *,
row_number () over ( PARTITION by user_id order by transaction_date)
from transactions) as o
where row_number=3