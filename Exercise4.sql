DROP DATABASE IF EXISTS article_db;

CREATE DATABASE IF NOT EXISTS article_db;

USE article_db;

CREATE TABLE IF NOT EXISTS roles (
  id INT AUTO_INCREMENT,
  name VARCHAR(10),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT,
  role_id INT,
  username VARCHAR(200),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT,
  name VARCHAR(100),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS articles (
  id INT AUTO_INCREMENT,
  user_id INT,
  category_id INT,
  name VARCHAR(200),
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS comments (
  id INT AUTO_INCREMENT,
  user_id INT,
  article_id INT,
  `text` TEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  FOREIGN KEY (article_id) REFERENCES articles(id)
    ON DELETE CASCADE
);

-- Dumping data into tables

-- roles
INSERT INTO roles(name)
VALUES
  ('admin'),
  ('normal');

-- users
INSERT INTO users(role_id, username)
VALUES
  ('1', 'User1'),
  ('2', 'User2'),
  ('2', 'User3'),
  ('2', 'User4'),
  ('1', 'User5'),
  ('2', 'User6');

-- categories
INSERT INTO categories(name)
VALUES
  ('Sciences'),
  ('Arts'),
  ('Fiction'),
  ('Sports');

-- articles
INSERT INTO articles(user_id, category_id, name)
VALUES
  ('1', '1', 'Introductory Sciences'),
  ('2', '3', 'Davinci Code'),
  ('2', '3', 'Sunset Beach'),
  ('4', '1', 'Effect of Greenhouse Gases on Embryo Development'),
  ('3', '2', 'Man and Art'),
  ('5', '4', 'Sports in Africa'),
  ('5', '2', 'European Arts Revisited'),
  ('3', '2', 'The Evolution of African Arts'),
  ('3', '2', 'The use of Natural tools in Arts'),
  ('4', '1', 'Man and Science'),
  ('5', '2', 'The Origin of Arts'),
  ('6', '3', 'Tabitha, the Merry Old Lady'),
  ('6', '3', 'Chike and the Chickens'),
  ('1', '1', 'Innovations in Computing'),
  ('1', '1', 'The Early Hominids'),
  ('5', '4', 'The Olympics: A History'),
  ('6', '3', 'All Help The Priest');

-- comments
INSERT INTO comments(user_id, article_id, `text`)
VALUES
  ('3', '17', 'Wow! really interesting work of fiction.'),
  ('3', '2', 'Davinci Code: A truly engaging work.'),
  ('1', '2', 'Almost real!!!'),
  ('1', '3', 'Great work!!!'),
  ('1', '3', 'On second thought, WONDERFUL WORK!!!'),
  ('4', '5', 'A brilliant exposure to the world of arts.'),
  ('4', '3', 'Excellent!!!'),
  ('6', '2', 'It keeps you glued till the end of the book.'),
  ('2', '8', 'A justice to the cause of History.'),
  ('5', '4', 'I hope people learn from this article and get more careful'),
  ('2', '14', 'It\'s great to see that computing techniques will only improve.'),
  ('6', '8', 'Discusses in clear terms the history of arts.'),
  ('1', '8', 'A wonderful history article.'),
  ('5', '9', 'Nature is indeed the best example.'),
  ('4', '9', 'It\'s great to see how positively useful nature can be.'),
  ('2', '12', 'An exciting and bright story.');



-- select all articles whose author's name is user3 (Do this exercise using variable)
SET @user = 'user3';

SELECT name AS 'Articles whose author is user3' 
FROM articles
INNER JOIN users
ON(articles.user_id = users.id)
WHERE users.username = @user;
/*
+----------------------------------+
| Articles whose author is user3   |
+----------------------------------+
| Man and Art                      |
| The Evolution of African Arts    |
| The use of Natural tools in Arts |
+----------------------------------+
3 rows in set (0.09 sec)
*/

-- select articles and comments for the articles selected above
SELECT name AS Articles, `text` AS 'Comments from readers'
FROM comments
INNER JOIN articles
ON(articles.id = comments.article_id)
WHERE comments.article_id IN(
  SELECT articles.id
  FROM articles
  WHERE articles.user_id IN(
    SELECT id FROM users WHERE username = 'user3'
  )
);
/*
+----------------------------------+--------------------------------------------------------+
| Articles                         | Comments from readers                                  |
+----------------------------------+--------------------------------------------------------+
| Man and Art                      | A brilliant exposure to the world of arts.             |
| The Evolution of African Arts    | Discusses in clear terms the history of arts.          |
| The Evolution of African Arts    | A wonderful history article.                           |
| The use of Natural tools in Arts | Nature is indeed the best example.                     |
| The use of Natural tools in Arts | It's great to see how positively useful nature can be. |
+----------------------------------+--------------------------------------------------------+
5 rows in set (0.02 sec)
*/

-- select articles that don't have any comments
SELECT name AS 'Articles With No Comments'
FROM articles
WHERE articles.id NOT IN(
  SELECT article_id FROM comments
);
/*
+---------------------------+
| Articles With No Comments |
+---------------------------+
| Introductory Sciences     |
| Sports in Africa          |
| European Arts Revisited   |
| Man and Science           |
| The Origin of Arts        |
| Chike and the Chickens    |
| The Early Hominids        |
| The Olympics: A History   |
+---------------------------+
8 rows in set (0.03 sec)
*/

-- select articles that have maximum number of comments
SELECT name, COUNT(article_id) AS number_of_comments FROM articles
INNER JOIN comments
ON(articles.id = comments.article_id)
GROUP BY article_id
HAVING number_of_comments
IN(
  SELECT MAX(number_of_comments) AS 'Number Of Comments'
  FROM (
    SELECT name, COUNT(article_id) AS number_of_comments
    FROM articles
    INNER JOIN comments
    ON(articles.id = comments.article_id)
    GROUP BY article_id
  ) AS count_table
);
/*
+-------------------------------+--------------------+
| name                          | number_of_comments |
+-------------------------------+--------------------+
| Davinci Code                  |                  3 |
| Sunset Beach                  |                  3 |
| The Evolution of African Arts |                  3 |
+-------------------------------+--------------------+
3 rows in set (0.02 sec)
*/

-- select article which does not have more than one comment by the same user
SELECT DISTINCT name AS 'Articles with not more than one comment by the same user'
FROM comments
LEFT JOIN articles
ON(articles.id = comments.article_id)
GROUP BY comments.article_id, comments.user_id
HAVING COUNT(comments.user_id) <= 1;
/*
+----------------------------------------------------------+
| Articles with not more than one comment by the same user |
+----------------------------------------------------------+
| Davinci Code                                             |
| Effect of Greenhouse Gases on Embryo Development         |
| Man and Art                                              |
| The Evolution of African Arts                            |
| The use of Natural tools in Arts                         |
| Tabitha, the Merry Old Lady                              |
| Innovations in Computing                                 |
| All Help The Priest                                      |
+----------------------------------------------------------+
8 rows in set (0.00 sec)
*/
