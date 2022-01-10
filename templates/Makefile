ifndef VERSION
VERSION = $(shell git rev-parse --short head)
endif

candidate:
	cat deployment-candidate.yaml | sed "s/VERSION/v$(VERSION)/g" > ../deploy/deployment-candidate.yaml

clean:
	rm -f ../deploy/deployment-candidate.yaml
