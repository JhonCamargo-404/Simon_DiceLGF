%{
#include "syntactic.tab.h"
#include <string.h>

int yylineno; 
%}

%%
[sS]imon[ ]+dice             { return SIMON_DICE; }

numero[ ]+[a-zA-Z_][a-zA-Z0-9_]*[ ]*=[ ]*[0-9]+ { 
                                yylval.text = strdup(yytext); 
                                return NUMERO; 
                             }
decimal[ ]+[a-zA-Z_][a-zA-Z0-9_]*[ ]*=[ ]*[0-9]+\.[0-9]+ { 
                                yylval.text = strdup(yytext); 
                                return DECIMAL; 
                             }
palabra[ ]+[a-zA-Z_][a-zA-Z0-9_]*[ ]*=[ ]*\"[^\"]*\" { 
                                yylval.text = strdup(yytext); 
                                return PALABRA; 
                             }
booleano[ ]+[a-zA-Z_][a-zA-Z0-9_]*[ ]*=[ ]*(verdadero|falso) { 
                                yylval.text = strdup(yytext); 
                                return BOOLEANO; 
                             }
imprimirT[ ]*\([ ]*\"([^\"]*)\"[ ]*\) { 
                                char* start = strchr(yytext, '(') + 2; 
                                char* end = strrchr(yytext, ')') - 1;
                                size_t length = end - start + 1;
                                yylval.text = strndup(start, length);
                                return IMPRIMIR_TEXTO; 
                             }
imprimir[ ]*\([ ]*[a-zA-Z_][a-zA-Z0-9_]*[ ]*\) { 
                                char* start = strchr(yytext, '(') + 1; 
                                char* end = strrchr(yytext, ')');
                                size_t length = end - start;
                                yylval.text = strndup(start, length);
                                return IMPRIMIR; 
                             }
suma[ ]*\([ ]*[a-zA-Z_][a-zA-Z0-9_]*,[ ]*[a-zA-Z_][a-zA-Z0-9_]*[ ]*\) { 
                                char* start = strchr(yytext, '(') + 1; 
                                char* end = strrchr(yytext, ')');
                                yylval.text = strndup(start, end - start);
                                return SUMA; 
                             }
resta[ ]*\([ ]*[a-zA-Z_][a-zA-Z0-9_]*,[ ]*[a-zA-Z_][a-zA-Z0-9_]*[ ]*\) { 
                                char* start = strchr(yytext, '(') + 1; 
                                char* end = strrchr(yytext, ')');
                                yylval.text = strndup(start, end - start);
                                return RESTA; 
                             }
multiplica[ ]*\([ ]*[a-zA-Z_][a-zA-Z0-9_]*,[ ]*[a-zA-Z_][a-zA-Z0-9_]*[ ]*\) { 
                                char* start = strchr(yytext, '(') + 1; 
                                char* end = strrchr(yytext, ')');
                                yylval.text = strndup(start, end - start);
                                return MULTIPLICA; 
                             }
divide[ ]*\([ ]*[a-zA-Z_][a-zA-Z0-9_]*,[ ]*[a-zA-Z_][a-zA-Z0-9_]*[ ]*\) { 
                                char* start = strchr(yytext, '(') + 1; 
                                char* end = strrchr(yytext, ')');
                                yylval.text = strndup(start, end - start);
                                return DIVIDE; 
                             }
modulo[ ]*\([ ]*[a-zA-Z_][a-zA-Z0-9_]*,[ ]*[a-zA-Z_][a-zA-Z0-9_]*[ ]*\) { 
                                char* start = strchr(yytext, '(') + 1; 
                                char* end = strrchr(yytext, ')');
                                yylval.text = strndup(start, end - start);
                                return MODULO; 
                             }
;                           { return PUNTO_COMA; } 
\n                          { } 
[ \t]+                      { } 

.                           { printf("Carácter no reconocido: %s en línea %d\n", yytext, yylineno); }

%%

int yywrap() { 
    return 1; 
}
