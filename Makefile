# GNUmakefile

CACHE += dweomer/hashibase
CACHE += $(REPOSITORY)

REPOSITORY = dweomer/vault
VERSION = 0.9.4

latest: 0.9
	docker tag $(REPOSITORY):$< $(REPOSITORY):$@

build:
	docker build \
	--build-arg VAULT_VERSION=$(VERSION) \
	--cache-from=$(REPOSITORY):$(VERSION) \
	$(foreach cache,$(CACHE),--cache-from=$(cache)) \
	--tag $(REPOSITORY):$(VERSION) \
	--tag $(REPOSITORY):$(shell export V=$(VERSION); echo $${V%.*}) \
	.

all: latest 0.9 0.8

0.8: $(CACHE)
	@make VERSION=0.8.3 build
.PHONY: 0.8

0.9: $(CACHE)
	@make VERSION=0.9.4 build
.PHONY: 0.9

$(CACHE):
	docker pull $@ || true

.PHONY: all build latest $(CACHE)
