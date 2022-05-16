-- Exercise 1
-- Question 1: How many columns does the "dogs" table have?
%sql 
SHOW COLUMNS from dogs;

-- Question 2: How many columns are in the "reviews" table?
%sql 
DESCRIBE reviews;

-- Question 3: Retrieve 10 rows of data from the activity_type, created_at, and updated_at fields of the site_activities table, starting at row 50? 
%%sql 
SELECT activity_type, created_at, updated_at 
FROM site_activities
LIMIT 49,10;

-- Exercise 2
-- Question 4: Retrieve the Dog ID, subcategory_name, and test_name fields, in that order, of the first 10 reviews entered in the Reviews table to be submitted in 2014?
%%sql 
SELECT dog_guid, subcategory_name, test_name
FROM reviews
WHERE created_at BETWEEN '2014-01-01' AND '2014-12-31'
LIMIT 10;

-- Question 5: Select all of the User IDs of customers who have female dogs whose breed includes the word "terrier" somewhere in its name?
%%sql
SELECT user_guid
FROM dogs
WHERE gender ='female' AND breed like '%terrier%';

-- Question 6: Select the Dog ID, test name, and subcategory associated with each completed test for the first 100 tests entered in October, 2014?
%%sql 
SELECT dog_guid,test_name, subcategory_name
FROM complete_tests
WHERE created_at between' 2014-10-01' AND ' 2014-10-31'
LIMIT 100;

-- Exercise 3
-- Question 7: How would you create a text file with a list of all the non-United States countries of Dognition customers with no country listed more than once?
non_US_list = %sql SELECT DISTINCT country FROM users WHERE country NOT LIKE '%US%';

-- Question 8: How would create a text file with a list of all the customers with yearly memberships who live in the state of North Carolina (USA) and joined Dognition after March 1, 2014, sorted so that the most recent member is at the top of the list?
%%sql 
SELECT membership_id, state
FROM users WHERE state LIKE '%NC%' AND created_at > '2014-03-01' 
ORDER BY created_at desc;
NC_list = %sql SELECT membership_id FROM users WHERE state LIKE '%NC%' AND created_at > '2014-03-01' ORDER BY created_at desc;

-- Exercise 4
-- Question 9: What is the average amount of time it took customers to complete the "Treat Warm-Up" test?
%%sql 
SELECT AVG(TIMESTAMPDIFF(MINUTE,start_time,end_time))
FROM exam_answers
WHERE test_name = 'Treat Warm-Up';

-- Question 10: How many of these negative Duration entries are there?
%%sql
SELECT COUNT(TIMESTAMPDIFF(MINUTE,start_time,end_time)) AS neg_duration
FROM exam_answers
WHERE TIMESTAMPDIFF(MINUTE,start_time,end_time)<0;

-- Exercise 5
-- Question 11: Output a table that calculates the number of distinct female and male dogs in each breed group of the Dogs table, sorted by the total number of dogs in descending order 
%%sql 
SELECT gender, breed_group, count(dog_guid) AS  count_num
FROM dogs
WHERE gender IS NOT NULL
GROUP BY gender,breed_group
ORDER BY count_num desc;

-- Question 12: Revise the query your wrote in Question 1 so that it (1) excludes the NULL and empty string entries in the breed_group field, and (2) excludes any groups that don't have at least 1,000 distinct Dog_Guids in them. 
%%sql 
SELECT gender, breed_group, count(distinct dog_guid) AS  count_num
FROM dogs
WHERE gender IS NOT NULL AND breed_group!="" AND breed_group IS NOT NULL
GROUP BY 1,2
HAVING count_num >= 1000
ORDER BY 3 desc;

-- Question 13: Write a query that outputs the average number of tests completed and average mean inter-test-interval for every breed type, sorted by the average number of completed tests in descending order ?
%%sql
SELECT breed, AVG(total_tests_completed) AS test_num, round(AVG(mean_iti_days),0) AS inter_test_inverval_D
FROM dogs
GROUP BY breed
ORDER BY test_num desc;

-- Question 14: Write a query that outputs the average amount of time it took customers to complete each type of test where any individual reaction times over 6000 hours are excluded and only average reaction times that are greater than 0 seconds are included ?
%%sql
SELECT test_name,AVG(TIMESTAMPDIFF(HOUR,start_time,end_time)) AS duration
FROM exam_answers 
GROUP BY test_name
HAVING duration BETWEEN 0 AND 6000
ORDER BY duration desc;

-- Question 15: Write a query that outputs the total number of unique User_Guids in each combination of State and ZIP code in the United States that have at least 5 users, sorted first by state name in ascending alphabetical order, and second by total number of unique User_Guids in descending order? 
%%sql
SELECT DISTINCT State, zip, COUNT(DISTINCT user_guid) AS total_num
FROM users
WHERE country = 'US'
GROUP BY state,zip
HAVING total_num > 5
ORDER BY state asc, total_num desc;

-- Exercise 6: refer to notebook 
-- Exercise 7
-- Question 16: How would you extract the user_guid, membership_type, and dog_guid of all the golden retrievers who completed at least 1 Dognition test?
%%sql
SELECT DISTINCT u.user_guid, membership_type, d.dog_guid
FROM users u, dogs d 
WHERE u.user_guid = d.user_guid
AND breed = 'Golden Retriever' 
AND total_tests_completed >= 1 

-- Question 17: How many unique Golden Retrievers who live in North Carolina are there in the Dognition database?
%%sql 
SELECT COUNT(DISTINCT dog_guid) AS gr_num
FROM users u 
JOIN dogs d
ON u.user_guid = d.user_guid
WHERE breed = 'Golden Retriever'
AND state = 'NC';

-- Question 18: How many unique customers within each membership type provided reviews?
%%sql
SELECT membership_type, COUNT(DISTINCT u.user_guid) AS user_num
FROM users u
JOIN reviews r
ON u.user_guid = r.user_guid
WHERE rating IS NOT NULL
GROUP BY membership_type
ORDER BY user_num desc;

-- Question 19: For which 3 dog breeds do we have the greatest amount of site_activity data?
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
-- Question 20:  How would you retrieve a list of all the unique dogs in the dogs table, and retrieve a count of how many tests each one completed?
%%sql
SELECT DISTINCT d.dog_guid, d.user_guid, count(test_name) AS completed_test_num
FROM dogs d
LEFT JOIN complete_tests c
ON d.dog_guid = c.dog_guid
GROUP BY d.user_guid, d.dog_guid
ORDER BY completed_test_num desc;

-- Question 21: how many distinct dog_guids there are in the completed_tests table?
%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM complete_tests;

-- Question 22: How would you write a query that used a left join to return the number of distinct user_guids that were in the users table, but not the dogs table?
%%sql
SELECT COUNT(DISTINCT u.user_guid)
FROM users u
LEFT JOIN dogs d
ON u.user_guid = d.user_guid
WHERE d.user_guid IS NULL;

-- Question 23: Create a list of all the unique dog_guids that are contained in the site_activities table, but not the dogs table, and how many times each one is entered?
%%sql
SELECT DISTINCT s.dog_guid,count(*) AS entry_num
FROM site_activities s
LEFT JOIN dogs d
ON s.dog_guid = d.dog_guid 
WHERE d.dog_guid IS NULL 
AND s.dog_guid IS NOT NULL 
GROUP BY s.dog_guid
ORDER BY entry_num desc; 

-- Exercise 9
-- Question 24: extract all the data from exam_answers that had test durations that were greater than the average duration for the "Yawn Warm-Up" game?
%%sql
SELECT * 
FROM exam_answers
WHERE TIMESTAMPDIFF(minute,start_time, end_time) >
(SELECT AVG(TIMESTAMPDIFF(minute,start_time, end_time)) AS avg_duration
FROM exam_answers 
WHERE TIMESTAMPDIFF(minute,start_time,end_time)>0
AND test_name='Yawn Warm-Up');

-- Question 25: determine the number of unique users in the users table who were NOT in the dogs table?
%%sql
SELECT COUNT(DISTINCT user_guid)
FROM users u
WHERE NOT EXISTS (SELECT user_guid 
                  FROM dogs d
                 WHERE u.user_guid = d.user_guid );

-- Question 26: determine the dog_guid, breed group, state of the owner, and zip of the owner for each distinct dog in the Working, Sporting, and Herding breed groups?
%%sql
SELECT DISTINCT d.dog_guid, breed_group, state, zip
FROM dogs d, users u
WHERE d.user_guid = u.user_guid
AND breed_group IN ('Working', 'Sporting', 'Herding');

-- Question 27: examine all the users in the dogs table that are not in the users table?
%%sql
SELECT user_guid
FROM dogs d
WHERE NOT EXISTS (SELECT DISTINCT user_guid 
                  FROM users u
                  WHERE d.user_guid = u.user_guid );

-- Question 28: Retrieve a full list of all the DogIDs a user in the users table owns, with its accompagnying breed information whenever possible?
%%sql
SELECT s1.user_guid, dog_guid, breed, breed_type, breed_group 
FROM (SELECT DISTINCT user_guid 
      FROM users
      ) AS s1
LEFT JOIN (SELECT DISTINCT dog_guid, user_guid, breed, breed_type, breed_group
          FROM dogs) AS s2
ON s1.user_guid = s2.user_guid 
GROUP BY s1.user_guid;

-- Exercise 10
-- Question 29: determine the number of unique user_guids who reside in the United States and outside of the US?
%%sql 
%%sql
SELECT IF(subquery.country='US','In US', 
          IF(subquery.country='N/A','Not Applicable','Outside US')) AS US_user, 
      COUNT(subquery.user_guid)   
FROM (SELECT DISTINCT user_guid, country 
      FROM users
      WHERE country IS NOT NULL) AS subquery
GROUP BY US_user;

-- Question 30: Write a query using a CASE statement that outputs 3 columns: dog_guid, exclude, and a third column that reads "exclude" every time there is a 1 in the "exclude" column of dogs and "keep" every time there is any other value in the exclude column.
%%sql 
SELECT dog_guid, exclude,
CASE exclude WHEN 1 THEN 'exclude'
             ELSE 'keep'
             END AS status
FROM dogs
LIMIT 100;

%%sql 
SELECT dog_guid, exclude, IF(exclude =1,'exclude','keep') AS status
FROM dogs
LIMIT 100;

-- Question 31: Write a query that uses a CASE expression to output 3 columns: dog_guid, weight, and a third column that reads...
-- "very small" when a dog's weight is 1-10 pounds
-- "small" when a dog's weight is greater than 10 pounds to 30 pounds
-- "medium" when a dog's weight is greater than 30 pounds to 50 pounds
-- "large" when a dog's weight is greater than 50 pounds to 85 pounds
-- "very large" when a dog's weight is greater than 85 pounds
%%sql
SELECT dog_guid, weight,
CASE WHEN weight BETWEEN 1 AND 10 THEN 'very small'
     WHEN weight > 10 AND weight <= 30 THEN 'small'
     WHEN weight > 30 AND weight <= 50 THEN 'medium'
     WHEN weight > 50 AND weight <=85 THEN 'large'
     ELSE 'very large'
     END AS status 
FROM dogs
LIMIT 100; 

-- Question 32: For each dog_guid, output its dog_guid, breed_type, number of completed tests, and use an IF statement to include an extra column that reads "Pure_Breed" whenever breed_type equals 'Pure Breed" and "Not_Pure_Breed" whenever breed_type equals anything else. LIMIT your output to 50 rows for troubleshooting.
%%sql
SELECT s.dog_guid, s.breed_type, s.test_num, IF(breed_type='Pure Breed','Pure_Breed','Not_Pure_Breed') AS status
FROM (SELECT DISTINCT dog_guid, COUNT(total_tests_completed) AS test_num, breed_type
      FROM dogs
      GROUP BY dog_guid, breed_type) AS s
ORDER BY test_num desc
LIMIT 50;

-- Question 33: Write a query that uses a CASE statement to report the number of unique user_guids associated with customers who live in the United States and who are in the following groups of states:
-- Group 1: New York or New Jersey
-- Group 2: North Carolina or South Carolina 
-- Group 3: California
-- Group 4: All other states with non-null values
%%sql 
SELECT CASE WHEN state = 'NY' OR state = 'NJ' THEN 'Group 1'
            WHEN state = 'NC' OR state = 'SC' THEN 'Group 2'
            WHEN state = 'CA' THEN 'Group 3'
            ELSE 'Group 4'
            END AS group_type,
COUNT(DISTINCT user_guid) AS user_pop
FROM users
WHERE state IS NOT NULL
GROUP BY group_type;

-- Question 34: Write a query that allows you to determine how many unique dog_guids are associated with dogs who are DNA tested and have either stargazer or socialite personality dimensions.
%%sql
SELECT COUNT(DISTINCT dog_guid)
FROM dogs
WHERE dna_tested=1
AND (dimension ='stargazer' OR dimension ='socialite'); 
