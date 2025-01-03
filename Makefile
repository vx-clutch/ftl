# Copyright (C) 2025 vx-clutch ( owestness@gmail.com )
# See end of file for extended copyright information.

ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif

CC := $(shell ./configure -from-make)
CFLAGS := -Wall -Wextra -O2 -pedantic -static -std=c11 -I./ftl -D COMPILER_PLATFORM="\"$(shell uname -o) $(shell uname -r)\""
LDFLAGS :=
SRC := $(wildcard ftl/*.c) $(wildcard ftl/options/*.c)
BIN_DIR := build
OBJ_DIR := $(BIN_DIR)/obj
OBJ := $(patsubst %.c,$(OBJ_DIR)/%.o,$(SRC))
EXEC := $(BIN_DIR)/bin/ftl
MAN_DIR := $(PREFIX)/share/man
MAN_SRC := man/ftl.1
MAN_DEST := $(MAN_DIR)/man1/ftl.1
GC := go build
GOFLAGS := -buildmode=c-shared
GOSRC := libgo/go/main.go
LIBGO_DIR := libgo
LIBGO_SO := $(OBJ_DIR)/libgo/libgo.so

.PHONY: all clean install uninstall

all: $(EXEC) $(LIBGO_SO)

$(EXEC): $(OBJ) | $(BIN_DIR)/bin
	@echo -n "  CALL  "
	$(CC) $(CFLAGS) $(OBJ) -o $@ $(LDFLAGS)

$(LIBGO_SO): $(GOSRC) | $(LIBGO_DIR) $(BIN_DIR)/obj/libgo
	@echo -n "  CALL  "
	cd $(LIBGO_DIR) && $(GC) $(GOFLAGS) -o ../$(LIBGO_SO) go/main.go

$(BIN_DIR)/bin $(OBJ_DIR) $(BIN_DIR)/obj/libgo:
	@echo -n "  CALL  "
	mkdir -p $@

$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	@echo -n "  CALL  "
	mkdir -p $(dir $@)
	@echo -n "  CALL  "
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo -n "  CALL  "
	$(RM) -r $(BIN_DIR)

install: $(EXEC) $(LIBGO_SO)
	install -d $(PREFIX)/bin
	install $(EXEC) $(PREFIX)/bin/
	install -d $(MAN_DIR)/man1
	install -m 644 $(MAN_SRC) $(MAN_DEST)

uninstall:
	$(RM) $(PREFIX)/bin/ftl
	$(RM) $(MAN_DEST)
run:
	export LD_LIBRARY_PATH=.
	./build/bin/ftl

# ftl is a simple and extensible compiler.
# Copyright (C) 2024 vx-clutch
#
# The file is part of ftl.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions, and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions, and the following disclaimer in the documentation or
# other materials provided with the distribution.
# 3. Neither the name of vx-clutch nor the names of its contributors may be
# used to endorse or promote products derived from this software without
# specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
