
Select *
From CovidDeaths
where continent is not null
Order by Location, date


--Select *
--From [dbo].[CovidVaccinations$]
--Order by 3,4;


Select Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
where continent is not null
Order by Location, date



--Total Cases vs Total Death: Possibility of death if contract covid19

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as total_deathPercent
From CovidDeaths
Where Location = 'Nigeria'
AND continent is not null
Order by Location, date




--Total Cases vs Population: Possibility of death if contract covid19: Population percentage contracted covid

Select Location, date,  population, total_cases, (total_deaths/Population)*100 as PercentPopulationInfected
From CovidDeaths
where continent is not null
Order by Location, date



--Countries with highest infection rate vs population

Select Location, population, MAX(total_cases) as HighesInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
where continent is not null
Group by Location, population
Order by PercentPopulationInfected desc
 


 --Countries with Highest Death Count per Population

Select Location, MAX(Cast(total_deaths as INT)) as TotalDeathCount
From CovidDeaths
where continent is not null
Group by Location
Order by TotalDeathCount desc



--ANALYSIS BY CONTINENT

--Continents with highest death count per population

Select continent, MAX(Cast(total_deaths as INT)) as TotalDeathCount
From CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc



--Continents with highest death count per population

Select continent, MAX(Cast(total_deaths as INT)) as TotalDeathCount
From CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc;


--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From CovidDeaths
WHERE continent is not null
--Group by date
Order by 1,2





--Total Population vs Vaccinations

Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(convert(int, v.new_vaccinations)) OVER (Partition by d.location order by d.location
, d.date) as RollingPeopleVaccinated
From CovidDeaths d
Join CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
order by 2,3



--USE CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(convert(int, v.new_vaccinations)) OVER (Partition by d.location order by d.location
, d.date) as RollingPeopleVaccinated
From CovidDeaths d
Join CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac





--TEMP TABLE

Drop table if exists #PercentagePopulationVaccinated
Create table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentagePopulationVaccinated
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(convert(int, v.new_vaccinations)) OVER (Partition by d.location order by d.location
, d.date) as RollingPeopleVaccinated
From CovidDeaths d
Join CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
--where d.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentagePopulationVaccinated


--=======Temp Table Ends==============--



---Creating View to store data for Later use

Create View PercentagePopulationVaccinated as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(convert(int, v.new_vaccinations)) OVER (Partition by d.location order by d.location
, d.date) as RollingPeopleVaccinated
From CovidDeaths d
Join CovidVaccinations v
	on d.location = v.location
	and d.date = v.date
where d.continent is not null
---Order by 2,3


Select *
From PercentagePopulationVaccinated