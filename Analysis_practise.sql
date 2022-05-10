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
-- Exercise 7: 
-- Question 1: How many unique Golden Retrievers who live in North Carolina are there in the Dognition database

-- Question 2: 
