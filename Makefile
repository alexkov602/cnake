# Compiler and paths
CC := gcc
SRC_DIR := src
BUILD_DIR := build
BIN_DIR := bin
BIN := $(BIN_DIR)/cnake

# Source and object files
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))
DEPS := $(OBJS:.o=.d)

# Compiler flags
BASE_CFLAGS := -Wall -Wextra -Werror -pedantic -Wstrict-prototypes -std=c99 -Iinclude
DBG_CFLAGS := -g -O0
RLS_CFLAGS := -O2
LDFLAGS := -lncurses

# Build type (default: release)
BUILD_TYPE ?= release

ifeq ($(BUILD_TYPE),debug)
    CFLAGS := $(BASE_CFLAGS) $(DBG_CFLAGS)
else ifeq ($(BUILD_TYPE),release)
    CFLAGS := $(BASE_CFLAGS) $(RLS_CFLAGS)
else
    $(error Unknown BUILD_TYPE '$(BUILD_TYPE)'; use 'debug' or 'release')
endif

# Main target
all: $(BIN)

# Link
$(BIN): $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $(OBJS) $(LDFLAGS) -o $@

# Compile
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

# Include deps
-include $(DEPS)

# Run
.PHONY: run
run: $(BIN)
	./$(BIN)

# Explicit build types
.PHONY: debug release
debug:
	$(MAKE) BUILD_TYPE=debug

release:
	$(MAKE) BUILD_TYPE=release

# Clean only build files, not bin/
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
