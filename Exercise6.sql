DROP DATABASE IF EXISTS campaign;

CREATE DATABASE IF NOT EXISTS campaign;

USE campaign;

CREATE TABLE IF NOT EXISTS email_subscribers(
  id INT AUTO_INCREMENT,
  email VARCHAR(100),
  phone_number CHAR(10),
  city VARCHAR(100),
  PRIMARY KEY(id)
);

LOAD DATA LOCAL INFILE 'email_subscribers.txt'
INTO TABLE email_subscribers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(email, phone_number, city);

-- What cities did the people respond from?
SELECT DISTINCT city FROM email_subscribers;
/*
+-----------+
| city      |
+-----------+
|  Lucknow  |
|  Chennai  |
|  Kolkatta |
|  Delhi    |
|  Mumbai   |
+-----------+
5 rows in set (0.00 sec)
*/

-- How many people responded from each city
SELECT city AS City, COUNT(city) AS 'Number of Responders'
FROM email_subscribers
GROUP BY city;
/*
+-----------+----------------------+
| City      | Number of Responders |
+-----------+----------------------+
|  Chennai  |                   42 |
|  Delhi    |                   40 |
|  Kolkatta |                   38 |
|  Lucknow  |                   39 |
|  Mumbai   |                   41 |
+-----------+----------------------+
5 rows in set (0.00 sec)
*/

-- Which city were the maximum respondents from?
SELECT city AS 'City with Maximum Responders', MAX(Responders) AS 'Number of Responders'
FROM(
  SELECT city, COUNT(city) AS Responders
  FROM email_subscribers
  GROUP BY city
) AS responders_table;
/*
+------------------------------+----------------------+
| City with Maximum Responders | Number of Responders |
+------------------------------+----------------------+
|  Chennai                     |                   42 |
+------------------------------+----------------------+
1 row in set (0.00 sec)
*/

-- What email domains did people respond from ?
SELECT RIGHT(email, LENGTH(email) - INSTR(email, '@')) AS Domain, COUNT(email) AS 'Number of Responders'
FROM email_subscribers
GROUP BY Domain;
/*
+--------------+----------------------+
| Domain       | Number of Responders |
+--------------+----------------------+
| gmail.com    |                   49 |
| hotmail.com  |                   49 |
| me.com       |                   51 |
| yahoo.com    |                   51 |
+--------------+----------------------+
4 rows in set (0.00 sec)
*/

-- Which is the most popular email domain among the respondents ?
SELECT domain AS 'Popular Domain', (domain_count) AS 'Number of Responders'
FROM(
  SELECT RIGHT(email, LENGTH(email) - INSTR(email, '@')) AS domain, COUNT(email) AS domain_count
  FROM email_subscribers
  GROUP BY domain
) AS responders_table
WHERE domain_count IN (
    SELECT MAX(domain_count) FROM (
    SELECT RIGHT(email, LENGTH(email) - INSTR(email, '@')) AS domain, COUNT(email) AS domain_count
    FROM email_subscribers
    GROUP BY domain
  ) AS second_responders_table
);
/*
+----------------+----------------------+
| Popular Domain | Number of Responders |
+----------------+----------------------+
| me.com         |                   51 |
| yahoo.com      |                   51 |
+----------------+----------------------+
2 rows in set (0.00 sec)
*/


