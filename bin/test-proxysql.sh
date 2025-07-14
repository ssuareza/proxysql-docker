#!/bin/sh

# write
export MYSQL_PWD=demo_pwd; mysql -u demo_user -h 127.0.0.1 -P 6033 demo -e "CREATE TABLE IF NOT EXISTS test_table (id INT); SELECT @@hostname;"
