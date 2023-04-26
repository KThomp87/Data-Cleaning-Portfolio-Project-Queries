--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM COVIDDeaths$
--ORDER BY 1,2

--Looking at total cases vs total deaths
-- Shows liklihood of dying if you contract covid in United States

--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
--FROM CovidDeaths$ 
--WHERE location like '%states%'
--ORDER BY 1,2

-- Looking at the total cases vs the population
-- Shows what percentage of population contracted covid

--SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
--FROM CovidDeaths$ 
--WHERE location like '%states%'
--ORDER BY 1,2

-- Looking at countries with highest infection rate compared to population

--SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
--FROM CovidDeaths$ 
--GROUP BY location, population
--ORDER BY PercentPopulationInfected DESC

-- Showing Countries with Highest Death Count per Population

--SELECT location, MAX(CAST(total_deaths as INT)) as TotalDeathCount
--FROM CovidDeaths$ 
--WHERE continent is not null
--GROUP BY location
--ORDER BY TotalDeathCount DESC

-- Breakdown by Continent

--SELECT continent, MAX(CAST(total_deaths as INT)) as TotalDeathCount
--FROM CovidDeaths$ 
--WHERE continent is not null
--GROUP BY continent
--ORDER BY TotalDeathCount DESC

-- Global Numbers
 
 --SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST (new_Deaths AS INT))/SUM(New_Cases)*100 AS death_percentage
 --FROM CovidDeaths$
 --WHERE continent is not null
 --GROUP BY date
 --ORDER BY 1,2

 --SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST (new_Deaths AS INT))/SUM(New_Cases)*100 AS death_percentage
 --FROM CovidDeaths$
 --WHERE continent is not null
 --ORDER BY 1,2


 -- looking at Total Population vs. Vaccinations
 --SELECT *
 --FROM CovidDeaths$ dea
 --JOIN CovidVaccinations$ vac
	--ON dea.location = vac.location
	--AND dea.date =  vac.date

-- SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by  dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- FROM CovidDeaths$ dea
-- JOIN CovidVaccinations$ vac
--	ON dea.location = vac.location
--	AND dea.date =  vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

-- USE CTE

--WITH PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) AS 
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by  dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- FROM CovidDeaths$ dea
-- JOIN CovidVaccinations$ vac
--	ON dea.location = vac.location
--	AND dea.date =  vac.date
--WHERE dea.continent is not null
--)

--SELECT *, (rolling_people_vaccinated/population)*100 
--FROM PopvsVac

-- Temp Table

--DROP TABLE if exists #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_Vaccinations numeric,
--rolling_people_vaccinated numeric)


--INSERT INTO #PercentPopulationVaccinated

--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by  dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
--FROM CovidDeaths$ dea
--JOIN CovidVaccinations$ vac
--ON dea.location = vac.location
--AND dea.date =  vac.date
--WHERE dea.continent is not null

--SELECT *, (rolling_people_vaccinated/Population)*100
--FROM #PercentPopulationVaccinated

-- Create View to store for data visualization

--CREATE VIEW PercentPopulationVaccinated as
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by  dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
--FROM CovidDeaths$ dea
--JOIN CovidVaccinations$ vac
--ON dea.location = vac.location
--AND dea.date =  vac.date
--WHERE dea.continent is not null