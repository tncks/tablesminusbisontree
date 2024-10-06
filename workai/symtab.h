#ifndef SYMTAB_H
#define SYMTAB_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SYMBOLS 100

typedef struct {
    char* name;
    int type;
    int isInitialized; // 추가된 필드
} Symbol;

typedef struct {
    Symbol symbols[MAX_SYMBOLS];
    int count;
} SymbolTable;

void initSymbolTable(SymbolTable* symtab);
void addSymbol(SymbolTable* symtab, char* name, int type);
Symbol* lookupSymbol(SymbolTable* symtab, char* name);
void printSymbolTable(SymbolTable* symtab);

#endif
