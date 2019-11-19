#!/bin/bash

echo "start run"
sed -i "s~{{MONITOR_SERVER_PORT}}~$MONITOR_SERVER_PORT~g" alertmanager/alertmanager.yml
sed -i "s~{{MONITOR_SERVER_PORT}}~$MONITOR_SERVER_PORT~g" monitor/conf/default.json
sed -i "s~{{MONITOR_DB_HOST}}~$MONITOR_DB_HOST~g" monitor/conf/default.json
sed -i "s~{{MONITOR_DB_PORT}}~$MONITOR_DB_PORT~g" monitor/conf/default.json
sed -i "s~{{MONITOR_DB_USER}}~$MONITOR_DB_USER~g" monitor/conf/default.json
sed -i "s~{{MONITOR_DB_PWD}}~$MONITOR_DB_PWD~g" monitor/conf/default.json

cd consul
mkdir -p logs
nohup ./consul agent -dev > logs/consul.log 2>&1 &
cd ../alertmanager/
mkdir -p logs
nohup ./alertmanager --config.file=alertmanager.yml > logs/alertmanager.log 2>&1 &
cd ../prometheus/
mkdir -p logs
nohup ./prometheus --config.file=prometheus.yml --web.enable-lifecycle > logs/prometheus.log 2>&1 &
cd ../monitor/
mkdir -p logs
./monitor-server

