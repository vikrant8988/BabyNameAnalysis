-- Obective4:> Explore unique names in the dataset
use baby_names_db;

-- Q1.Find the 10 most popular androgynous names (names given to both females and males)
SELECT Name,COUNT(distinct Gender) as num_genders,SUM(Births) as num_babies
FROM names
GROUP BY Name
HAVING num_genders=2
ORDER BY num_babies DESC
LIMIT 10;




-- Q2.Find the length of the shortest and longest names, 
-- and identify the most popular short names (those with the fewest characters) 
-- and long names (those with the most characters)


	SELECT Name, length(Name) as names_length
	FROM names
	order by name_length limit 1; -- 2

	SELECT Name, length(Name) as names_length
	FROM names
	order by name_length DESC limit 1; -- 15

	WITH short_long_names as (
		SELECT *
		FROM names
		WHERE LENGTH(Name) IN (2,5)
	)
    
    SELECT Name, SUM(Births) as num_babies
    FROM short_long_names
    GROUP BY Name
    ORDER BY num_babies DESC;





