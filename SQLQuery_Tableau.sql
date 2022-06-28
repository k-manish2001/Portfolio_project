-- Queries for visualizations
--1.
--Global numbers
 SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, (SUM(CAST(new_deaths AS int))/ SUM(new_cases))*100 AS percentage_death
 FROM Portfolio_project..Covid_deaths
 ORDER BY 1,2;

 --2.
 --Death count for continents
 SELECT continent, SUM(CAST(new_deaths as int)) AS Total_death_count
 FROM Portfolio_project..Covid_deaths
 WHERE continent IS NOT NULL
 AND location NOT IN ('WORLD', 'Europian union', 'International')
 GROUP BY continent
 ORDER BY Total_death_count DESC;

--3.
--looking at a country with highest infection rate
SELECT location, population, MAX(total_cases) AS Highest_infected, MAX(total_cases/population)*100 AS maximum_cases_percentage
FROM Portfolio_project..Covid_deaths
GROUP BY location, population
ORDER BY 4 DESC; 

--4.
--looking at a country with highest infection rate GROUPED BY date
SELECT location, population, date, MAX(total_cases) AS Highest_infected, MAX(total_cases/population)*100 AS maximum_cases_percentage
FROM Portfolio_project..Covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population, date
ORDER BY 4 DESC; 

--Queries for tableau