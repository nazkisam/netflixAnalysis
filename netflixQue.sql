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
 