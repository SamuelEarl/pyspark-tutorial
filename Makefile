# Makefiles have to use tabs instead of spaces.

run:
	docker run -it \
		-v "${PWD}":/home/jovyan/work \
		--user root \
		-e CHOWN_HOME=yes \
		-e CHOWN_HOME_OPTS='-R' \
		-p 8888:8888 \
		--name pyspark-notebook \
		jupyter/pyspark-notebook

stop:
	docker stop pyspark-notebook

list:
	docker ps -a

start:
	docker start -a pyspark-notebook

remove:
	docker rm pyspark-notebook

make bash:
	docker container exec -it pyspark-notebook bash