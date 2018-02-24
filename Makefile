# GNUmakefile

REPOSITORY = dweomer/vault
LATEST     = $(notdir $(realpath tags/latest))
TAGS       = $(notdir $(wildcard tags/*))
VERSION    = $(shell cat tags/latest)

export REPOSITORY LATEST TAGS

all: $(TAGS)

build:
	docker build \
		--build-arg VAULT_VERSION=$(VERSION) \
		--pull \
		--tag $(REPOSITORY):$(VERSION) \
		--tag $(REPOSITORY):$(shell V=$(VERSION); echo $${V%.*}) \
		.

latest: $(LATEST)
	docker tag $(REPOSITORY):$(shell cat tags/$<) $(REPOSITORY):$@

$(filter-out latest,$(TAGS)):
	@make build VERSION=$(shell cat tags/$@)

.PHONY: all build $(TAGS)
