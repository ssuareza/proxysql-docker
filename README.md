# proxysql-docker

This repository launches a small MySQL cluster (1 master and 2 slaves) and configure ProxySQL with 2 hostgroups.

## How to run?

1. Create services:

```dc
bin/build.sh
```

**Note**: this is going to delete all resources on each execution.

2. Test mysql replication:

```dc
bin/test-mysql-replication.sh
```

3. Test proxysql:

```sh
bin/test-proxysql.sh
```
