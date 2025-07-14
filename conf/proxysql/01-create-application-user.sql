INSERT INTO mysql_users (username, password, default_hostgroup) VALUES ('demo_user', 'demo_pwd', 10);
INSERT INTO mysql_query_rules (rule_id, active, match_digest, destination_hostgroup, apply)
VALUES
(10, 1, '^SELECT.*FOR UPDATE$', 10, 1),
(20, 1, '^SELECT', 20, 1);

-- Load users
LOAD MYSQL USERS TO RUNTIME;
SAVE MYSQL USERS TO DISK;

-- Load query rules
LOAD MYSQL QUERY RULES TO RUNTIME;
SAVE MYSQL QUERY RULES TO DISK;
