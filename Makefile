NASM ?= nasm
LD ?= ld
BUILD_DIR := build
SOURCE := src/hello.asm
OBJECT := $(BUILD_DIR)/hello.o
PROGRAM := $(BUILD_DIR)/hello

.PHONY: all run clean

all: $(PROGRAM)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OBJECT): $(SOURCE) | $(BUILD_DIR)
	$(NASM) -f elf32 $< -o $@

$(PROGRAM): $(OBJECT)
	$(LD) -m elf_i386 $< -o $@

run: $(PROGRAM)
	./$(PROGRAM)

clean:
	rm -rf $(BUILD_DIR)
