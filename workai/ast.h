#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    VARDEC,
    FUNCTIONDEC,
    RETURNSTMT,
    IFSTMT,
    ITERSTMT,
    ASSIGN,
    EXPR,
    NUMBER,
    IDENT,
    CALLSTMT,
    ARGLIST
} NodeType;

struct ASTnode {
    NodeType type;
    char *name;
    int value;
    struct ASTnode *left;
    struct ASTnode *right;
    struct ASTnode *s1;
    struct ASTnode *s2;
    struct ASTnode *s3;
};

struct ASTnode* ASTCreateNode(NodeType type);
void ASTprint(int level, struct ASTnode* node);

#endif
