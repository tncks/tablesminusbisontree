%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
%}

%%

// 키워드 및 식별자
if                  { return T_IF; }
else                { return T_ELSE; }
while               { return T_WHILE; }
for                 { return T_FOR; }
return              { return T_RETURN; }
void                { return T_VOID; }
int                 { return T_INT; }

// 연산자
"=="                { return T_COMPARE; }
"!="                { return T_NOTEQ; }
"<="                { return T_SMALLEQ; }
"<"                 { return T_SMALL; }
">="                { return T_GREATEQ; }
">"                 { return T_GREAT; }
"+"                 { return T_PLUS; }
"-"                 { return T_MINUS; }
"*"                 { return T_TIMES; }
"/"                 { return T_DIVIDE; }

// 숫자와 문자열
[0-9]+              { yylval.num = atoi(yytext); return T_NUM; }
\"[^\"]*\"         { yylval.id = strdup(yytext); return T_STRING; }

// 식별자
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id = strdup(yytext); return T_ID; }

// 구분자
";"                 { return T_SEMI; }
","                 { return T_COMMA; }
"("                 { return T_LPAREN; }
")"                 { return T_RPAREN; }
"{"                 { return T_LBRACE; }
"}"                 { return T_RBRACE; }
"["                 { return T_LBRACKET; }
"]"                 { return T_RBRACKET; }

// 공백 및 주석
[ \t\n]            ;
"//".*             ;  // 한 줄 주석
"/*"[^*]*"*/"      ;  // 여러 줄 주석

.                   { return yytext[0]; }  // 기타 문자

%%

// 에러 처리
int yywrap() {
    return 1;
}

