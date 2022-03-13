include env.mk

PODMAN_RUN=podman run -it --rm --workdir $(WORKING_DIR) -v .:/app:z $(IMAGE_NAME):$(IMAGE_VERSION)

.PHONY: all
all:
	$(PODMAN_RUN) $(SHELL) -c "	mkdir -p $(BIN) && g++ $(SRC)/main.cpp -o $(BIN)/main -L$(POCO_CONTAINER_LIB_DIR) -Wall -lPocoNet -lPocoNetSSL -lPocoFoundation"

.PHONY: build-container
build-container:
	podman build . -t $(IMAGE_NAME):$(IMAGE_VERSION)

# This target copies the containers header files into the projects working directory.
# This is purely to provide linting/Intellisense support while developing on the host
# as the host isn't exposed to these components otherwise.
.PHONY: setup-dev
setup-dev:
	mkdir -p $(TMP)
	$(PODMAN_RUN) $(SHELL) -c "cp -r $(POCO_CONTAINER_INCLUDE_DIR) $(WORKING_DIR)/$(TMP)"
	$(PODMAN_RUN) $(SHELL) -c "cp -r $(OPENSSL_CONTAINER_INCLUDE_DIR) $(WORKING_DIR)/$(TMP)"

.PHONY: runcont
runcont:
	$(PODMAN_RUN)

# Example usage for executing a binary within the container
.PHONY: run-dev-main
run-dev-main:
	$(PODMAN_RUN) $(SHELL) -c "LD_LIBRARY_PATH=$(POCO_CONTAINER_LIB_DIR):$(OPENSSL_CONTAINER_LIB_DIR) $(WORKING_DIR)/$(BIN)/main"

.PHONY: clean
clean:
	rm -rf $(TMP)/
	rm -rf $(BIN)/*
