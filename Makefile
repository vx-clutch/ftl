CC := gcc
CFLAGS := -Wall -Wextra -pedantic -std=c11 -I./ftl -D COMPILER_PLATFORM="\"$(shell uname -o) $(shell uname -r)\""
LDFLAGS := 
SRC := $(wildcard ftl/*.c) $(wildcard ftl/options/*.c)
OBJ := $(SRC:.c=.o)
BIN_DIR := bin
EXEC := $(BIN_DIR)/ftl

.PHONY: all clean run

all: $(EXEC)

$(EXEC): $(OBJ) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(OBJ) -o $(EXEC) $(LDFLAGS)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

cftl/%.o: cftl/%.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJ) $(EXEC)

run: all
	./$(EXEC)
