# GNUmakefile

REPOSITORY = dweomer/vault
VERSIONS   = $(notdir $(wildcard versions/*))
LATEST     = $(notdir $(realpath versions/latest))

export REPOSITORY VERSIONS LATEST

all: $(VERSIONS)

build:
ifndef VERSION
	$(error VERSION is required)
endif
	docker build \
		--build-arg VAULT_VERSION=$(VERSION) \
		--pull \
		--tag $(REPOSITORY):$(VERSION) \
		--tag $(REPOSITORY):$(shell V=$(VERSION); echo $${V%.*}) \
		.

latest: $(LATEST)
	docker tag $(REPOSITORY):$< $(REPOSITORY):$@

$(filter-out latest,$(VERSIONS)):
	@make build VERSION=$@

.PHONY: all build $(VERSIONS)
