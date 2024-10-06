%{
#include "ast.h"
#include "symtab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;
void yyerror(const char* s);
struct ASTnode *prog;
SymbolTable symtab;

void initSymbolTable(SymbolTable* symtab);
void addSymbol(SymbolTable* symtab, char* name, int type);
Symbol* lookupSymbol(SymbolTable* symtab, char* name);
void printSymbolTable(SymbolTable* symtab);

%}

%union {
    char* id;
    int num;
    struct ASTnode* node;
}

%token <id> T_ID T_RETURN T_NUM T_STRING
%token T_IF T_ELSE T_WHILE T_FOR T_BLOCK T_VOID T_INT
%token T_SMALLEQ T_SMALL T_GREAT T_GREATEQ T_COMPARE T_NOTEQ
%token T_PLUS T_MINUS T_TIMES T_DIVIDE
%type <node> program declaration var-declaration function-declaration statement expression simple-expression additive-expression term factor call args arg-list

%% 

program: 
    declaration
    | program declaration
    ;

declaration:
    var-declaration
    | function-declaration
    ;

var-declaration:
    T_INT T_ID ';'
    {
        addSymbol(&symtab, $2, T_INT); // 심볼 테이블에 추가
        $$ = ASTCreateNode(VARDEC);
        $$->name = $2;
    }
    | T_VOID T_ID ';'
    {
        addSymbol(&symtab, $2, T_VOID); // 심볼 테이블에 추가
        $$ = ASTCreateNode(VARDEC);
        $$->name = $2;
        $$->isType = VOIDDEC;
    }
    ;

function-declaration:
    T_INT T_ID '(' args ')' '{' statement '}'
    {
        $$ = ASTCreateNode(FUNCTIONDEC);
        $$->name = $2;
        $$->right = $4;  // Parameters
        $$->s1 = $6;     // Function body
    }
    | T_VOID T_ID '(' args ')' '{' statement '}'
    {
        $$ = ASTCreateNode(FUNCTIONDEC);
        $$->name = $2;
        $$->right = $4;  // Parameters
        $$->s1 = $6;     // Function body
        $$->isType = VOIDDEC;
    }
    ;

statement:
    expression ';'
    | T_RETURN ';'
    {
        $$ = ASTCreateNode(RETURNSTMT);
    }
    | T_RETURN expression ';'
    {
        $$ = ASTCreateNode(RETURNSTMT);
        $$->s1 = $2;
    }
    | T_IF '(' expression ')' statement
    {
        $$ = ASTCreateNode(IFSTMT);
        $$->s1 = $3;  // Condition
        $$->s2 = $5;  // Then statement
    }
    | T_IF '(' expression ')' statement T_ELSE statement
    {
        $$ = ASTCreateNode(IFSTMT);
        $$->s1 = $3;  // Condition
        $$->s2 = $5;  // Then statement
        $$->s3 = $7;  // Else statement
    }
    | T_WHILE '(' expression ')' statement
    {
        $$ = ASTCreateNode(ITERSTMT);
        $$->s1 = $3;  // Condition
        $$->s2 = $5;  // Body
    }
    | '{' statement '}'
    {
        $$ = $2;  // Block
    }
    ;

expression:
    var '=' expression
    {
        $$ = ASTCreateNode(ASSIGN);
        $$->left = $1;
        $$->right = $3;
    }
    | simple-expression
    ;

simple-expression:
    additive-expression relop additive-expression
    {
        $$ = ASTCreateNode(EXPR);
        $$->left = $1;
        $$->op = $2;
        $$->right = $3;
    }
    | additive-expression
    ;

relop:
    T_SMALLEQ { $$ = LESSTHANEQUAL; }
    | T_SMALL { $$ = LESSTHAN; }
    | T_GREAT { $$ = GREATERTHAN; }
    | T_GREATEQ { $$ = GREATERTHANEQUAL; }
    | T_COMPARE { $$ = EQUAL; }
    | T_NOTEQ { $$ = NOTEQUAL; }
    ;

additive-expression:
    additive-expression addop term
    {
        $$ = ASTCreateNode(EXPR);
        $$->left = $1;
        $$->op = $2;
        $$->right = $3;
    }
    | term
    ;

addop:
    '+' { $$ = PLUS; }
    | '-' { $$ = MINUS; }
    ;

term:
    term mulop factor
    {
        $$ = ASTCreateNode(EXPR);
        $$->left = $1;
        $$->op = $2;
        $$->right = $3;
    }
    | factor
    ;

mulop:
    '*' { $$ = TIMES; }
    | '/' { $$ = DIVIDE; }
    ;

factor:
    '(' expression ')'
    {
        $$ = $2;
    }
    | var
    | call
    | T_NUM
    {
        $$ = ASTCreateNode(NUMBER);
        $$->value = $1;
        $$->isType = INTDEC;
    }
    ;

call:
    T_ID '(' args ')'
    {
        $$ = ASTCreateNode(CALLSTMT);
        $$->name = $1;
        $$->right = $3;  // Arguments
    }
    ;

args:
    arg-list
    | /* empty */
    ;

arg-list:
    arg-list ',' expression
    {
        $$ = ASTCreateNode(ARGLIST);
        $$->left = $3;
        $$->right = $1;
    }
    | expression
    {
        $$ = ASTCreateNode(ARGLIST);
        $$->right = $1;
    }
    ;

var:
    T_ID
    {
        $$ = ASTCreateNode(IDENT);
        $$->name = $1;
    }
    | T_ID '[' expression ']'
    {
        $$ = ASTCreateNode(IDENT);
        $$->name = $1;
        $$->right = $3;  // Index expression
    }
    ;

%% 

void yyerror(const char* s) {
    fprintf(stderr, "%s on line %d\n", s, yylineno);
}

int main(int argc, char *argv[]) {
    initSymbolTable(&symtab); // 심볼 테이블 초기화
    if (argc == 2)
        yyin = fopen(argv[1], "r");
    else {
        printf("No files - Exit\n");
        exit(1);
    }
    yyparse();
    printSymbolTable(&symtab); // 심볼 테이블 출력
    ASTprint(0, prog);
    return 0;
}
