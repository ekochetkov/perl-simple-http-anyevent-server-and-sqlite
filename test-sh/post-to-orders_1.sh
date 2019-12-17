#!/bin/bash

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"perf_id" : 2133,"name" : "Oliver","price" : 32.4,"amount" : 5}' \
  http://localhost:8080/orders/3