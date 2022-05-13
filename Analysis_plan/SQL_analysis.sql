-- Whether Dognition personality dimensions are related to the number of tests completed
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
%%sql
SELECT dogs_tests_complete.dimension, COUNT(dogs_tests_complete.dog_guid)
FROM (SELECT DISTINCT c.dog_guid, dimension
      FROM dogs d
      INNER JOIN complete_tests c
      WHERE d.dog_guid = c.dog_guid
      AND (dimension IS NULL OR dimension ='')
      ) AS dogs_tests_complete
GROUP BY dimension;
-- The result returns 13,705 Null value, which means those dogs have not completed all 20 tests.

-- Next step is to investigate the non-NUll empty values, why? 
-- Q5: To determine whether there are any features that are common to all dogs that have non-NULL empty strings in the dimension column.
%%sql
SELECT tested_dogs.dog_guid, breed, weight, dimension, exclude,first_test_time, last_test_time, tests_num
FROM (SELECT DISTINCT dog_guid, MIN(created_at) AS first_test_time , MAX(created_at) AS last_test_time ,COUNT(test_name) AS tests_num
     FROM complete_tests
     GROUP BY dog_guid) AS tested_dogs, dogs d
WHERE tested_dogs.dog_guid = d.dog_guid
     AND dimension = '';
-- almost all of the entries that have non-NULL empty strings in the dimension column also have "exclude" flags of 1, meaning that the entries are meant to be excluded due to factors monitored by the Dognition team.

-- Q7: Exclude DogIDs with (1) non-NULL empty strings in the dimension column, (2) NULL values in the dimension column, and (3) values of "1" in the exclude column.
%%sql
SELECT DISTINCT s.dimension, COUNT(s.dog_guid) AS unique_dogs,AVG(tests_num) AS avg_tests_num
FROM (SELECT DISTINCT d.dog_guid, dimension, COUNT(test_name) AS tests_num
     FROM dogs d, complete_tests c
     WHERE d.dog_guid = c.dog_guid AND dimension IS NOT NULL AND dimension != '' 
      AND (exclude = 0 OR exclude IS NULL)
     GROUP BY d.dog_guid, dimension) AS s
GROUP BY s.dimension;
-- exclude column has 3 values: 0, 1 and Null

-- Q8: Add standard deviation for the number of tests completed by each Dognition personality dimension.
%%sql
SELECT DISTINCT s.dimension, COUNT(s.dog_guid) AS unique_dogs,AVG(tests_num) AS avg_tests_num, STDDEV(tests_num) AS stddev_tests_num
FROM (SELECT DISTINCT d.dog_guid, dimension, COUNT(test_name) AS tests_num
     FROM dogs d, complete_tests c
     WHERE d.dog_guid = c.dog_guid AND dimension IS NOT NULL AND dimension != '' 
      AND (exclude = 0 OR exclude IS NULL)
     GROUP BY d.dog_guid, dimension) AS s
GROUP BY s.dimension;
-- The standard deviations are all around 20-25% of the average values of each personality dimension, and they are not appreciably different across the personality dimensions, so the average values are likely fairly trustworthy. 

-- Whether dog breeds are related to the number of tests completed?
-- Q9: How many distinct values in the breed_group field?
%%sql
SELECT DISTINCT breed_group
FROM dogs;
-- return 9 values, including Null value

-- Q10: To observe if we can exclude NUll value in breed_group ? 
%%sql
SELECT tested_dogs.dog_guid, breed, weight, exclude, first_complete_test, last_complete_test, test_num
FROM (SELECT DISTINCT dog_guid,MIN(created_at) AS first_complete_test, MAX(created_at) AS last_complete_test, COUNT(test_name) AS test_num
     FROM complete_tests
     GROUP BY dog_guid) AS tested_dogs, dogs d
WHERE tested_dogs.dog_guid = d.dog_guid
     AND breed_group IS NULL;
-- No obvious reason to exclude becasue no common in the above table.

-- Q11: Exclude exclude field  = 1, to observe the relation between breed_group and complete_tests.
%%sql
SELECT DISTINCT s.breed_group, COUNT(s.dog_guid) AS unique_dogs,AVG(tests_num) AS avg_tests_num
FROM (SELECT DISTINCT d.dog_guid, breed_group, COUNT(test_name) AS tests_num
     FROM dogs d, complete_tests c
     WHERE d.dog_guid = c.dog_guid 
      AND (exclude = 0 OR exclude IS NULL)
     GROUP BY d.dog_guid, breed_group) AS s
GROUP BY s.breed_group
ORDER BY unique_dogs desc, avg_tests_num desc;
-- There are also non-Null empty value in this table, addtional to Null value 
-- Herding and Sporting breed_groups complete the most tests, while Hound breed groups complete the least tests
-- This suggests that one avenue an analyst might want to explore further is whether it is worth it to target marketing or certain types of Dognition tests to dog owners with dogs in the Herding and Sporting breed_groups

-- Q12: Only query the top 3 dogs
%%sql
SELECT DISTINCT s.breed_group, COUNT(s.dog_guid) AS unique_dogs,AVG(tests_num) AS avg_tests_num
FROM (SELECT DISTINCT d.dog_guid, breed_group, COUNT(test_name) AS tests_num
     FROM dogs d, complete_tests c
     WHERE d.dog_guid = c.dog_guid 
      AND (exclude = 0 OR exclude IS NULL)
      AND breed_group IN ('Sporting','Herding','Toy')
     GROUP BY d.dog_guid, breed_group) AS s
GROUP BY s.breed_group
ORDER BY unique_dogs desc;

-- Q13: Observe all of the distinct values in the breed_type field.
%%sql
SELECT DISTINCT breed_type
FROM dogs;
-- 4 types, no NUll value

-- Q14: Examine the relationship between breed_type and number of tests completed.
%%sql
SELECT DISTINCT s.breed_type, COUNT(s.dog_guid) AS unique_dogs,AVG(tests_num) AS avg_tests_num
FROM (SELECT DISTINCT d.dog_guid, breed_type, COUNT(test_name) AS tests_num
     FROM dogs d, complete_tests c
     WHERE d.dog_guid = c.dog_guid 
      AND (exclude = 0 OR exclude IS NULL)
     GROUP BY d.dog_guid, breed_type) AS s
GROUP BY s.breed_type
ORDER BY unique_dogs desc;

-- whether dog breeds and neutering are related to the number of tests completed?
-- Q15: Continue to run some queries that relabel the breed_types according to "Pure_Breed" and "Not_Pure_Breed".
%%sql
SELECT tested_dogs.dog_guid, breed_type, test_num,
CASE WHEN breed_type = 'Pure Breed' THEN 'Pure_Breed'
ELSE 'Not_Pure_Breed'
END AS status
FROM (SELECT DISTINCT dog_guid, COUNT(test_name) AS test_num
      FROM complete_tests
      GROUP BY dog_guid) AS tested_dogs, dogs d
WHERE tested_dogs.dog_guid = d.dog_guid
ORDER BY test_num desc;

--Q16: Examine the relationship between breed_type and number of tests completed by Pure_Breed dogs and non_Pure_Breed dogs.
%%sql
SELECT CASE WHEN breed_type = 'Pure Breed' THEN 'Pure_Breed'
       ELSE 'Not_Pure_Breed'
       END AS status,
COUNT(s.dog_guid) AS unique_dogs, AVG(tests_num) AS avg_tests_num
FROM (SELECT DISTINCT d.dog_guid, breed_type, COUNT(test_name) AS tests_num
     FROM dogs d, complete_tests c
     WHERE d.dog_guid = c.dog_guid 
      AND (exclude = 0 OR exclude IS NULL)
     GROUP BY d.dog_guid, breed_type) AS s
GROUP BY status
ORDER BY unique_dogs desc;

--Q17: Whether or not a dog was neutered (indicated in the dog_fixed field), and number of tests completed by Pure_Breed dogs and non_Pure_Breed dogs.
%%sql
SELECT dog_fixed,
CASE WHEN breed_type = 'Pure Breed' THEN 'Pure_Breed'
       ELSE 'Not_Pure_Breed'
       END AS status,
COUNT(s.dog_guid) AS unique_dogs, AVG(tests_num) AS avg_tests_num
FROM (SELECT DISTINCT d.dog_guid,breed_type, dog_fixed, COUNT(test_name) AS tests_num
     FROM dogs d, complete_tests c
     WHERE d.dog_guid = c.dog_guid 
      AND (exclude = 0 OR exclude IS NULL)
     GROUP BY d.dog_guid, breed_type) AS s
GROUP BY dog_fixed,status
ORDER BY unique_dogs desc;
-- Neutered dogs, on average, seem to finish 1-2 more tests than non-neutered dogs.

-- Q18: Use standard deviation to exam the ourliers of the breed_type to total completed tests.
%%sql 
SELECT breed_type, AVG(TIMESTAMPDIFF(minute, start_time, end_time)) AS avg_duration, STDDEV(TIMESTAMPDIFF(minute, start_time, end_time)) AS stddev_duration
FROM exam_answers e
INNER JOIN dogs d
ON d.dog_guid = e.dog_guid
WHERE TIMESTAMPDIFF(minute, start_time, end_time) > 0
GROUP BY breed_type
ORDER BY avg_duration desc;
-- The standard deviations have larger magnitudes than the average duration values. 
-- This suggests there are outliers in the data that are significantly impacting the reported average values, so the average values are not likely trustworthy. 

-- Q19: Observe if duration of the test effects the number of completed tests:
%%sql
SELECT Distinct test_name
FROM exam_answers;
--- return 68 rows

%%sql
SELECT Distinct test_name
FROM complete_test; 
-- return 40 rows 

%%sql
%%sql
SELECT DISTINCT c.test_name, 
AVG(TIMESTAMPDIFF(minute,start_time,end_time)) AS duration, 
COUNT(created_at) AS test_num, 
COUNT(c.dog_guid) AS tested_dogs
FROM exam_answers e
INNER JOIN complete_tests c
WHERE e.dog_guid = c.dog_guid
GROUP BY c.test_name
ORDER BY duration desc, tested_dogs desc;
-- 