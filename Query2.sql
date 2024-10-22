-- Objective 2:> Compare popularity across decades
use baby_names_db;

-- Q1. For each year, return the 3 most popular girl names and 3 most popular boy names
WITH all_names AS 
		(
		SELECT Year, Name, Gender, SUM(Births) As num_babies
		FROM names
		GROUP BY Year,Name,Gender
		),
        
	ranking_names as (
	SELECT Year, Name, Gender,
	ROW_NUMBER() OVER (PARTITION BY Year,Gender ORDER BY num_babies DESC) As popularity_rank
	FROM all_names)

Select * from ranking_names where popularity_rank<=3;

-- Q2. For each decade, return the 3 most popular girl names and 3 most popular boy names

WITH babies_by_decade AS 
		(
		SELECT (CASE WHEN Year BETWEEN 1980 and 1989 THEN 'Eighties'
					WHEN Year BETWEEN 1990 and 1999 THEN 'Nineties'
                    WHEN Year BETWEEN 2000 and 2009 THEN 'Two_Thousand'
                    ELSE 'None' END) As Decade,

        Name, Gender, SUM(Births) As num_babies
		FROM names
		GROUP BY decade,Name,Gender
		),
        
	ranking_by_decade  as (
	SELECT Decade, Name, Gender,
	ROW_NUMBER() OVER (PARTITION BY decade,Gender ORDER BY num_babies DESC) As popularity_rank
	FROM babies_by_decade)

Select * from ranking_by_decade where popularity_rank<=3;