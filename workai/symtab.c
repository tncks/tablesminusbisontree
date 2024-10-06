#include "symtab.h"

void initSymbolTable(SymbolTable* symtab) {
    symtab->count = 0;
}

void addSymbol(SymbolTable* symtab, char* name, int type) {
    if (symtab->count < MAX_SYMBOLS) {
        symtab->symbols[symtab->count].name = strdup(name);
        symtab->symbols[symtab->count].type = type;
        symtab->symbols[symtab->count].isInitialized = 0; // 초기화되지 않은 상태로 설정
        symtab->count++;
    } else {
        fprintf(stderr, "Symbol table overflow\n");
    }
}

Symbol* lookupSymbol(SymbolTable* symtab, char* name) {
    for (int i = 0; i < symtab->count; i++) {
        if (strcmp(symtab->symbols[i].name, name) == 0) {
            return &symtab->symbols[i];
        }
    }
    return NULL;
}

void printSymbolTable(SymbolTable* symtab) {
    printf("Symbol Table:\n");
    for (int i = 0; i < symtab->count; i++) {
        printf("Name: %s, Type: %d, Initialized: %d\n",
               symtab->symbols[i].name,
               symtab->symbols[i].type,
               symtab->symbols[i].isInitialized);
    }
}
