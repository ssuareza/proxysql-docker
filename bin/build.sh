#!/bin/bash

# 0. Init
docker compose down -v
docker compose build
docker compose up -d

# 1. MySQL
# wait mysql1
until docker exec mysql1 sh -c 'export MYSQL_PWD=111; mysql -u root -e ";"'
do
    echo "Waiting for mysql1 database connection..."
    sleep 4
done

# get master status
MASTER_STATUS=`docker exec mysql1 sh -c 'export MYSQL_PWD=111; mysql -u root -e "SHOW MASTER STATUS"'`
CURRENT_LOG=`echo $MASTER_STATUS | awk '{print $6}'`
CURRENT_POS=`echo $MASTER_STATUS | awk '{print $7}'`

# wait mysql2
until docker compose exec mysql2 sh -c 'export MYSQL_PWD=111; mysql -u root -e ";"'
do
    echo "Waiting for mysql2 database connection..."
    sleep 4
done

# start mysql2 slave
start_slave_stmt="CHANGE MASTER TO MASTER_HOST='mysql1',MASTER_USER='demo_slave_user',MASTER_PASSWORD='demo_slave_pwd',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"
start_slave_cmd='export MYSQL_PWD=111; mysql -u root -e "'
start_slave_cmd+="$start_slave_stmt"
start_slave_cmd+='"'
docker exec mysql2 sh -c "$start_slave_cmd"

# check mysql2 slave status
docker exec mysql2 sh -c "export MYSQL_PWD=111; mysql -u root -e 'SHOW SLAVE STATUS \G'"

# wait mysql3
until docker compose exec mysql3 sh -c 'export MYSQL_PWD=111; mysql -u root -e ";"'
do
    echo "Waiting for mysql3 database connection..."
    sleep 4
done

# start mysql3 slave
start_slave_stmt="CHANGE MASTER TO MASTER_HOST='mysql1',MASTER_USER='demo_slave_user',MASTER_PASSWORD='demo_slave_pwd',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"
start_slave_cmd='export MYSQL_PWD=111; mysql -u root -e "'
start_slave_cmd+="$start_slave_stmt"
start_slave_cmd+='"'
docker exec mysql3 sh -c "$start_slave_cmd"

# check mysql3 slave status
docker exec mysql3 sh -c "export MYSQL_PWD=111; mysql -u root -e 'SHOW SLAVE STATUS \G'"

# 2. ProxySQL
export MYSQL_PWD=radmin; cat ./conf/proxysql/*.sql | mysql -u radmin -h 127.0.0.1 -P 6032

# mysql -u radmin -pradmin -h 127.0.0.1 -P 6032 --prompt='ProxySQLAdmin> '

# mysql -u demo_user -pdemo_pwd -h 127.0.0.1 -P 6033 
# USE demo
# CREATE TABLE IF NOT EXISTS test_table (id INT); SELECT @@hostname;"


# SELECT hostgroup, count_star, digest_text FROM stats_mysql_query_digest WHERE digest_text LIKE '%hostname%';
