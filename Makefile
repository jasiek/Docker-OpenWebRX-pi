all:	default publish

default:
	docker build -t jasiek/openwebrx:arm32v7 .

publish:
	docker push jasiek/openwebrx:arm32v7
