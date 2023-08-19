#!/bin/bash
docker-compose down
docker rmi tomershalev9/myapp:web mongo


#only use in case you are doing docker compose up locally!!