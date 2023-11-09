

select *
from deechu.dbo.[covid_death]
where continent is not null  
order by 3,4



--select *
--from deechu.dbo.[covid vaccination ]
--order by 3,4

--select the data that we are going to be using 

select location , date , total_cases , new_cases , total_deaths , population
from deechu.dbo.[covid_death]
order by 1,2


--looking at TOTAL CASES VS TOTAL DEATHS
--we want to know percentage of people who are dying who actually get infected
-- shows the likelihood of dying if u contract covid in our country 
select location , date , total_cases , total_deaths,(total_deaths/total_cases)*100
from deechu.dbo.[covid_death]
order by 1,2

SELECT 
    location, 
    date, 
    CAST(total_cases AS INTEGER) AS total_cases, 
    CAST(total_deaths AS INTEGER) AS total_deaths, 
    (CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS death_rate
FROM 
    deechu.dbo.[covid_death]
where location like '%states%'
ORDER BY 
    1,2;

-- looking at the TOTAL CASES VS POPULATION
-- shows what percentage of the population got covid 
SELECT 
    location, 
    date, 
    CAST(total_cases AS INTEGER) AS total_cases, 
    cast(population as integer ) as population ,
    (CAST(total_cases AS FLOAT) / CAST(population  AS FLOAT)) * 100 AS popultionrate
FROM 
    deechu.dbo.[covid_death]
where location like '%states%'
ORDER BY 
    1,2;

-- which countries have the highest infection rate 
-- looking at countries with  highest rate as compared to population 
SELECT 
location, 
max(CAST(total_cases AS INTEGER)) as total_casesinfected,
cast(population as float) as population,
max((CAST(total_cases AS FLOAT) / CAST(population  AS FLOAT))) * 100 AS infectedpopulaton
FROM deechu.dbo.[covid_death]
group by location,cast(population as float)
order by infectedpopulaton desc ;

--showing the countries with highest death count per population 
SELECT 
location, 
max(cast(total_deaths as float)) as totaldeathcount 
FROM deechu.dbo.[covid_death]
where continent is not null 
group by location
order by totaldeathcount desc ;

-- lets break down things by continent 
SELECT 
continent, 
max(cast(total_deaths as float)) as totaldeathcount 
FROM deechu.dbo.[covid_death]
where continent is not null 
group by continent
order by totaldeathcount desc ;

-- this is wrong so prevously i deleted all null values to get only location now i keep only null values in order to get continenet \
SELECT 
location, 
max(cast(total_deaths as float)) as totaldeathcount 
FROM deechu.dbo.[covid_death]
where continent is null 
group by location
order by totaldeathcount desc;

--showing the continents with the highest death count per population 
SELECT 
continent, 
max(cast(total_deaths as float)) as totaldeathcount 
FROM deechu.dbo.[covid_death]
where continent is not null 
group by continent
order by totaldeathcount desc ;

-- global numbers 
SELECT 
    date, 
    sum(CAST(new_cases AS FLOAT))as totalcases,
    sum(CAST(new_deaths AS FLOAT)) as totaldeath,
    sum(CAST(new_deaths AS FLOAT)) / sum(CAST(new_cases AS FLOAT)) * 100 AS  newdeath_percentage 
from deechu.dbo.[covid_death]
where continent is not null
group by date
ORDER BY 1,2;

--
SELECT  
    sum(CAST(new_cases AS FLOAT))as totalcases,
    sum(CAST(new_deaths AS FLOAT)) as totaldeath,
    sum(CAST(new_deaths AS FLOAT)) / sum(CAST(new_cases AS FLOAT)) * 100 AS  newdeath_percentage 
from deechu.dbo.[covid_death]
where continent is not null
ORDER BY 1,2;

-- looking at how many poeple out of the population are vaccinated 

select d.continent,d.location , d.date,cast(d.population as float) as population ,v.new_vaccinations
from deechu.dbo.[covid_death] d
join deechu .dbo.[covid vaccination ] v
on d.location =v.location 
and d.date = v.date
where d.continent is not null 
order by 2,3


select d.continent,d.location , d.date,cast(d.population as float) as population ,
cast(v.new_vaccinations as float) as vaccination, 
sum(cast(v.new_vaccinations as float)) 
over (partition by d.location order by d.location , d.date )as rollingpeoplevaccinated 
--, (rollingpeoplevaccinated /population)*100
from deechu.dbo.[covid_death] d
join deechu .dbo.[covid vaccination ] v
on d.location =v.location 
and d.date = v.date
where d.continent is not null 
order by 2,3


--use CTE

with popvsvac (continent, location , date , population,vaccination ,rollingpeoplevaccinated)
 as (select d.continent,d.location , d.date,cast(d.population as float) as population ,
cast(v.new_vaccinations as float) as vaccination, 
sum(cast(v.new_vaccinations as float)) 
over (partition by d.location order by d.location , d.date )as rollingpeoplevaccinated 
--, (rollingpeoplevaccinated /population)*100
from deechu.dbo.[covid_death] d
join deechu .dbo.[covid vaccination ] v
on d.location =v.location 
and d.date = v.date
where d.continent is not null 
--order by 2,3
)

-- creating view to store for latest visualization 

CREATE VIEW popvsvac
as
select d.continent,d.location , d.date,cast(d.population as float) as population ,
cast(v.new_vaccinations as float) as vaccination, 
sum(cast(v.new_vaccinations as float)) 
over (partition by d.location order by d.location , d.date )as rollingpeoplevaccinated 
--, (rollingpeoplevaccinated /population)*100
from deechu.dbo.[covid_death] d
join deechu .dbo.[covid vaccination ] v
on d.location =v.location 
and d.date = v.date
where d.continent is not null 

select *
from popvsvac







