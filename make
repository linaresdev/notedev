#!/usr/bin/env bash
docker run -itd \
	-v "$PWD/etc":/home/lara/etc \
	-v "$PWD/www":/home/lara/www \
	--name moon \
	--hostname moon \
	--network host \
	wsos bash
