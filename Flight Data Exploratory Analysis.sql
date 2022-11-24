
--- Skills used: Select/Delete/Update statements, Converting data types, Aggregate Functions

--------------------------------------------------
-- Part 1: Loading/Observing Data
--------------------------------------------------

-- Load all data
SELECT * 
FROM flight_data
ORDER BY 2,3

--------------------------------------------------
-- Part 2: Observing Number of Delays
--------------------------------------------------

-- Observe the number of delays for each carrier
SELECT carrier, count(carrier) AS num_delays
FROM flight_data
GROUP BY carrier
ORDER BY 2 DESC

-- Observe the number of delays for each airport
SELECT origin, count(origin) AS num_delays
FROM flight_data
GROUP BY origin
ORDER BY 2 DESC

--------------------------------------------------
-- Part 3: Net/Average Delay Times, Delays vs Day
--------------------------------------------------

-- Calculate the net delay time of each flight (how much time each fight saved/lost in total)
SELECT DATEFROMPARTS(2013,month,day) as day_of_year, carrier, origin, flight, dep_delay, arr_delay, (dep_delay+arr_delay) as net_delay_time
FROM flight_data
ORDER BY 1

-- Compute the average delay time of each carrier at each airport
SELECT origin, carrier, count(carrier) as number_of_delays, AVG(dep_delay) as avg_dep_delay, AVG(arr_delay) as avg_arr_delay
FROM flight_data
GROUP BY origin, carrier
ORDER BY origin, number_of_delays DESC 

--Observe the days of the year in which more flights were delayed
SELECT DATEFROMPARTS(2013,month,day) as day_of_year, count(flight) as num_delays
FROM flight_data
GROUP BY DATEFROMPARTS(2013,month,day)
ORDER BY num_delays DESC

-- Observe the number of delays each day for each airport
SELECT DATEFROMPARTS(2013,month,day) as day_of_year, origin, 
count(origin) as num_delays
FROM flight_data
GROUP BY DATEFROMPARTS(2013,month,day), origin
ORDER BY day_of_year, origin

-- Observe the number of delays each day for each carrier
SELECT DATEFROMPARTS(2013,month,day) as day_of_year, carrier, 
count(carrier) as num_delays
FROM flight_data
GROUP BY DATEFROMPARTS(2013,month,day), carrier
ORDER BY day_of_year, carrier

--------------------------------------------------
-- Part 4: On Time Percentage
--------------------------------------------------

-- Calculate the On Time Percentage for each carrier (percent of time where arr_delay < 15 minutes)
ALTER TABLE flight_data
Add On_Time nvarchar(255)

UPDATE flight_data
SET On_Time = 'yes'
WHERE abs(arr_delay)<15

select carrier, count(On_Time) as times_on_time, count(carrier) as num_flights, 
(cast(count(On_Time) as float)/cast(count(carrier) as float))*100 as OTP
FROM flight_data
GROUP BY carrier
ORDER BY OTP DESC

-- Calculate the On-Time Percentage for each airport
select origin, count(On_Time) as times_on_time, count(origin) as num_flights, 
(cast(count(On_Time) as float)/cast(count(origin) as float))*100 as OTP
FROM flight_data
GROUP BY origin
ORDER BY OTP DESC

-- Calculate the On-Time Percentage for each carrier at each airport
select origin, carrier, count(On_Time) as times_on_time, count(carrier) as num_flights, 
(cast(count(On_Time) as float)/cast(count(carrier) as float))*100 as OTP
FROM flight_data
GROUP BY origin, carrier
ORDER BY OTP DESC

--------------------------------------------------
-- Part 5: Flight Speed
--------------------------------------------------

-- Calculate the Flight Speed of each flight
ALTER TABLE flight_data
ADD Flight_Speed float

UPDATE flight_data
SET Flight_Speed = (distance/air_time)*60

-- Observe the average flight speed for each carrier
SELECT carrier, avg(Flight_Speed) AS avg_flight_speed
FROM flight_data
GROUP BY carrier
ORDER BY 2 DESC

--------------------------------------------------
-- Part 6: Code for Time Series Analysis in R
--------------------------------------------------

-- Observe the total number of delays experienced each day
SELECT DATEFROMPARTS(2013,month,day) as day_of_year, count(carrier) as num_delays
FROM flight_data
GROUP BY DATEFROMPARTS(2013,month,day)
ORDER by 1
