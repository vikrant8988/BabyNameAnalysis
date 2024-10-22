-- Objective 1:) Track changes in name popularity
use baby_names_db;

-- Q1.Find the overall most popular girl and boy names 
-- and SHOW how they have changed in popularity rankings over the years

Select * from names limit 100;

SELECT Name,SUM(Births) As num_babies
FROM names
WHERE Gender = 'F'
GROUP BY Name
ORDER BY num_babies DESC
LIMIT 1; -- Jessica

SELECT Name,SUM(Births) As num_babies
FROM names
WHERE Gender = 'M'
GROUP BY Name
ORDER BY num_babies DESC
LIMIT 1; -- Michael

SELECT * FROM
	(WITH girl_names AS (SELECT Year, Name, SUM(Births) As num_babies
	FROM names
	WHERE Gender = 'F'
	GROUP BY Year,Name)

	SELECT Year, Name, 
			ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) As popularity_rank
	FROM girl_names ) AS popular_girls_names
    
WHERE Name='Jessica';

SELECT * FROM
	(
    WITH boy_names AS (SELECT Year, Name, SUM(Births) As num_babies
	FROM names
	WHERE Gender = 'M'
	GROUP BY Year,Name)

	SELECT Year, Name, 
			ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) As popularity_rank
	FROM boy_names
    ) AS popular_boys_names
    
WHERE Name='Michael';

-- Q2.Find the names with the biggest jumps in popularity from the first year of the data set to the last year

	WITH all_names AS 
		(
		SELECT Year, Name, SUM(Births) As num_babies
		FROM names
		WHERE Gender = 'M'
		GROUP BY Year,Name
		),
    
    names_1980 As
		(
		SELECT Year, Name, 
		ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) As popularity_rank
		FROM all_names
		WHERE Year=1980
		),
    
    names_2009 As
		(
		SELECT Year, Name, 
		ROW_NUMBER() OVER (PARTITION BY Year ORDER BY num_babies DESC) As popularity_rank
		FROM all_names
		WHERE Year=2009
		)
        
SELECT names_1980.Name,(CAST(names_1980.popularity_rank As SIGNED ) - CAST(names_2009.popularity_rank As SIGNED )) as rank_jump
FROM names_1980 
INNER JOIN names_2009 ON names_1980.Name = names_2009.Name
ORDER BY rank_jump DESC;
;
		
    
