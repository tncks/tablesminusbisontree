#include "ast.h"

struct ASTnode* ASTCreateNode(NodeType type) {
    struct ASTnode* node = (struct ASTnode*)malloc(sizeof(struct ASTnode));
    node->type = type;
    node->left = node->right = node->s1 = node->s2 = node->s3 = NULL;
    return node;
}

void ASTprint(int level, struct ASTnode* node) {
    if (node == NULL) return;
    for (int i = 0; i < level; i++) printf("  ");
    switch (node->type) {
        case VARDEC: printf("Variable Declaration: %s\n", node->name); break;
        case FUNCTIONDEC: printf("Function Declaration: %s\n", node->name); break;
        case RETURNSTMT: printf("Return Statement\n"); break;
        case IFSTMT: printf("If Statement\n"); break;
        case ITERSTMT: printf("While Statement\n"); break;
        case ASSIGN: printf("Assignment\n"); break;
        case EXPR: printf("Expression\n"); break;
        case NUMBER: printf("Number: %d\n", node->value); break;
        case IDENT: printf("Identifier: %s\n", node->name); break;
        case CALLSTMT: printf("Call Statement: %s\n", node->name); break;
        case ARGLIST: printf("Argument List\n"); break;
    }
    ASTprint(level + 1, node->left);
    ASTprint(level + 1, node->right);
    ASTprint(level + 1, node->s1);
    ASTprint(level + 1, node->s2);
    ASTprint(level + 1, node->s3);
}
