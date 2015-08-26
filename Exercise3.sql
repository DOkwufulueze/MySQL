DROP DATABASE IF EXISTS vtapp;

CREATE DATABASE IF NOT EXISTS vtapp;

CREATE USER 'vtapp_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL ON vtapp.* TO 'vtapp_user'@'localhost';

