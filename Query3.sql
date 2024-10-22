-- Objective 3:> Compare popularity across regions
use baby_names_db;

-- Q1.) Return the number of babies born in each of the six regions 
-- (NOTE: The state of MI should be in the Midwest region)

	SELECT DISTINCT Region from regions;

	WITH clean_regions As (SELECT State,
		CASE WHEN Region ='New England' THEN 'New_England' ELSE Region END as clean_region
	FROM regions
	UNION
	SELECT 'MI' AS State, 'Midwest' As Region
	) 

	SELECT clean_region ,SUM(Births) AS num_babies
	FROM names n LEFT JOIN clean_regions cr
		ON n.state = cr.region
	GROUP BY clean_region;




-- Q2.) Return the 3 most popular girl names and 3 most popular boy names within each region

	WITH clean_regions As (SELECT State,
		CASE WHEN Region ='New England' THEN 'New_England' ELSE Region END as clean_region
			FROM regions
			UNION
			SELECT 'MI' AS State, 'Midwest' As Region
			),
			 name_regions as 
			(SELECT n.Name,n.Gender,cr.clean_region,SUM(n.Births) as num_babies
				FROM names n LEFT JOIN clean_regions cr
					ON n.state = cr.state
			GROUP BY cr.clean_region,n.Gender,n.Name
			),
		
		ranking_by_regions as (
			SELECT clean_region, Gender, Name,
			ROW_NUMBER() OVER (PARTITION BY clean_region,gender ORDER BY num_babies DESC) As popularity_region
			FROM name_regions)
			
	Select * from ranking_by_regions where popularity_region < 4;

