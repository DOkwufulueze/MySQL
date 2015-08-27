DROP DATABASE IF EXISTS sandwich;

CREATE DATABASE IF NOT EXISTS sandwich;

USE sandwich;

CREATE TABLE IF NOT EXISTS tastes (
  name CHAR(20),
  filling CHAR(20),
  CONSTRAINT primary_keys PRIMARY KEY (name, filling)
);

CREATE TABLE IF NOT EXISTS locations (
  lname CHAR(20),
  phone CHAR(8),
  address CHAR(20),
  PRIMARY KEY (lname)
);

CREATE TABLE IF NOT EXISTS sandwiches (
  `location` CHAR(20),
  bread CHAR(20),
  filling CHAR(20),
  price CHAR(5),
  CONSTRAINT primary_keys PRIMARY KEY (`location`, bread, filling),
  FOREIGN KEY (`location`) REFERENCES locations(lname)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

# Dumping Values into tables

-- tastes
INSERT INTO tastes
VALUES 
  ('Brown', 'Turkey'),
  ('Brown', 'Beef'),
  ('Brown', 'Ham'),
  ('Jones', 'Cheese'),
  ('Green', 'Beef'),
  ('Green', 'Turkey'),
  ('Green', 'Cheese');

-- locations
INSERT INTO locations
VALUES 
  ('Lincoln', '683 4523', 'Lincoln Place'),
  ('O\'Neill\'s', '674 2134', 'Pearse St'),
  ('Old Nag', '767 8132', 'Dame St'),
  ('Buttery', '702 3421', 'College St');

-- sandwiches
INSERT INTO sandwiches
VALUES 
  ('Lincoln', 'Rye', 'Ham', '1.25'),
  ('O\'Neill\'s', 'White', 'Cheese', '1.20'),
  ('O\'Neill\'s', 'Whole', 'Ham', '1.25'),
  ('Old Nag', 'Rye', 'Beef', '1.35'),
  ('Buttery', 'White', 'Cheese', '1.00'),
  ('O\'Neill\'s', 'White', 'Turkey', '1.35'),
  ('Buttery', 'White', 'Ham', '1.10'),
  ('Lincoln', 'Rye', 'Beef', '1.35'),
  ('Lincoln', 'White', 'Ham', '1.30'),
  ('Old Nag', 'Rye', 'Ham', '1.40');


-- Places where Jones can eat (using a nested query)
SELECT address AS 'Places Using Nested Query'
FROM sandwiches
INNER JOIN locations
ON (sandwiches.`location` = locations.lname)
WHERE sandwiches.filling IN(
  SELECT filling FROM tastes WHERE name = 'Jones'
);
/*
+---------------------------+
| Places Using Nested Query |
+---------------------------+
| College St                |
| Pearse St                 |
+---------------------------+
2 rows in set (0.12 sec)
*/

-- Places where Jones can eat (without using a nested query)
SELECT address AS 'Places WITHOUT Using Nested Query'
FROM sandwiches 
INNER JOIN tastes 
ON (sandwiches.filling = tastes.filling)
INNER JOIN locations
ON (sandwiches.`location` = locations.lname)
WHERE tastes.name = 'Jones';
/*
+-----------------------------------+
| Places WITHOUT Using Nested Query |
+-----------------------------------+
| College St                        |
| Pearse St                         |
+-----------------------------------+
2 rows in set (0.00 sec)
*/

-- for each location the number of people who can eat there
SELECT address AS Places, COUNT(DISTINCT name) AS 'Number of People' 
FROM sandwiches 
INNER JOIN tastes 
ON (sandwiches.filling = tastes.filling)
INNER JOIN locations
ON (sandwiches.`location` = locations.lname)
GROUP BY address;
/*
+---------------+------------------+
| Places        | Number of People |
+---------------+------------------+
| College St    |                3 |
| Dame St       |                2 |
| Lincoln Place |                2 |
| Pearse St     |                3 |
+---------------+------------------+
4 rows in set (0.01 sec)
*/

