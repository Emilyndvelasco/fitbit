-- Check for duplicate rows in dailyactivity.

SELECT Id, ActivityDate, COUNT(*) AS num_duplicates
 FROM `bellabeat-385419.Bellabeat.dailyactivity` 
 GROUP BY Id, ActivityDate
 ORDER BY num_duplicates DESC


 -- Check for duplicate rows in sleepday.

 SELECT Id, SleepDay, COUNT(*) AS num_duplicates
    FROM `bellabeat-385419.Bellabeat.sleepday` 
    GROUP BY Id, SleepDay
    ORDER BY num_duplicates DESC


 -- Filter out duplicate rows.
 
SELECT DISTINCT *
   FROM `bellabeat-385419.Bellabeat.sleepday`


-- Find out how many users are in the dataset.

SELECT COUNT (DISTINCT Id) AS TotalUsers
  FROM `bellabeat-385419.Bellabeat.dailyactivity` 


  -- Find out when the data was collected.
  
SELECT MIN(ActivityDate) AS StartDate, MAX(ActivityDate) AS EndDate 
  FROM `bellabeat-385419.Bellabeat.dailyactivity` 


  -- Segment our users by how many steps they take. Only average dates for which the tracker was used. We assume dates where the step count was 0, the tracker was not used.

  SELECT Id, ROUND(AVG(TotalSteps)) AS AverageDailySteps
     FROM `bellabeat-385419.Bellabeat.dailyactivity` 
     WHERE TotalSteps > 0
     GROUP BY Id


  -- Use a case statement to categorize our users according to steps taken.

SELECT Id, 
       ROUND(AVG(TotalSteps)) AS AverageDailySteps,
       CASE
           WHEN AVG(TotalSteps) < 5000 THEN 'sedentary'
           WHEN AVG(TotalSteps) >= 5000 AND AVG(TotalSteps) < 7500 THEN 'low active'
           WHEN AVG(TotalSteps) >= 7500 AND AVG(TotalSteps) < 10000 THEN 'somewhat active'
           WHEN AVG(TotalSteps) >= 10000 AND AVG(TotalSteps) <= 12500 THEN 'active'
           WHEN AVG(TotalSteps) > 12500 THEN 'highly active'
           ELSE 'unknown'
       END AS ActivityLevel
   FROM `bellabeat-385419.Bellabeat.dailyactivity` 
   WHERE TotalSteps > 0
   GROUP BY Id


-- Now count the number of users per category using a subquery. 

SELECT 
  ActivityLevel, 
  COUNT(*) AS NumberOfUsers
FROM (
  SELECT 
    Id,
    CASE 
      WHEN AVG(TotalSteps) < 5000 THEN 'sedentary'
      WHEN AVG(TotalSteps) BETWEEN 5000 AND 7499 THEN 'low active'
      WHEN AVG(TotalSteps) BETWEEN 7500 AND 9999 THEN 'somewhat active'
      WHEN AVG(TotalSteps) >= 10000 AND AVG(TotalSteps) <= 12500 THEN 'active'
      WHEN AVG(TotalSteps) > 12500 THEN 'highly active'
    END AS ActivityLevel
  FROM `bellabeat-385419.Bellabeat.dailyactivity` 
  WHERE TotalSteps > 0
  GROUP BY Id
) 
GROUP BY ActivityLevel



-- Now count the number of users per category using a subquery. Add a column for Percent! 

SELECT 
  ActivityLevel, 
  COUNT(*) AS NumberOfIds,
  COUNT(*) / (SELECT COUNT(DISTINCT Id) FROM `bellabeat-385419.Bellabeat.dailyactivity` WHERE TotalSteps > 0) AS Percent
FROM (
  SELECT 
    Id,
    CASE 
      WHEN AVG(TotalSteps) < 5000 THEN 'sedentary'
      WHEN AVG(TotalSteps) BETWEEN 5000 AND 7499 THEN 'low active'
      WHEN AVG(TotalSteps) BETWEEN 7500 AND 9999 THEN 'somewhat active'
      WHEN AVG(TotalSteps) >= 10000 AND AVG(TotalSteps) <= 12500 THEN 'active'
      WHEN AVG(TotalSteps) > 12500 THEN 'highly active'
    END AS ActivityLevel
  FROM `bellabeat-385419.Bellabeat.dailyactivity` 
  WHERE TotalSteps > 0
  GROUP BY Id
) 
GROUP BY ActivityLevel


-- Find out how often users use their devices. How many days were they inactive?

SELECT Id, COUNT(TotalSteps) AS DaysUsed
  FROM `bellabeat-385419.Bellabeat.dailyactivity` 
  WHERE TotalSteps > 0
  GROUP BY Id


  -- Find out how often users use their devices and categorize them according to days used.
  
SELECT Id, COUNT(TotalSteps) AS DaysUsed,
  CASE
    WHEN COUNT(TotalSteps) <=10 THEN 'Infrequent User'
    WHEN COUNT(TotalSteps) > 10 AND COUNT(TotalSteps) <= 20 THEN 'Moderate User'
    WHEN COUNT(TotalSteps) > 20 AND COUNT(TotalSteps) <= 30 THEN 'Frequent User'
    WHEN COUNT(TotalSteps) = 31 THEN 'Daily User'
    ELSE 'unknown'
  END AS Frequency
  FROM `bellabeat-385419.Bellabeat.dailyactivity` 
  WHERE TotalSteps > 0
  GROUP BY Id


  -- Now count the number of users per category using a subquery. 


SELECT Frequency, COUNT(*) AS TotalUsers,
FROM (
  SELECT Id, 
  CASE
    WHEN COUNT(TotalSteps) <=10 THEN 'Infrequent User'
    WHEN COUNT(TotalSteps) > 10 AND COUNT(TotalSteps) <= 20 THEN 'Moderate User'
    WHEN COUNT(TotalSteps) > 20 AND COUNT(TotalSteps) <= 30 THEN 'Frequent User'
    WHEN COUNT(TotalSteps) = 31 THEN 'Daily User'
    ELSE 'unknown'
  END AS Frequency
  FROM `bellabeat-385419.Bellabeat.dailyactivity` 
  WHERE TotalSteps > 0
  GROUP BY Id
)
  GROUP BY Frequency


-- Now count the number of users per category using a subquery. Add a column for percentage!

SELECT Frequency, COUNT(*) AS TotalUsers, ROUND (COUNT(*)*100/33, 1) AS Percent
FROM (
  SELECT Id, 
  CASE
    WHEN COUNT(TotalSteps) <=10 THEN 'Infrequent User'
    WHEN COUNT(TotalSteps) > 10 AND COUNT(TotalSteps) <= 20 THEN 'Moderate User'
    WHEN COUNT(TotalSteps) > 20 AND COUNT(TotalSteps) <= 30 THEN 'Frequent User'
    WHEN COUNT(TotalSteps) = 31 THEN 'Daily User'
    ELSE 'unknown'
  END AS Frequency
  FROM `bellabeat-385419.Bellabeat.dailyactivity` 
  WHERE TotalSteps > 0
  GROUP BY Id
)
  GROUP BY Frequency


  -- Find out how often users of different step counts use their device.
  
SELECT Id, 
       ROUND(AVG(TotalSteps)) AS AverageDailySteps,
       CASE
           WHEN AVG(TotalSteps) < 5000 THEN 'sedentary'
           WHEN AVG(TotalSteps) >= 5000 AND AVG(TotalSteps) < 7500 THEN 'low active'
           WHEN AVG(TotalSteps) >= 7500 AND AVG(TotalSteps) < 10000 THEN 'somewhat active'
           WHEN AVG(TotalSteps) >= 10000 AND AVG(TotalSteps) <= 12500 THEN 'active'
           WHEN AVG(TotalSteps) > 12500 THEN 'highly active'
           ELSE 'unknown'
       END AS ActivityLevel,
       COUNT(TotalSteps) AS DaysUsed,
       CASE
          WHEN COUNT(TotalSteps) <=10 THEN 'Infrequent User'
          WHEN COUNT(TotalSteps) > 10 AND COUNT(TotalSteps) <= 20 THEN 'Moderate User'
          WHEN COUNT(TotalSteps) > 20 AND COUNT(TotalSteps) <= 30 THEN 'Frequent User'
          WHEN COUNT(TotalSteps) = 31 THEN 'Daily User'
          ELSE 'unknown'
        END AS Frequency
		
FROM `bellabeat-385419.Bellabeat.dailyactivity` 
WHERE TotalSteps > 0
GROUP BY Id
ORDER BY ActivityLevel


-- Find out how many users collected sleep data. 

SELECT COUNT (DISTINCT Id) AS NumberOfUsers
 FROM `bellabeat-385419.Bellabeat.sleepdaycleaned` 


 -- Find out the average length of time each user slept on days for which they used their device. 
 
SELECT Id, ROUND (AVG(TotalMinutesAsleep))AS AverageTimeSlept, ROUND ((AVG(TotalMinutesAsleep))/60, 2) AS AverageTimeSleptHrs
 FROM `bellabeat-385419.Bellabeat.sleepdaycleaned` 
 GROUP BY Id
 ORDER BY AverageTimeSlept DESC


 -- Investigate why some users have unusually high or low average sleep times. I used a join here because I cannot use an aggregate function in a where clause.

 SELECT s.*, ROUND(s.TotalMinutesAsleep/60, 2) AS TotalHoursSlept
FROM `bellabeat-385419.Bellabeat.sleepdaycleaned` s
JOIN (
  SELECT Id
  FROM `bellabeat-385419.Bellabeat.sleepdaycleaned`
  GROUP BY Id
  HAVING ROUND(AVG(TotalMinutesAsleep)) < 4*60 OR ROUND(AVG(TotalMinutesAsleep)) > 9*60
) t ON s.Id = t.Id
ORDER BY s.Id, s.SleepDay


-- Find out how many users collected usable sleep data, meaning that they wore the watch to sleep at night and not just for naps. Select users who have slept between 4 and 9 hours on average. 

SELECT COUNT (DISTINCT Id) AS NumberOfUsers
  FROM (
    SELECT Id
    FROM `bellabeat-385419.Bellabeat.sleepdaycleaned`
    GROUP BY Id
    HAVING ROUND (AVG (TotalMinutesAsleep)) >4*60 AND ROUND (AVG(TotalMinutesAsleep)) <9*60
    )


-- Find out the average length of time each user slept on days for which they used their device. Include only users who wore the device at night.

SELECT Id, ROUND(AVG(TotalMinutesAsleep)) AS AverageTimeSlept, ROUND(AVG(TotalMinutesAsleep) / 60, 2) AS AverageTimeSleptHrs
FROM `bellabeat-385419.Bellabeat.sleepdaycleaned`
WHERE Id IN (
  SELECT Id
  FROM `bellabeat-385419.Bellabeat.sleepdaycleaned`
  GROUP BY Id
  HAVING AVG(TotalMinutesAsleep) > 4 * 60 AND AVG(TotalMinutesAsleep) < 9 * 60
)
GROUP BY Id
ORDER BY AverageTimeSlept DESC


-- Now join the dailyactivity information with the sleepdaycleaned information so that individual users are categorized  by activity level, frequency, and time slept. The query is getting overly complicated, so instead of using the JOIN function, Ive decided to save new tables and then join them. The new dailyactivity information is now in a table called ActivityLevel and the new sleepdaycleaned information is in a table called SleepTime.

SELECT AL.Id, AL.AverageDailySteps, AL.ActivityLevel, AL.DaysUsed, AL.Frequency, ST.AverageTimeSlept, ST.AverageTimeSleptHrs
 FROM `bellabeat-385419.Bellabeat.ActivityLevel` AS AL
 FULL OUTER JOIN `bellabeat-385419.Bellabeat.SleepTime` AS ST ON AL.Id = ST.Id
 ORDER BY AverageDailySteps DESC


 -- Check whether there are duplicates in the hourlysteps data.
 
SELECT Id, ActivityHour, COUNT (*) AS num_duplicates
FROM `bellabeat-385419.Bellabeat.hourlysteps`
GROUP BY Id, ActivityHour
ORDER BY num_duplicates DESC


-- Find out average steps across all users by hour of the day. 

SELECT TIME(ActivityHour) AS TimeOfDay, ROUND(AVG(StepTotal),0) AS AverageSteps
FROM `bellabeat-385419.Bellabeat.hourlysteps`
GROUP BY TimeOfDay
ORDER BY TimeOfDay


-- Find out average step count by days of the week. 

SELECT DayOfWeekNum, Weekday, ROUND(AVG(AverageSteps)) AS AverageStepsByWeekday
FROM(
    SELECT 
      ActivityDate,
      EXTRACT(DAYOFWEEK FROM ActivityDate) AS DayOfWeekNum,
      CASE(EXTRACT(DAYOFWEEK FROM ActivityDate))
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        ELSE 'Unknown'
        END AS Weekday,
      ROUND(AVG(TotalSteps), 0) AS AverageSteps
    FROM 
      `bellabeat-385419.Bellabeat.dailyactivity`
    GROUP BY ActivityDate
    )
GROUP BY DayOfWeekNum, Weekday
ORDER BY DayOfWeekNum


-- Find out how much sleep people got according to the day of the week.

SELECT DayOfWeekNum, Weekday, ROUND(AVG(AverageTimeSlept)) AS AverageTimeSleptByWeekday, ROUND(AVG(AverageTimeSlept)/60,2) AS AverageTimeSleptHrs
FROM(
    SELECT SleepDay, 
      EXTRACT (DAYOFWEEK FROM SleepDay) AS DayOfWeekNum,
      CASE EXTRACT (DAYOFWEEK FROM SleepDay)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        ELSE 'Unknown'
        END AS Weekday,
      ROUND (AVG(TotalMinutesAsleep)) AS AverageTimeSlept
    FROM `bellabeat-385419.Bellabeat.sleepdaycleaned` 
    GROUP BY SleepDay, DayOfWeekNum
    )
GROUP BY DayOfWeekNum, Weekday
ORDER BY DayOfWeekNum




