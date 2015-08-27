DROP DATABASE IF EXISTS article_db;

CREATE DATABASE IF NOT EXISTS article_db;

USE article_db;

CREATE TABLE IF NOT EXISTS user_types (
  id INT AUTO_INCREMENT,
  user_type VARCHAR(10),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT,
  user_type_id INT,
  username VARCHAR(200),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT,
  category VARCHAR(100),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS articles (
  id INT AUTO_INCREMENT,
  user_id INT,
  category_id INT,
  article VARCHAR(200),
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS comments (
  id INT AUTO_INCREMENT,
  user_id INT,
  article_id INT,
  comment TEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (article_id) REFERENCES articles(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Dumping data into tables

-- user_types
INSERT INTO user_types(user_type)
VALUES
  ('admin'),
  ('normal');

-- users
INSERT INTO users(user_type_id, username)
VALUES
  ('1', 'User1'),
  ('2', 'User2'),
  ('2', 'User3'),
  ('2', 'User4'),
  ('1', 'User5'),
  ('2', 'User6');

-- categories
INSERT INTO categories(category)
VALUES
  ('Sciences'),
  ('Arts'),
  ('Fiction'),
  ('Sports');

-- articles
INSERT INTO articles(user_id, category_id, article)
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
INSERT INTO comments(user_id, article_id, comment)
VALUES
  ('3', '17', 'Wow! really interesting work of fiction.'),
  ('3', '2', 'Davinci Code: A truly engaging work.'),
  ('1', '2', 'Almost real!!!'),
  ('1', '3', 'Great work!!!'),
  ('1', '3', 'On second thought, WONDERFUL WORK!!!'),
  ('4', '5', 'A brilliant exposure to the world of arts.'),
  ('6', '2', 'It keeps you glued till the end of the book.'),
  ('5', '4', 'I hope people learn from this article and get more careful'),
  ('2', '14', 'It\'s great to see that computing techniques will only improve.'),
  ('6', '8', 'Discusses in clear terms the history of arts.'),
  ('1', '8', 'A wonderful history article.'),
  ('5', '9', 'Nature is indeed the best example.'),
  ('4', '9', 'It\'s great to see how positively useful nature can be.'),
  ('2', '12', 'An exciting and bright story.');



-- select all articles whose author's name is user3 (Do this exercise using variable)
SET @user = 'user3';

SELECT article AS 'Articles whose author is user3' 
FROM articles
INNER JOIN users
ON(articles.user_id = users.id)
WHERE users.username = @user;

-- select articles and comments for the articles selected above
SELECT article AS Articles, comment AS 'Comments from readers'
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

-- select articles that don't have any comments
SELECT article AS 'Articles With No Comments'
FROM articles
WHERE articles.id NOT IN(
  SELECT article_id FROM comments
);

-- select articles that have maximum number of comments
SELECT article AS 'Article', MAX(number_of_comments)AS 'Number Of Comments'
FROM (
  SELECT article, COUNT(article_id) AS number_of_comments
  FROM articles
  INNER JOIN comments
  ON(articles.id = comments.article_id)
  GROUP BY article_id
) AS count_table;

-- select article which does not have more than one comment by the same user
SELECT DISTINCT article AS 'Articles with not more than one comment by the same user'
FROM comments
LEFT JOIN articles
ON(articles.id = comments.article_id)
GROUP BY comments.article_id, comments.user_id
HAVING COUNT(comments.user_id) <= 1;

