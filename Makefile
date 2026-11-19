.DEFAULT_GOAL := build
.PHONY: help build


include ee.env
export


EE_IMAGE_TAG = a_$(ANSIBLE_VERSION)-h_$(HELM_VERSION)


help:
	@echo "================================================================="
	@echo " Available commands:"
	@echo "================================================================="
	@echo "  make       - Builds an isolated Docker runner image"
	@echo ""
	@echo " Current Default Configuration:"
	@echo "  ANSIBLE_VERSION : $(ANSIBLE_VERSION)"
	@echo "  HELM_VERSION    : $(HELM_VERSION)"
	@echo "  EE_IMAGE_NAME   : $(EE_IMAGE_NAME)"
	@echo "  EE_IMAGE_TAG    : $(EE_IMAGE_TAG)"
	@echo ""
	@echo " Usage examples:"
	@echo "  make                                      (uses defaults)"
	@echo "  make  ANSIBLE_VERSION=2.17.0              (override one)"
	@echo "  make  HELM_VERSION=v3.16.0                (override another)"
	@echo "================================================================="

build:
	@echo "Starting isolated Docker build for: $(EE_IMAGE_NAME):$(EE_IMAGE_TAG)"
	docker run --rm -i \
		-v "$$(pwd)":/code -v /var/run/docker.sock:/var/run/docker.sock \
		python:3.11-alpine \
		sh -c " \
			cp -r /code/* . && \
			apk add --no-cache docker-cli && \
			python3 -m venv /opt/venv && \
			export PATH="/opt/venv/bin:\$$PATH" && \
			pip install --no-cache-dir ansible-builder && \
			cd execution-environment && \
			cp execution-environment.yml execution-environment.tmp.yml && \
			sed -i 's/__ANSIBLE_VERSION__/$(ANSIBLE_VERSION)/g' execution-environment.tmp.yml && \
			sed -i 's/__HELM_VERSION__/v$(HELM_VERSION)/g' execution-environment.tmp.yml && \
			sed -i 's/__HELM_DIFF_VERSION__/v$(HELM_DIFF_VERSION)/g' execution-environment.tmp.yml && \
			ansible-builder build -f execution-environment.tmp.yml -t $(EE_IMAGE_NAME):$(EE_IMAGE_TAG) --container-runtime docker && \
			rm execution-environment.tmp.yml \
		"
	@echo "================================================================="
	@echo " Success! Image $(EE_IMAGE_NAME):$(EE_IMAGE_TAG) is now available locally."
	@echo "================================================================="



