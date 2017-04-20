IMG_NAME=datavisualize-new
DATA_CON=$(IMG_NAME)-data
DASH_CON=$(IMG_NAME)
PORTS+=-p 10000:80 -p 2003:10003 -p 8083:8083 -p 8086:8086
VOLUMES+=--volumes-from $(DATA_CON) -v /etc/localtime:/etc/localtime:ro
DEV_VOL=-v $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))):/host

# Build the image
build: 
	docker build -t $(IMG_NAME) .

# Destroy the image
clean: 
	docker rmi $(IMG_NAME) 2>/dev/null || true
	
# Remove the instance
remove: 
	docker rm -f $(DASH_CON) 2>/dev/null || true

# Stop the instance
stop:
	docker stop $(IMG_NAME)

# Create a new instance
create: build data
	docker run --name=$(DASH_CON) -d -ti $(VOLUMES) $(PORTS) $(IMG_NAME)

# Execute a command in a running instance
shell: start
	docker exec -it `docker ps -q -f name=$(DASH_CON)` /bin/bash

# Start a stopped instance
start:
	docker start ${IMG_NAME}

# Create a Data container
data:
	docker run --name=$(DATA_CON) -ti $(IMG_NAME) true 2>/dev/null || true

# Destroy the Data image
purge: stop remove
	@read -n1 -r -p "This will remove all persistent data. Are you sure? " ;\
	echo ;\
	if [ "$$REPLY" == "y" ]; then \
		docker rm -f $(DATA_CON) 2>/dev/null || true; \
	fi

# 
check: build
	docker run --rm -it $(DEV_VOL) $(IMG_NAME) bash -c "cd /host; pep8 --show-source --show-pep8 /host/scripts/*.py"
	docker run --rm -it $(DEV_VOL) $(IMG_NAME) bash -c "cd /host; pylint scripts/*.py"
	# docker run --rm -it $(DEV_VOL) $(IMG_NAME) jsonlint /host/grafana/initial-dashboard.json

.PHONY: build clean stop run shell data purge check
