# DataVisualize

The DataVisualize project is to help deploy InfluxDB and Grafana in a single instance of Docker. This will then be deployed and connected to multiple performance tools to visualize performance data into beautiful graphs. 

## Background

## Prerequisites

Here are a list of prerequisites to start and run the Grafana and InfluxDB instance.

1. Docker
2. Make 
3. GIT (Optional)

## Install Instructions

You will first want to download the code to your local machine. You can either download it using the Download option or use git to clone the repository.

`git clone https://github.com/husainkhambaty/datavisualize.git`
`make create`

If you are using a Windows machine, you would need to download [Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm) and run it in the Docker Command Line Interface (CLI) console. 

__You can open a browser and go to http://localhost:10000 to access the Grafana Dashboard. You can use the "light:light" user account to access a non-privileged account to view the dashboards.__

## Stopping and Starting the Instance

To stop and/or start the docker image instance, you can use the following command:

`make stop`
`make start`

## Clean and Delete the instance data

To delete all the existing instance along with the data from the data volume, you can use the following command:

`make purge`
`make clean`

## Login to the Shell

To login to the shell and administer Grafana or InfluxDB, you can use the following command:

`make shell`

Ensure the instance is up and running.

# Other Information

## Default Ports

1. Grafana is accessible on port 10000
2. InfluxDB admin is accessible on port 8083
3. Optional: If you are using JMeter, Graphite is accessible on 2003


