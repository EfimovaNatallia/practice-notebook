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


-- Задача 2 - Spotify Streaming History
-- Источник - https://datalemur.com/questions/spotify-streaming-history
-- Дата 27.04.2026

with 
grouped_songs_history AS
(select user_id,
song_id,
sum (song_plays) as total_sh
from songs_history
group by 1, 2), 
grouped_songs_weekly AS
(select 
user_id,
song_id,
count(*) as total_sw
from songs_weekly
where listen_time<='2022-08-04 23:59:59'
GROUP BY user_id, song_id)
select 
-- Соединяем ID, чтобы не потерять новичков
    COALESCE(gsh.user_id, gsw.user_id) AS user_id,
    COALESCE(gsh.song_id, gsw.song_id) AS song_id,
    -- Складываем историю и неделю, заменяя NULL на 0
    COALESCE(gsh.total_sh, 0) + COALESCE(gsw.total_sw, 0) AS song_plays
from grouped_songs_history as gsh
full join grouped_songs_weekly as gsw 
ON gsh.user_id = gsw.user_id AND gsh.song_id = gsw.song_id
order by song_plays desc


-- Задача 3 - International Call Percentage (Использование двойного джойна)
-- Источник - https://datalemur.com/questions/international-call-percentage
-- Дата 27.04.2026

with total AS
(SELECT 
pc.caller_id,
pc.receiver_id,
pi1.country_id AS caller_country,
pi2.country_id AS receiver_country
FROM phone_calls pc
join phone_info pi1 using (caller_id)
JOIN phone_info pi2 ON pc.receiver_id = pi2.caller_id)
SELECT
round((count (case when caller_country!=receiver_country then 1 end)*100.0)/count(*),1)
from total
