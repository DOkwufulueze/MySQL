DROP DATABASE IF EXISTS library;

CREATE DATABASE IF NOT EXISTS library;

USE library;

CREATE TABLE IF NOT EXISTS branches (
  bcode CHAR(5),
  librarian CHAR(100),
  address CHAR(100),
  PRIMARY KEY (bcode)
);

CREATE TABLE IF NOT EXISTS titles (
  title CHAR(100),
  author CHAR(100),
  publisher CHAR(100),
  PRIMARY KEY (title)
);

CREATE TABLE IF NOT EXISTS holdings (
  branch CHAR(5),
  title CHAR(100),
  `#copies` CHAR(10),
  FOREIGN KEY (branch) REFERENCES branches(bcode)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (title) REFERENCES titles(title)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

# Dumping Values into tables

-- branches
INSERT INTO branches
VALUES 
  ('B1', 'John Smith', '2 Anglesea Rd'),
  ('B2', 'Mary Jones', '34 Pearse St'),
  ('B3', 'Francis Owens', 'Grange X');

-- titles
INSERT INTO titles
VALUES 
  ('Susannah', 'Ann Brown', 'Macmillan'),
  ('How to Fish', 'Amy Fly', 'Stop Press'),
  ('A History of Dublin', 'David Little', 'Wiley'),
  ('Computers', 'Blaise Pascal', 'Applewoods'),
  ('The Wife', 'Ann Brown', 'Macmillan');

-- holdings
INSERT INTO holdings
VALUES 
  ('B1', 'Susannah', '3'),
  ('B1', 'How to Fish', '2'),
  ('B1', 'A History of Dublin', '1'),
  ('B2', 'How to Fish', '4'),
  ('B2', 'Computers', '2'),
  ('B2', 'The Wife', '3'),
  ('B3', 'A History of Dublin', '1'),
  ('B3', 'Computers', '4'),
  ('B3', 'Susannah', '3'),
  ('B3', 'The Wife', '1');


-- the names of all library books published by Macmillan.
SELECT title AS 'Book Title', publisher AS 'Book Publisher' FROM titles
WHERE publisher = 'Macmillan'
AND title
IN (
  SELECT title FROM holdings
);
/*
+------------+----------------+
| Book Title | Book Publisher |
+------------+----------------+
| Susannah   | Macmillan      |
| The Wife   | Macmillan      |
+------------+----------------+
2 rows in set (0.00 sec)
*/

-- branches that hold any books by Ann Brown (using a nested subquery).
SELECT DISTINCT address AS 'Branch Address' FROM branches
WHERE bcode
IN(
  SELECT branch FROM holdings WHERE title
  IN(
    SELECT title FROM titles WHERE author = 'Ann Brown'
  )
);
/*
+----------------+
| Branch Address |
+----------------+
| 2 Anglesea Rd  |
| 34 Pearse St   |
| Grange X       |
+----------------+
3 rows in set (0.00 sec)
*/

-- branches that hold any books by Ann Brown (without using a nested subquery).
SELECT DISTINCT address AS 'Branch Address' FROM branches
INNER JOIN holdings ON branches.bcode = holdings.branch
INNER JOIN titles ON holdings.title = titles.title
WHERE titles.author = 'Ann Brown';
/*
+----------------+
| Branch Address |
+----------------+
| 2 Anglesea Rd  |
| Grange X       |
| 34 Pearse St   |
+----------------+
3 rows in set (0.00 sec)
*/

-- the total number of books held at each branch.
SELECT branches.address AS 'Branch Address', SUM(`#copies`) AS 'Total Number of Books' FROM holdings
INNER JOIN branches ON holdings.branch = branches.bcode
GROUP BY holdings.branch;
/*
+----------------+-----------------------+
| Branch Address | Total Number of Books |
+----------------+-----------------------+
| 2 Anglesea Rd  |                     6 |
| 34 Pearse St   |                     9 |
| Grange X       |                     9 |
+----------------+-----------------------+
3 rows in set (0.00 sec)
*/

