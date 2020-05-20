all: build

build:
	@docker build --tag=innovanon/docker-apt-cacher-ng .
