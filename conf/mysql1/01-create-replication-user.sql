CREATE USER "demo_slave_user"@"%" IDENTIFIED BY "demo_slave_pwd";
GRANT REPLICATION SLAVE ON *.* TO "demo_slave_user"@"%";
FLUSH PRIVILEGES;
