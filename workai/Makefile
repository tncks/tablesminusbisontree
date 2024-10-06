# Makefile for C-Minus Compiler

CC = gcc
CFLAGS = -g -Wall

# Source files
SRC = main.c ast.c symtab.c parser.tab.c lexer.lex.c

# Object files
OBJ = $(SRC:.c=.o)

# Target executable
TARGET = cm_compiler

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<

parser.tab.c: parser.y
	bison -d parser.y

lexer.lex.c: lexer.l
	flex lexer.l

clean:
	rm -f $(OBJ) $(TARGET) parser.tab.c parser.tab.h lexer.lex.c

.PHONY: all clean
