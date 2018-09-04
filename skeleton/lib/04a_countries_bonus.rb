# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# BONUS QUESTIONS: These problems require knowledge of aggregate
# functions. Attempt them after completing section 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
  SELECT 
    name 
  FROM 
    countries 
  WHERE 
    gdp > (
      SELECT 
        MAX(gdp) AS gdp 
      FROM 
        countries 
      WHERE 
        continent = 'Europe'
    )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
  SELECT 
    c.continent, c.name, c.area 
  FROM 
    countries AS c 
  INNER JOIN ( 
      SELECT 
        continent, MAX(area) AS max_area
      FROM
        countries 
      GROUP BY 
        continent 
  ) AS m 
  ON 
    c.continent = m.continent AND c.area = m.max_area 
  
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
  SELECT DISTINCT
  c.name, c.continent 
  FROM 
    countries AS c 
  INNER JOIN ( 
      SELECT 
        continent, MAX(population) AS max_population
      FROM
        countries 
      GROUP BY 
        continent 
  ) AS m 
  ON 
    c.continent = m.continent AND c.population = m.max_population 
  LEFT JOIN 
    countries as s 
  ON  
    c.continent = s.continent AND c.name != s.name
  AND
    c.population <= s.population * 3 
  WHERE s.name IS NULL 
  
  SQL
end
