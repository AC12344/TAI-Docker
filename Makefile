image=askebm/tai:nvidia-0
container_id_file = /tmp/tai_container_id

build:
	docker build -t $(image) .

buildrm:
	docker rmi $(image)

$(container_id_file) :
	xhost local:docker
	docker run -it \
		--cidfile $(container_id_file) \
		-e DISPLAY \
		-v $(shell pwd):$(shell pwd) \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		--detach \
		--workdir $(shell pwd) \
		--runtime=nvidia \
		$(image) 
	echo "Mounted ${PWD}"

start:
	xhost local:docker
	docker container start $(shell cat $(container_id_file) )

stop:
	docker container stop $(shell cat $(container_id_file) )

rm:
	docker container stop $(shell cat $(container_id_file) )
	docker container rm $(shell cat $(container_id_file) )
	rm -f $(container_id_file)

enter: $(container_id_file)
	docker exec -it $(shell cat $(container_id_file)) bash

init: $(container_id_file)

clangd: $(container_id_file)
	docker exec -it $(shell cat $(container_id_file)) clangd-10


	
.PHONY: build buildrm start stop rm enter init clangd
help:
	@echo "build"
	@echo "buildrm"
	@echo "start"
	@echo "stop"
	@echo "rm"
	@echo "enter"
	@echo "init"
	@echo "clangd"
.PHONY: help

