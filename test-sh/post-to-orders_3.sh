#!/bin/bash

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"perf_id" : 122,"name" : "XMan","price" : 12,"amount" : 2}' \
  http://localhost:8080/orders/3