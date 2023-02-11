
--- SKILLS USED: Select/Delete/Update statements, Converting data types, Aggregate Functions, Cases, Windowed Functions, Altering Tables, Joins

---------------------------------------------------------------------------------------------------
-- PART 1: CLEAN THE ORIGINAL DATASET
---------------------------------------------------------------------------------------------------

-- Add day_of_year column
ALTER TABLE flight_data
ADD day_of_year DATE

Update flight_data
SET day_of_year = DATEFROMPARTS(2013,month,day)

-- Fill arr_delay and dep_delay columns
UPDATE flight_data
SET arr_delay = arr_time - sched_arr_time, dep_delay = dep_time - sched_dep_time
WHERE (arr_delay IS NULL) OR (dep_delay IS NULL)

-- Fill arr_time and dep_time columns
UPDATE flight_data
SET arr_time = arr_delay + sched_arr_time, dep_time = dep_delay + sched_dep_time
WHERE (arr_time IS NULL) OR (dep_time IS NULL)

-- Fill in sched_arr_time and sched_dep_time columns
UPDATE flight_data
SET sched_arr_time = arr_time - arr_delay, sched_dep_time = dep_time - dep_delay
WHERE (sched_arr_time IS NULL) OR (sched_dep_time IS NULL)

-- Readjust the time_hour to column so that joining table is possible
UPDATE flight_data
SET time_hour = CAST(day_of_year AS datetime) + CAST(CAST(CONVERT(VARCHAR,DATEADD(SECOND, hour*3600, 0),108) AS TIME) AS datetime)

-- Observe how many rows contain null values in each column of interest
-- NOTE: I understand that I can run a much shorter code in Python do this exact thing
SELECT COUNT(CASE WHEN day_of_year IS NULL THEN 1 END) AS DayOfYearNullCount,
    COUNT(CASE WHEN dep_time IS NULL THEN 1 END) AS DepTimeNullCount,
    COUNT(CASE WHEN sched_dep_time IS NULL THEN 1 END) AS SchedDepTimeNullCount,
	COUNT(CASE WHEN dep_delay IS NULL THEN 1 END) AS DepDelayNullCount,
    COUNT(CASE WHEN arr_time IS NULL THEN 1 END) AS ArrTimeNullCount,
	COUNT(CASE WHEN sched_arr_time IS NULL THEN 1 END) AS SchedArrTimeNullCount,
    COUNT(CASE WHEN arr_delay IS NULL THEN 1 END) AS ArrDelayNullCount,
	COUNT(CASE WHEN carrier IS NULL THEN 1 END) AS CarrierNullCount,
    COUNT(CASE WHEN flight IS NULL THEN 1 END) AS FlightNullCount,
	COUNT(CASE WHEN origin IS NULL THEN 1 END) AS OriginNullCount,
    COUNT(CASE WHEN air_time IS NULL THEN 1 END) AS AirTimeNullCount,
	COUNT(CASE WHEN distance IS NULL THEN 1 END) AS DistanceNullCount,
	COUNT(CASE WHEN time_hour IS NULL THEN 1 END) AS TimeHourNullCount
FROM flight_data

-- Make a copy of the data such that there are no null values present
DROP TABLE IF EXISTS flight_data_copy;
SELECT *
INTO flight_data_copy
FROM flight_data
WHERE (dep_time IS NOT NULL) AND (dep_delay IS NOT NULL) AND (arr_time IS NOT NULL) AND (arr_delay IS NOT NULL) AND (air_time IS NOT NULL)

-- Drop unneeded columns FROM THE COPIED TABLE
ALTER TABLE flight_data_copy
DROP COLUMN year, month, day, tailnum, hour, minute

---------------------------------------------------------------------------------------------------
-- PART 2: BASIC DESCRIPTIVE ANALYSIS (SUMMARY OF INFORMATION) 
---------------------------------------------------------------------------------------------------

-- Return the number of flights, airports, and airlines in the dataset
SELECT COUNT(flight) as total_flights, COUNT(DISTINCT origin) as num_airports, COUNT(DISTINCT carrier) as num_airlines, COUNT(DISTINCT dest) as num_destinations
FROM flight_data_copy; 

-- Return the number of flights flown out of each airport
SELECT origin, COUNT(flight) AS num_delays
FROM flight_data_copy
GROUP BY origin
ORDER BY 2 DESC;

-- Return the number of flights flown out of each airline
SELECT carrier, COUNT(flight) AS total_flights
FROM flight_data_copy
GROUP BY carrier
ORDER BY 2 DESC;

-- Return all of the destination airports, as well as how many flights travelled to them
SELECT dest, COUNT(flight) AS total_flights
FROM flight_data_copy
GROUP BY dest
ORDER BY 2 DESC;

-- Return the number of flights that were cancelled (where dep_time IS NULL)
SELECT COUNT(flight) AS total_flights
FROM flight_data
WHERE (dep_time IS NULL);

---------------------------------------------------------------------------------------------------
-- PART 3: FLIGHTS OVER PERIODS OF TIME 
---------------------------------------------------------------------------------------------------

-- Create a column referring to the weekday of each flight
ALTER TABLE flight_data_copy
ADD day_of_week nvarchar(255)

Update flight_data_copy
SET day_of_week = DATENAME(WEEKDAY, day_of_year)

-- Return the number of flights flown each day of the week
SELECT day_of_week, COUNT(flight) AS total_flights
FROM flight_data_copy
GROUP by day_of_week
ORDER BY 2 DESC;

-- Return the number of flights flown each day of the week from each airport
SELECT origin, day_of_week, COUNT(flight) AS total_flights
FROM flight_data_copy
GROUP BY origin, day_of_week
ORDER BY 1, 3;

-- Create a column referring to the month of the year of the flight
ALTER TABLE flight_data_copy
ADD month_of_year nvarchar(255)

Update flight_data_copy
SET month_of_year = DATENAME(MONTH, day_of_year)

-- Return the number of flights flown each month
SELECT month_of_year, COUNT(flight) AS total_flights
FROM flight_data_copy
GROUP BY month_of_year
ORDER BY 2 DESC

-- Return the number of flights flown each month from each airport
SELECT origin, month_of_year, COUNT(flight) AS total_flights
FROM flight_data_copy
GROUP BY origin, month_of_year
ORDER BY 1, 3 

-- Return the 15 days of the year in which the most flights occurred
SELECT TOP 15 day_of_year, COUNT(flight) AS num_flights
FROM flight_data_copy
GROUP BY day_of_year
ORDER BY 2 DESC

-- Return the 15 days of the year in which the least flights occurred
SELECT TOP 15 day_of_year, COUNT(flight) AS num_flights
FROM flight_data_copy
GROUP BY day_of_year
ORDER BY 2;

---------------------------------------------------------------------------------------------------
-- PART 4: NET DELAY TIME
---------------------------------------------------------------------------------------------------

-- Create a column called net delay
ALTER TABLE flight_data_copy
ADD net_delay FLOAT

UPDATE flight_data_copy
SET net_delay = dep_delay + arr_delay

-- Observe the average net delay time at each airport
SELECT origin, AVG(net_delay) AS avg_net_delay
FROM flight_data_copy
GROUP BY origin

-- Observe the average net delay time for each airline
SELECT carrier, AVG(net_delay) AS avg_net_delay
FROM flight_data_copy
GROUP BY carrier

-- Oberve the average arrival delay, departure delay, and net delay per month
SELECT month_of_year, AVG(arr_delay) AS avg_arr_delay, AVG(dep_delay) AS avg_dep_delay, AVG(net_delay) AS avg_net_delay
FROM flight_data_copy
GROUP BY month_of_year
ORDER BY 2, 3, 4 DESC

---------------------------------------------------------------------------------------------------
-- PART 5: ON TIME PERCENTAGE
---------------------------------------------------------------------------------------------------

-- Calculate the On Time Percentage for each carrier (percent of time where arr_delay <= 15 minutes)
ALTER TABLE flight_data_copy
ADD On_Time NVARCHAR(255)

UPDATE flight_data_copy
SET On_Time = 'yes'
WHERE ABS(arr_delay) <= 15

UPDATE flight_data_copy
SET On_Time = 'no'
WHERE ABS(arr_delay) > 15

-- Calculate the On-Time Percentage for each airline
SELECT carrier, 
	COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS times_on_time, 
	COUNT(flight) AS num_flights, 
	(CAST(COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS FLOAT)/CAST(COUNT(flight) AS FLOAT))*100 AS OTP
FROM flight_data_copy
GROUP BY carrier
ORDER BY 4 DESC

-- Calculate the On-Time Percentage for each airport
SELECT origin, 
	COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS times_on_time, 
	COUNT(flight) AS num_flights, 
	(CAST(COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS FLOAT)/CAST(COUNT(flight) AS FLOAT))*100 AS OTP
FROM flight_data_copy
GROUP BY origin
ORDER BY 4 DESC

-- Calculate the On-Time Percentage for each month
SELECT month_of_year, 
	COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS times_on_time, 
	COUNT(flight) AS num_flights, 
	(CAST(COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS FLOAT)/CAST(COUNT(flight) AS FLOAT))*100 AS OTP
FROM flight_data_copy
GROUP BY month_of_year
ORDER BY 4 DESC

-- Calculate the On-Time Percentage for each day of the week
SELECT day_of_week, 
	COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS times_on_time, 
	COUNT(flight) AS num_flights, 
	(CAST(COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS FLOAT)/CAST(COUNT(flight) AS FLOAT))*100 AS OTP
FROM flight_data_copy
GROUP BY day_of_week
ORDER BY 4 DESC

---------------------------------------------------------------------------------------------------
-- PART 6: FLIGHT SPEED
---------------------------------------------------------------------------------------------------

-- Calculate the Flight Speed of each flight
ALTER TABLE flight_data_copy
ADD Flight_Speed FLOAT

UPDATE flight_data_copy
SET Flight_Speed = (distance/air_time) * 60

-- Observe the average flight speed for each carrier
SELECT carrier, AVG(Flight_Speed) AS avg_flight_speed
FROM flight_data_copy
GROUP BY carrier
ORDER BY 2 DESC

---------------------------------------------------------------------------------------------------
-- PART 7: CLEANING AND JOINING WEATHER DATA 
---------------------------------------------------------------------------------------------------

-- Determine the number of missing values in each column
SELECT COUNT(CASE WHEN origin IS NULL THEN 1 END) AS OriginNullCount,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS YearNullCount,
    COUNT(CASE WHEN month IS NULL THEN 1 END) AS MonthNullCount,
	COUNT(CASE WHEN day IS NULL THEN 1 END) AS DayNullCount,
    COUNT(CASE WHEN hour IS NULL THEN 1 END) AS HourNullCount,
	COUNT(CASE WHEN temp IS NULL THEN 1 END) AS TempNullCount,
    COUNT(CASE WHEN dewp IS NULL THEN 1 END) AS DewPNullCount,
	COUNT(CASE WHEN humid IS NULL THEN 1 END) AS HumidNullCount,
    COUNT(CASE WHEN wind_dir IS NULL THEN 1 END) AS WindDirNullCount,
	COUNT(CASE WHEN wind_speed IS NULL THEN 1 END) AS WindSpeedNullCount,
    COUNT(CASE WHEN wind_gust IS NULL THEN 1 END) AS WindGustNullCount,
	COUNT(CASE WHEN precip IS NULL THEN 1 END) AS PrecipNullCount,
	COUNT(CASE WHEN pressure IS NULL THEN 1 END) AS PressureNullCount,
	COUNT(CASE WHEN visib IS NULL THEN 1 END) AS VisibNullCount,
	COUNT(CASE WHEN time_hour IS NULL THEN 1 END) AS time_hourNullCount
FROM Weather_2013

-- Set the value of the wind_gust to 0 if it is missing
UPDATE Weather_2013
SET wind_gust = 0
WHERE (wind_gust IS NULL)

-- Set the value of wind speed to 0 if it is missing
UPDATE Weather_2013
SET wind_speed = 0
WHERE (wind_speed IS NULL)

-- Sort the table by airport instead of by time and make it into a new table
SELECT *
INTO weather_sorted
FROM Weather_2013
ORDER BY origin

-- For the temp, dewp, humid, wind_dir, and pressure columns, update missing values with the amount preceding it
DROP TABLE IF EXISTS temp_table
SELECT origin, time_hour, ISNULL(source.temp, excludeNulls.LastCnt) AS new_temp
INTO temp_table
FROM weather_sorted source
OUTER APPLY ( SELECT TOP 1 temp as LastCnt
              FROM  weather_sorted 
              WHERE time_hour < source.time_hour
              AND temp IS NOT NULL
              ORDER BY origin) ExcludeNulls
ORDER BY origin
DROP TABLE IF EXISTS dewp_table
SELECT origin, time_hour, ISNULL(source.dewp, excludeNulls.LastCnt) AS new_dewp
INTO dewp_table
FROM weather_sorted source
OUTER APPLY ( SELECT TOP 1 dewp as LastCnt
              FROM  weather_sorted 
              WHERE time_hour < source.time_hour
              AND dewp IS NOT NULL
              ORDER BY origin) ExcludeNulls
ORDER BY origin
DROP TABLE IF EXISTS humid_table
SELECT origin, time_hour, ISNULL(source.humid, excludeNulls.LastCnt) AS new_humid
INTO humid_table
FROM weather_sorted source
OUTER APPLY ( SELECT TOP 1 humid as LastCnt
              FROM  weather_sorted 
              WHERE time_hour < source.time_hour
              AND humid IS NOT NULL
              ORDER BY origin) ExcludeNulls
ORDER BY origin
DROP TABLE IF EXISTS wind_dir_table
SELECT origin, time_hour, ISNULL(source.wind_dir, excludeNulls.LastCnt) AS new_wind_dir
INTO wind_dir_table
FROM weather_sorted source
OUTER APPLY ( SELECT TOP 1 wind_dir as LastCnt
              FROM  weather_sorted 
              WHERE time_hour < source.time_hour
              AND wind_dir IS NOT NULL
              ORDER BY origin) ExcludeNulls
ORDER BY origin
DROP TABLE IF EXISTS pressure_table
SELECT origin, time_hour, ISNULL(source.pressure, excludeNulls.LastCnt) AS new_pressure
INTO pressure_table
FROM weather_sorted source
OUTER APPLY ( SELECT TOP 1 pressure as LastCnt
              FROM  weather_sorted 
              WHERE time_hour < source.time_hour
              AND pressure IS NOT NULL
              ORDER BY origin) ExcludeNulls
			  ORDER BY origin

-- For temp, dewp, humid, wind_dir, and pressure, join the tables to the weather_sorted table
DROP TABLE IF EXISTS new_weather
SELECT a.origin, a.time_hour, a.year, a.month, a.day, 
       a.hour, a.wind_speed, a.wind_gust, a.precip, a.visib,
	   b.new_temp, c.new_dewp, d.new_humid, e.new_wind_dir, f.new_pressure
INTO new_weather
FROM weather_sorted a
LEFT JOIN temp_table b
ON (a.origin = b.origin) AND (a.time_hour = b.time_hour)
LEFT JOIN dewp_table c
ON (b.origin = c.origin) AND (b.time_hour = c.time_hour)
LEFT JOIN humid_table d
ON (c.origin = d.origin) AND (c.time_hour = d.time_hour)
LEFT JOIN wind_dir_table e
ON (d.origin = e.origin) AND (d.time_hour = e.time_hour)
LEFT JOIN pressure_table f
ON (e.origin = f.origin) AND (e.time_hour = f.time_hour)

-- Join the weather data to the flight_data_copy
DROP TABLE IF EXISTS new_flight
SELECT a.origin, a.time_hour, a.dep_time, a.sched_dep_time, a.dep_delay, a.arr_time, a.sched_arr_time, a.arr_delay, a.carrier, a.flight,
       a.dest, a.air_time, a.distance, a.day_of_year, a.day_of_week, a.month_of_year, a.net_delay, a.On_Time, a.Flight_Speed, b.year, 
	   b.month, b.day, b.hour, b.wind_speed, b.wind_gust, b.precip, b.visib, b.new_temp, b.new_dewp, b.new_humid, b.new_wind_dir,
	   b.new_pressure
INTO new_flight
FROM flight_data_copy a
LEFT JOIN new_weather b
ON (a.origin = b.origin) AND (a.time_hour = b.time_hour)
ORDER BY time_hour

---------------------------------------------------------------------------------------------------
-- PART 8: OBSERVING TRENDS IN WEATHER DATA 
---------------------------------------------------------------------------------------------------

-- Return a summary of each month's weather patterns
SELECT month_of_year, AVG(new_temp) as avg_temp, AVG(new_dewp) AS avg_dewp, AVG(wind_speed) AS avg_wind_speed, AVG(precip) AS avg_precip_per_month 
FROM new_flight
GROUP BY month_of_year

-- Observe if precipitation has an effect on On_Time Percentage
SELECT COUNT(CASE WHEN (On_Time = 'no') AND (precip = 0) THEN 1 END) AS Not_On_Time_Clear,
       COUNT(CASE WHEN (On_Time = 'yes') AND (precip = 0) THEN 1 END) AS On_Time_Clear,
	   COUNT(CASE WHEN (On_Time = 'no') AND (precip > 0) THEN 1 END) AS Not_On_Time_Precip,
	   COUNT(CASE WHEN (On_Time = 'yes') AND (precip > 0) THEN 1 END) AS On_Time_Precip
FROM new_flight

-- Observe if visibility has an effect on On_Time Percentage
SELECT visib, COUNT(CASE WHEN (On_Time = 'yes') THEN 1 END) AS On_Time, COUNT(CASE WHEN (On_Time = 'no') THEN 1 END) AS Not_On_Time
FROM new_flight
group by visib
order by visib

-- Observe if Flight_Speed is correlated with wind_speed or wind_gust
SELECT wind_gust, AVG(wind_speed) AS AVG_Wind_Speed, AVG(Flight_Speed) AS Avg_Flight_Speed
FROM new_flight
group by wind_gust
order by wind_gust

---------------------------------------------------------------------------------------------------
-- PART 9: EXPORTING DATA TO EXCEL FOR TABLEAU VISUALIZATION 
---------------------------------------------------------------------------------------------------

SELECT * 
FROM new_flight