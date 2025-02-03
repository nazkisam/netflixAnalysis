CREATE TABLE netflix(
show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);


COPY netflix 
(show_id     ,
    type         ,
    title        ,
    director     ,
    casts        ,
    country      ,
    date_added   ,
    release_year, 
    rating    ,   
    duration ,    
    listed_in,
    description  
)

FROM 'D:\PLCPP\SQL\newproject\netflix\netflix_titles.csv' 
DELIMITER ','
CSV HEADER;
 


 SELECT *FROM netflix;

--1. Count the Number of Movies vs TV Shows
    --1st solution
SELECT COUNT(type) AS MOVIES, COUNT(type)AS tv_shows
FROM netflix
WHERE type = 'Movie' OR type = 'TV Show';

 -- 2nd solution
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;

-- 2. Find the Most Common Rating for Movies and TV Shows

--first we will check for tv shows and movies /how many times each rating has been given to the same.

--using window function- 
SELECT type,rating 
FROM
(SELECT 
type, 
rating,
COUNT(*),
RANK() OVER(PARTITION BY type ORDER BY COUNT(*)DESC) AS ranking
FROM netflix
group by 1,2
) AS t1
WHERE ranking = 1

-- 3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT title FROM netflix
WHERE release_year  = 2000

-- 4. Find the Top 5 Countries with the Most Content on Netflix
SELECT *FROM netflix

SELECT  UNNEST(STRING_TO_ARRAY(country, ',')) AS COUNTRY,
COUNT(show_id) AS TOTAL_CONTENT
FROM netflix 
WHERE COUNTRY IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
FETCH FIRST 5 ROWS ONLY


-- 5. Identify the Longest Movie

SELECT title ,duration
FROM netflix
WHERE type  = 'Movie' AND duration IS NOT NULL
ORDER BY split_part(duration,' ',1)::INT DESC 
LIMIT 1


-- 6. Find Content Added in the Last 5 Years
SELECT title,date_added FROM netflix 
WHERE TO_DATE(date_added, 'Month DD, YYYY')>= CURRENT_TIMESTAMP - INTERVAL  '5 years';


-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT title,director 
FROM(
SELECT *, UNNEST(STRING_TO_ARRAY(director,',')) AS director_name
FROM netflix
) AS d
WHERE director_name = 'Rajiv Chilaka';


SELECT title,director_name
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';

-- 8. List All TV Shows with More Than 5 Seasons

--this is better query
SELECT title,seasons FROM 
(
    SELECT title ,split_part(duration,' ',1)::INT  AS seasons,type
 FROM netflix
 WHERE type = 'TV Show'
 ) as s 
 WHERE seasons > 5
GROUP BY 1,2
ORDER BY seasons DESC


--less optimized than the above query, because of using CAST(SPLIT_PART(duration,' ',1) AS INT) AS seasons two times
SELECT title, CAST(SPLIT_PART(duration,' ',1) AS INT) AS seasons
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5 
  GROUP BY 1,2
  ORDER BY seasons DESC

-- 9. Count the Number of Content Items in Each Genre

SELECT *FROM netflix

SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) AS gener,COUNT(*)
FROM netflix
GROUP BY 1

-- 10.Find each year and the average numbers of content release in India on netflix.

SELECT country,release_year,title_india
FROM(

SELECT country,release_year, 
   ROUND(
        ROUND((CAST(COUNT(show_id) AS numeric) / CAST((SELECT COUNT(show_id) FROM netflix WHERE country = 'India') AS numeric)) * 100, 2)
        )AS title_india
         
 FROM netflix
 GROUP BY 1,2
)AS  avg 
WHERE country = 'India'
GROUP BY 1,2,3
ORDER BY release_year DESC
FETCH FIRST 5 ROWS ONLY;



-- 11. List All Movies that are Documentaries
SELECT title,type,listed_in FROM netflix
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries';



-- 12. Find All Content Without a Director

SELECT *FROM netflix

SELECT title FROM netflix
WHERE director IS NULL

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT title,casts
FROM netflix
WHERE casts LIKE '%Salman Khan%' AND release_year > EXTRACT(YEAR FROM CURRENT_TIMESTAMP)  - 10


-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
