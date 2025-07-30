image:
	gunzip -c opam-z3.tar.gz | docker load
	docker build --platform linux/amd64 -t cobb_artifact .
	docker save cobb_artifact | gzip > cobb_artifact.tar.gz