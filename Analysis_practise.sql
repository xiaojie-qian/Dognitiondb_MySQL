-- 

-- Exercise 5
-- Question 1: Output a table that calculates the number of distinct female and male dogs in each breed group of the Dogs table, sorted by the total number of dogs in descending order 
%%sql 
SELECT gender, breed_group, count(dog_guid) AS  count_num
FROM dogs
WHERE gender IS NOT NULL
GROUP BY gender,breed_group
ORDER BY count_num desc;

-- Question 2: evise the query your wrote in Question 1 so that it (1) excludes the NULL and empty string entries in the breed_group field, and (2) excludes any groups that don't have at least 1,000 distinct Dog_Guids in them. 
%%sql 
SELECT gender, breed_group, count(distinct dog_guid) AS  count_num
FROM dogs
WHERE gender IS NOT NULL AND breed_group!="" AND breed_group IS NOT NULL
GROUP BY 1,2
HAVING count_num >= 1000
ORDER BY 3 desc;

-- Question 3:  Write a query that outputs the average number of tests completed and average mean inter-test-interval for every breed type, sorted by the average number of completed tests in descending order (popular hybrid should be the first row in your output)
%%sql
SELECT breed, AVG(total_tests_completed) AS test_num, round(AVG(mean_iti_days),0) AS inter_test_inverval_D
FROM dogs
GROUP BY breed
ORDER BY test_num desc;

-- Question 4: Write a query that outputs the average amount of time it took customers to complete each type of test where any individual reaction times over 6000 hours are excluded and only average reaction times that are greater than 0 seconds are included 
%%sql
SELECT test_name,AVG(TIMESTAMPDIFF(HOUR,start_time,end_time)) AS duration
FROM exam_answers 
GROUP BY test_name
HAVING duration BETWEEN 0 AND 6000
ORDER BY duration desc;

-- Question 5: Write a query that outputs the total number of unique User_Guids in each combination of State and ZIP code in the United States that have at least 5 users, sorted first by state name in ascending alphabetical order, and second by total number of unique User_Guids in descending order 
%%sql
SELECT DISTINCT State, zip, COUNT(DISTINCT user_guid) AS total_num
FROM users
WHERE country = 'US'
GROUP BY state,zip
HAVING total_num > 5
ORDER BY state asc, total_num desc;

-- Exercise 6: refer to notebook 
-- Exercise 7
-- Question 1: How would you extract the user_guid, membership_type, and dog_guid of all the golden retrievers who completed at least 1 Dognition test 
%%sql
SELECT DISTINCT u.user_guid, membership_type, d.dog_guid
FROM users u, dogs d 
WHERE u.user_guid = d.user_guid
AND breed = 'Golden Retriever' 
AND total_tests_completed >= 1 

-- Question 2: How many unique Golden Retrievers who live in North Carolina are there in the Dognition database
%%sql 
SELECT COUNT(DISTINCT dog_guid) AS gr_num
FROM users u 
JOIN dogs d
ON u.user_guid = d.user_guid
WHERE breed = 'Golden Retriever'
AND state = 'NC';

-- Question 3: How many unique customers within each membership type provided reviews
%%sql
SELECT membership_type, COUNT(DISTINCT u.user_guid) AS user_num
FROM users u
JOIN reviews r
ON u.user_guid = r.user_guid
WHERE rating IS NOT NULL
GROUP BY membership_type
ORDER BY user_num desc;

-- Question 4: For which 3 dog breeds do we have the greatest amount of site_activity data
%%sql
SELECT breed, COUNT(activity_type) AS activities
FROM dogs d, site_activities s
WHERE d.user_guid = s.user_guid 
AND d.dog_guid = s.dog_guid
AND script_detail_id IS NOT NULL 
GROUP BY breed
ORDER BY activities desc 
Limit 5;

-- Exercise 8
-- Question 1:  How would you retrieve a list of all the unique dogs in the dogs table, and retrieve a count of how many tests each one completed?
%%sql
SELECT DISTINCT d.dog_guid, d.user_guid, count(test_name) AS completed_test_num
FROM dogs d
LEFT JOIN complete_tests c
ON d.dog_guid = c.dog_guid
GROUP BY d.user_guid, d.dog_guid
ORDER BY completed_test_num desc;

-- Question 2: how many distinct dog_guids there are in the completed_tests table
%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM complete_tests;

-- Question 3: How would you write a query that used a left join to return the number of distinct user_guids that were in the users table, but not the dogs table
%%sql
SELECT COUNT(DISTINCT u.user_guid)
FROM users u
LEFT JOIN dogs d
ON u.user_guid = d.user_guid
WHERE d.user_guid IS NULL;

-- Question 4: Create a list of all the unique dog_guids that are contained in the site_activities table, but not the dogs table, and how many times each one is entered
%%sql
SELECT DISTINCT s.dog_guid,count(*) AS entry_num
FROM site_activities s
LEFT JOIN dogs d
ON s.dog_guid = d.dog_guid 
WHERE d.dog_guid IS NULL 
AND s.dog_guid IS NOT NULL 
GROUP BY s.dog_guid
ORDER BY entry_num desc; 