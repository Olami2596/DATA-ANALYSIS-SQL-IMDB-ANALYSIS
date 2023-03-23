--creating a copy of the dataset
SELECT *
INTO IMDBMOVIEDATASETNEW
FROM IMDbmovieDataset;



--VIEWING THE DISTINCT VALUES IN THE DATASET
SELECT DISTINCT *
FROM IMDBMOVIEDATASETNEW



--DELETING ROWS THAT CONTAINS NOT RELEASED IN THE RUN_TIME COLUMN
DELETE FROM IMDBMOVIEDATASETNEW
WHERE Run_Time = 'not-released';



--DELETING ROWS THAT CONTAINS something like $25,000,000 (estimated) IN THE RUN_TIME COLUMN
DELETE FROM IMDBMOVIEDATASETNEW
WHERE Run_Time LIKE '%$%(estimated)%';



--DELETING ROWS THAT CONTAINS something like thb IN THE RUN_TIME COLUMN
DELETE FROM IMDBMOVIEDATASETNEW
WHERE Run_Time LIKE '%THB%';



--DELETING ROWS THAT CONTAINS something like $ IN THE RUN_TIME COLUMN
DELETE FROM IMDBMOVIEDATASETNEW
WHERE Run_Time LIKE '%$%';



--DELETING ROWS THAT CONTAINS something like £ IN THE RUN_TIME COLUMN
DELETE FROM IMDBMOVIEDATASETNEW
WHERE Run_Time LIKE '%£%';



--DELETING ROWS THAT CONTAINS something like ? IN THE RUN_TIME COLUMN
DELETE FROM IMDBMOVIEDATASETNEW
WHERE Run_Time LIKE '%?%';




--DELETING ROWS THAT DO NOT CONTAIN HOUR
DELETE FROM IMDBMOVIEDATASETNEW
WHERE Run_Time NOT LIKE '%hour%';




--REPLACING ALL ROWS THAT CONTAIN HOUR OR HOURS WITH - AND MINUTE OR MINUTES WITH EMPTY STRING
UPDATE IMDBMOVIEDATASETNEW
SET Run_Time = REPLACE(REPLACE(Run_Time, 'hour', '-'), 'hours', '')
WHERE Run_Time LIKE '%hour%' 


UPDATE IMDBMOVIEDATASETNEW
SET Run_Time = REPLACE(REPLACE(Run_Time, 'minute', ''), 'minutes', '')
WHERE Run_Time LIKE '%minute%';


UPDATE IMDBMOVIEDATASETNEW
SET Run_Time = REPLACE(Run_Time, 's', '')
WHERE Run_Time LIKE '%s%';




--coverting the runtime column into minutes
SELECT 
    CASE 
        WHEN CHARINDEX('-', Run_Time) > 0 THEN 
            COALESCE(CAST(SUBSTRING(Run_Time, 1, CHARINDEX('-', Run_Time) - 1) AS INT), 0) * 60 
            + COALESCE(CAST(SUBSTRING(Run_Time, CHARINDEX('-', Run_Time) + 1, LEN(Run_Time) - CHARINDEX('-', Run_Time)) AS INT), 0)
        ELSE 0 
    END AS Runtime_in_minutes
FROM IMDBMOVIEDATASETNEW;




-- adding the newly created column to the table
ALTER TABLE IMDBMOVIEDATASETNEW
ADD Runtime_in_minutes INT;

UPDATE IMDBMOVIEDATASETNEW
SET Runtime_in_minutes = 
    CASE 
        WHEN CHARINDEX('-', Run_Time) > 0 THEN 
            COALESCE(CAST(SUBSTRING(Run_Time, 1, CHARINDEX('-', Run_Time) - 1) AS INT), 0) * 60 
            + COALESCE(CAST(SUBSTRING(Run_Time, CHARINDEX('-', Run_Time) + 1, LEN(Run_Time) - CHARINDEX('-', Run_Time)) AS INT), 0)
        ELSE 0 
    END;




--dropping the runtime column
ALTER TABLE IMDBMOVIEDATASETNEW
DROP COLUMN Run_Time;




--replacing - with empty string
UPDATE IMDBMOVIEDATASETNEW
SET year = REPLACE(year, '-', '')
WHERE year LIKE '%-%';


UPDATE IMDBMOVIEDATASETNEW
SET year = REPLACE(year, '(', '')
WHERE year LIKE '%(%';


UPDATE IMDBMOVIEDATASETNEW
SET year = REPLACE(year, ')', '')
WHERE year LIKE '%)%';


UPDATE IMDBMOVIEDATASETNEW
SET year = REPLACE(year, 'I', '')
WHERE year LIKE '%I%';


UPDATE IMDBMOVIEDATASETNEW
SET year = REPLACE(year, 'V', '')
WHERE year LIKE '%[A-Z]%';


UPDATE IMDBMOVIEDATASETNEW
SET year = REPLACE(year, 'X', '')
WHERE year LIKE '%[A-Z]%';




SELECT LTRIM(RTRIM(year)) AS trimmedyear
FROM IMDBMOVIEDATASETNEW;


ALTER TABLE IMDBMOVIEDATASETNEW 
ADD trimmed_year INT;


UPDATE IMDBMOVIEDATASETNEW
SET trimmed_year = CAST(LTRIM(RTRIM(year)) AS INT);



--dropping the YEAR column
ALTER TABLE IMDBMOVIEDATASETNEW
DROP COLUMN year;




--
UPDATE IMDBMOVIEDATASETNEW
SET User_Rating = CAST(REPLACE(User_Rating, 'K', '00') AS FLOAT) * 10





UPDATE IMDBMOVIEDATASETNEW
SET User_Rating = CONCAT('00', User_Rating)
WHERE LEN(User_Rating) = 2;

UPDATE IMDBMOVIEDATASETNEW
SET User_Rating = SUBSTRING(User_Rating, 3, LEN(User_Rating) - 2)
WHERE User_Rating LIKE '00%';

UPDATE IMDBMOVIEDATASETNEW
SET User_Rating = CONCAT(User_Rating, '00')
WHERE LEN(User_Rating) = 2;

--VIEWING THE DISTINCT VALUES IN THE DATASET
SELECT DISTINCT *
FROM IMDBMOVIEDATASETNEW


-- Convert Runtime_in_minutes column to int
ALTER TABLE IMDBMOVIEDATASETNEW
ALTER COLUMN Runtime_in_minutes INT;

-- Convert Rating column to float
ALTER TABLE IMDBMOVIEDATASETNEW
ALTER COLUMN Rating FLOAT;

-- Convert User_Rating column to int
ALTER TABLE IMDBMOVIEDATASETNEW
ALTER COLUMN User_Rating INT;

-- Convert trimmed_year column to float
ALTER TABLE IMDBMOVIEDATASETNEW
ALTER COLUMN trimmed_year INT;

-- deleting rows that contains null or 0 values
DELETE FROM IMDBMOVIEDATASETNEW
WHERE (Runtime_in_minutes IS NULL OR Runtime_in_minutes = 0) 
OR (Rating IS NULL OR Rating = 0) 
OR (User_Rating IS NULL OR User_Rating = 0) 
OR (trimmed_year IS NULL OR trimmed_year = 0);





-- most frequent directors
CREATE VIEW MostFrequentDirector AS
SELECT TOP 10 Director, COUNT(*) as Frequency
FROM IMDBMOVIEDATASETNEW
WHERE Director IS NOT NULL
GROUP BY Director
ORDER BY Frequency DESC;



-- most frequent ACTORS
CREATE VIEW MostFrequentACTORS AS
SELECT TOP 10 TRIM(REPLACE(value, ']', '')) AS Actor, COUNT(*) AS Frequency
FROM IMDBMOVIEDATASETNEW
CROSS APPLY STRING_SPLIT(Top_5_Casts, ',')  
WHERE Top_5_Casts IS NOT NULL
GROUP BY TRIM(REPLACE(value, ']', ''))
ORDER BY Frequency DESC




--renaming the columns
EXEC sp_rename 'IMDBMOVIEDATASETNEW.Generes', 'Genres', 'COLUMN';
EXEC sp_rename 'IMDBMOVIEDATASETNEW.Plot_Kyeword', 'Plot_Keyword', 'COLUMN';





-- most frequent keyword
CREATE VIEW MostFrequentkeyword AS
SELECT TOP 10 TRIM(REPLACE(REPLACE(value, '[', ''), ']', '')) AS Keyword, COUNT(*) AS Frequency
FROM IMDBMOVIEDATASETNEW
CROSS APPLY STRING_SPLIT(Plot_Keyword, ',')  
WHERE Plot_Keyword IS NOT NULL
GROUP BY TRIM(REPLACE(REPLACE(value, '[', ''), ']', ''))
ORDER BY Frequency DESC




-- most frequent genre
CREATE VIEW MostFrequentgenre AS
SELECT TOP 10 TRIM(REPLACE(REPLACE(value, '[', ''), ']', '')) AS Genre, COUNT(*) AS Frequency
FROM IMDBMOVIEDATASETNEW
CROSS APPLY STRING_SPLIT(Genres, ',')  
WHERE Genres IS NOT NULL
GROUP BY TRIM(REPLACE(REPLACE(value, '[', ''), ']', ''))
ORDER BY Frequency DESC


--TOP RATED MOVIES
SELECT TOP 10 movie_title, Rating
FROM IMDBMOVIEDATASETNEW
ORDER BY Rating DESC





--TOP RATED MOVIES by User_Rating
SELECT TOP 10 movie_title, User_Rating
FROM IMDBMOVIEDATASETNEW
ORDER BY User_Rating DESC




--top MOVIES with longest run time
SELECT TOP 10 movie_title, Runtime_in_minutes
FROM IMDBMOVIEDATASETNEW
ORDER BY Runtime_in_minutes DESC


-- NUMBER OF MOVIES PER YEAR 
SELECT trimmed_year, COUNT(*) as Frequency
FROM IMDBMOVIEDATASETNEW
WHERE trimmed_year IS NOT NULL
GROUP BY trimmed_year
ORDER BY Frequency DESC
Frequency DESC;

SELECT *
FROM IMDBMOVIEDATASETNEW
