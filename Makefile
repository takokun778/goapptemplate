include .env
export

.PHONY: help
help: ## display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: name
name: ## display app name
	@echo ${APP_NAME}

.PHONY: aqua
aqua: ## Put the path in your environment variables. ex) export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
	@go run github.com/aquaproj/aqua-installer@latest --aqua-version v2.0.0

.PHONY: tool
tool: ## install tool
	@aqua install

.PHONY: compile
compile: ## go compile
	@go build -v ./... && go clean

.PHONY: fmt
fmt: ## go format
	@go fmt ./...

.PHONY: lint
lint: ## go lint
	@golangci-lint run --fix

.PHONY: renovate
renovate: ## go modules update
	@go get -u -t ./...
	@go mod tidy
	@go mod vendor

.PHONY: mod
mod: ## go mod tidy & go mod vendor
	@go mod tidy
	@go mod vendor

.PHONY: test
test: ## unit test
	@$(call _test,${c})

define _test
if [ -z "$1" ]; then \
	go test ./internal/... ; \
else \
	go test ./internal/... -count=1 ; \
fi
endef

.PHONY: e2e
e2e: ## e2e test
	@$(call _e2e,${c})

define _e2e
if [ -z "$1" ]; then \
	go test ./e2e/... ; \
else \
	go test ./e2e/... -count=1 ; \
fi
endef

.PHONY: dev
up: ## docker compose up with air hot reload
	@docker compose --project-name ${APP_NAME} --file ./.docker/docker-compose.yaml up -d

.PHONY: down
down: ## docker compose down
	@docker compose --project-name ${APP_NAME} down --volumes

.PHONY: balus
balus: ## Destroy everything about docker. (containers, images, volumes, networks.)
	@docker compose --project-name ${APP_NAME} down --rmi all --volumes

.PHONY: ymlfmt
ymlfmt: ## yaml file format
	@yamlfmt

.PHONY: ymlint
ymlint: ## yaml file lint
	@yamlfmt -lint && actionlint
