CREATE DATABASE IF NOT EXISTS mysql_track;

USE mysql_track;

CREATE TABLE IF NOT EXISTS testing_table (
  name VARCHAR(200),
  contact_name VARCHAR(200),
  roll_no char(10)
);

ALTER TABLE testing_table 
  DROP name, 
  CHANGE contact_name username VARCHAR(200), 
  ADD first_name VARCHAR(100), 
  ADD last_name VARCHAR(100), 
  MODIFY roll_no INT;

  