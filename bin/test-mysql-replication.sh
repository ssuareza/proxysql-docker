#!/bin/sh

# insert data on mysql1
data_stmt='CREATE TABLE IF NOT EXISTS code(code int); INSERT INTO code VALUES (100), (200);'
docker exec mysql1 sh -c "export MYSQL_PWD=111; mysql -u root -e '$data_stmt' demo"

# check data on mysql2
docker exec mysql2 sh -c "export MYSQL_PWD=111; mysql -u root -e 'SELECT * FROM code;' demo"

# check data on mysql3
docker exec mysql3 sh -c "export MYSQL_PWD=111; mysql -u root -e 'SELECT * FROM code;' demo"

