-- Q1: To get a feeling for what kind of values exist in the Dognition personality dimension column.
%%sql 
SELECT DISTINCT dimension 
FROM dogs; 
-- Result has one row of NULL value !! 

-- Q2: Query the Dognition personality dimension and total number of tests completed by each unique DogID
%%sql
SELECT dog_guid
FROM complete_tests
WHERE dog_guid IS NULL
-- This return 167 NUll rows from table, while no NUll value in test_name column 

%%sql
SELECT dimension, COUNT(test_name) AS test_num
FROM dogs d, complete_tests c
WHERE dimension IS NOT NULL
AND d.dog_guid = c.dog_guid
GROUP BY dimension;

-- Q3: Identity the average number of tests completed by unique dogs in each Dognition personality dimension.
%%sql
SELECT DISTINCT s.dimension, COUNT(s.dog_guid) AS unique_dogs,AVG(tests_num) AS avg_tests_num
FROM (SELECT DISTINCT d.dog_guid, dimension, COUNT(test_name) AS tests_num
     FROM dogs d, complete_tests c
     WHERE d.dog_guid = c.dog_guid
     GROUP BY d.dog_guid, dimension) AS s
GROUP BY s.dimension;

-- Q4: How many unique DogIDs are summarized in the Dognition dimensions labeled "None" or ""?

