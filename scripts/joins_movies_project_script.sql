--Question1 Give the name, release year, and worldwide gross of the lowest grossing movie. Semi-Tough
SELECT release_year, worldwide_gross, film_title
FROM specs
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
ORDER BY worldwide_gross ASC;

--Question2 What year has the highest average imdb rating? 1991; was selecting too many columns
SELECT specs.release_year, AVG(rating.imdb_rating) AS avg_rating
FROM specs
INNER JOIN rating
ON specs.movie_id = rating.movie_id
	GROUP BY specs.release_year
	ORDER BY avg_rating DESC;

--Question3 What is the highest grossing G-rated movie? Which company distributed it? Toy Story 4; Walt Disney
SELECT specs.movie_id, revenue.worldwide_gross, distributors.company_name, specs.mpaa_rating, film_title
FROM specs
INNER JOIN revenue
	ON specs.movie_id = revenue.movie_id
INNER JOIN distributors
	ON specs.domestic_distributor_id = distributors.distributor_id
	WHERE specs.mpaa_rating = 'G'
	ORDER BY worldwide_gross DESC;
	
--Question4
SELECT COUNT (DISTINCT specs.film_title), distributors.distributor_id, specs.domestic_distributor_id, distributors.company_name
FROM distributors
FULL JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
	GROUP BY distributors.distributor_id, specs.domestic_distributor_id, distributors.company_name;
	
--better choice would have been a LEFT JOIN for Q5
	
--Question5 Write a query that returns the five distributors with the highest average movie budget.
SELECT distributors.company_name, AVG(revenue.film_budget)
FROM distributors
INNER JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN revenue
	ON specs.movie_id = revenue.movie_id
	GROUP BY distributors.company_name
	ORDER BY AVG(revenue.film_budget) DESC
	LIMIT 5;
	
--Question6a How many movies in the dataset are distributed by a company which is not headquartered in California? 2
SELECT specs.film_title, company_name, headquarters
FROM distributors
INNER JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
	WHERE headquarters NOT LIKE '%CA'
	GROUP BY company_name, headquarters, film_title;
--Question6b Which of these movies has the highest imdb rating?
SELECT film_title, company_name, headquarters, imdb_rating
FROM distributors
INNER JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN rating
	ON specs.movie_id = rating.movie_id
	WHERE headquarters NOT LIKE '%CA'
	GROUP BY company_name, headquarters, imdb_rating, film_title;
	
--Question7  Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
SELECT COUNT (film_title),length_in_min, AVG(imdb_rating)
FROM specs
INNER JOIN rating
	ON specs.movie_id = rating.movie_id
	GROUP BY length_in_min
	ORDER BY length_in_min DESC;
--Question 7 correct answer
SELECT
CASE
	WHEN length_in_min >= 120 THEN '>2 Hours'
	ELSE '<2 Hours'
END AS lengthtext, ROUND(avg(imdb_rating), 2) AS avg_rating
FROM specs
INNER JOIN rating
USING (movie_id)
GROUP BY lengthtext
ORDER BY avg_rating DESC;