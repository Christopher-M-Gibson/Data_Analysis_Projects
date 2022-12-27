
--- Skills used: Select/Delete/Update statements, Converting data types, Aggregate Functions, Cases

--------------------------------------------------
-- Part 1: Clean the data
--------------------------------------------------

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
    COUNT(CASE WHEN distance IS NULL THEN 1 END) AS DistanceNullCount
FROM flight_data

-- Make a copy of the data such that there are no null values present
SELECT *
INTO flight_data_copy
FROM flight_data
WHERE (dep_time IS NOT NULL) AND (dep_delay IS NOT NULL) AND (arr_time IS NOT NULL) AND (arr_delay IS NOT NULL) AND (air_time IS NOT NULL)

-- Drop unneeded columns FROM THE COPIED TABLE
ALTER TABLE flight_data_copy
DROP COLUMN year, month, day, tailnum, hour, minute, time_hour

--------------------------------------------------
-- Part 2: Observing Number of Delays
--------------------------------------------------

-- Observe the number of delays for each carrier
SELECT carrier, COUNT(carrier) AS num_delays
FROM flight_data_copy
GROUP BY carrier
ORDER BY 2 DESC

-- Observe the number of delays for each airport
SELECT origin, COUNT(origin) AS num_delays
FROM flight_data_copy
GROUP BY origin
ORDER BY 2 DESC

--------------------------------------------------
-- Part 3: Net/Average Delay Times, Delays vs Day
--------------------------------------------------

-- Calculate the net delay time of each flight (how much time each fight saved/lost in total)
SELECT day_of_year, carrier, origin, flight, dep_delay, arr_delay, (dep_delay+arr_delay) AS net_delay_time
FROM flight_data_copy
ORDER BY 1

-- Compute the average delay time of each carrier at each airport
SELECT origin, carrier, COUNT(carrier) AS number_of_delays, AVG(dep_delay) AS avg_dep_delay, AVG(arr_delay) AS avg_arr_delay
FROM flight_data_copy
GROUP BY origin, carrier
ORDER BY 1, 2 DESC 

--Observe the days of the year in which more flights were delayed
SELECT day_of_year, COUNT(flight) AS num_delays
FROM flight_data_copy
GROUP BY day_of_year
ORDER BY 2 DESC

-- Observe the number of delays each day for each airport
SELECT day_of_year, origin, COUNT(origin) AS num_delays
FROM flight_data_copy
GROUP BY day_of_year, origin
ORDER BY 1, 2

-- Observe the number of delays each day for each carrier
SELECT day_of_year, carrier, COUNT(carrier) AS num_delays
FROM flight_data_copy
GROUP BY day_of_year, carrier
ORDER BY 1, 2

--------------------------------------------------
-- Part 4: On Time Percentage
--------------------------------------------------

-- Calculate the On Time Percentage for each carrier (percent of time where arr_delay <= 15 minutes)
ALTER TABLE flight_data_copy
ADD On_Time NVARCHAR(255)

UPDATE flight_data_copy
SET On_Time = 'yes'
WHERE ABS(arr_delay) <= 15

UPDATE flight_data_copy
SET On_Time = 'no'
WHERE ABS(arr_delay) > 15

SELECT carrier, 
	COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS times_on_time, 
	COUNT(carrier) AS num_flights, 
	(CAST(COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS FLOAT)/CAST(COUNT(carrier) AS FLOAT))*100 AS OTP
FROM flight_data_copy
GROUP BY carrier
ORDER BY 4 DESC

-- Calculate the On-Time Percentage for each airport
SELECT origin, 
	COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS times_on_time, 
	COUNT(origin) AS num_flights, 
	(CAST(COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS FLOAT)/CAST(COUNT(origin) AS FLOAT))*100 AS OTP
FROM flight_data_copy
GROUP BY origin
ORDER BY 4 DESC

-- Calculate the On-Time Percentage for each carrier at each airport
SELECT origin, carrier, 
	COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS times_on_time, 
	COUNT(carrier) AS num_flights, 
	(CAST(COUNT(CASE On_Time WHEN 'yes' THEN 1 END) AS FLOAT)/CAST(COUNT(carrier) AS FLOAT))*100 AS OTP
FROM flight_data_copy
GROUP BY origin, carrier
ORDER BY 5 DESC

--------------------------------------------------
-- Part 5: Flight Speed
--------------------------------------------------

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
