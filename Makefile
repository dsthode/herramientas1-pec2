IMAGE_NAME=hhyc1
DOCKER_RUN=docker run -it -p 127.0.0.1:1234:1234 -p 127.0.0.1:33999:33999 --rm --user `id -u`:`id -g` --network=bridge -v $(PWD):/usr/src/pec -w /usr/src/pec $(IMAGE_NAME)

build:
	docker build -f Dockerfile -t $(IMAGE_NAME) .

destroy:
	docker rmi $(IMAGE_NAME)

start:
	$(DOCKER_RUN) npm start
	
exec:
	$(DOCKER_RUN) $(ARGS)
