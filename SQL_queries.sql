SELECT* 
FROM Portfolio_project..Covid_deaths
ORDER BY 3,4;

--SELECT*
--FROM Portfolio_project..Covid_vaccinations 
--ORDER BY 3,4;

--selecting the data that we are going to use in this project
SELECT location, date, new_cases, total_cases, total_deaths, population
FROM portfolio_project..Covid_deaths
ORDER BY 1,2;

--total cases vs total deaths
SELECT location, date, total_cases, (total_deaths), (total_deaths/total_cases)*100 AS Death_percentage
FROM Portfolio_project..Covid_deaths
WHERE location like '%India%'
ORDER BY 1,2;

--looking at the total cases vs population
SELECT location, date, total_cases, population, (total_cases/population)*100 AS Affected_population
FROM Portfolio_project..Covid_deaths
WHERE location LIKE '%india%'
ORDER BY 1,2;

--looking at a country with highest infection rate
SELECT location, population, MAX(total_cases) AS Highest_infected, MAX(total_cases/population)*100 AS maximum_cases_percentage
FROM Portfolio_project..Covid_deaths
GROUP BY location, population
ORDER BY 4 DESC; 

--looking at highest Death count
SELECT location, MAX(cast(total_deaths AS int)) AS Death_count
FROM portfolio_project..covid_deaths
WHERE continent is not null
GROUP BY location
ORDER BY 2 DESC;

--Order by continent
 SELECT continent, MAX(CAST(total_deaths AS int)) AS Death_count
 FROM Portfolio_project..Covid_deaths
 WHERE continent is not null
 GROUP BY continent
 ORDER BY 2 DESC;

 --continent with the highest death rates
  SELECT continent, population, MAX(CAST(total_deaths AS int)) AS Death_count, MAX(total_deaths/population)*100
 FROM Portfolio_project..Covid_deaths
 WHERE continent is not null
 GROUP BY continent, population
 ORDER BY 4 DESC;

 --Global numbers
 SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths
 FROM Portfolio_project..Covid_deaths
 GROUP BY date
 ORDER BY 3 DESC;
 
 --joining both tables total population vs people vaccinated
 SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations, (vac.total_vaccinations), (vac.total_vaccinations/vac.population)*100 AS ppl_vaccinated_ratio
 FROM Portfolio_project..Covid_deaths dea
 JOIN Portfolio_project..[Covid_vaccinations ] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;

-- Using CTE for population vs people vaccinated

WITH Popvac(continent, location, date, population, new_vac, total_vac)
AS
( SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, (vac.total_vaccinations)
 FROM Portfolio_project..Covid_deaths dea
 JOIN Portfolio_project..[Covid_vaccinations ] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3;
)
SELECT*, (total_vac/population)*100 AS percentage_vaccinated
FROM popvac


--using temp table
DROP TABLE IF EXISTS #Popvac_table
CREATE TABLE #Popvac_table(
continent nvarchar(255),
location nvarchar(255),
date DATETIME,
population NUMERIC,
new_vac NUMERIC,
total_vac NUMERIC
)

INSERT INTO #Popvac_table
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, (vac.total_vaccinations)
 FROM Portfolio_project..Covid_deaths dea
 JOIN Portfolio_project..[Covid_vaccinations ] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3;

SELECT*, (total_vac/population)*100 AS percentage_vaccinated
FROM #Popvac_table;


--creating views

CREATE VIEW Popvac AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, (vac.total_vaccinations)
 FROM Portfolio_project..Covid_deaths dea
 JOIN Portfolio_project..[Covid_vaccinations ] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3;

SELECT* FROM Popvac;

-------End of queries---------