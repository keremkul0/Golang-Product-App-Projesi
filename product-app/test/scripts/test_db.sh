#!/bin/bash

# Remove any existing container with the same name
docker rm -f postgres-test

# Start the PostgreSQL container
docker run --name postgres-test -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 6432:5432 -d postgres:latest

echo "Postgresql starting..."
sleep 10

# Check if the container is running
if ! docker ps | grep -q postgres-test; then
  echo "Failed to start postgres-test container."
  exit 1
fi

# Create the database
docker exec -it postgres-test psql -U postgres -d postgres -c "CREATE DATABASE productapp"
sleep 3
echo "Database productapp created"

# Create the table
docker exec -it postgres-test psql -U postgres -d productapp -c "
create table if not exists products
(
    id bigserial not null primary key,
    name varchar(255) not null,
    price double precision not null,
    discount double precision,
    store varchar(255) not null
);
"
sleep 3
echo "Table products created"
