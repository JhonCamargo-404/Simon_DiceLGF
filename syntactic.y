%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Estructura para almacenar variables
typedef struct {
    char* nombre;
    char* tipo;
    char* valor;
} Variable;

Variable variables[100];
int var_count = 0;

void agregar_variable(const char* tipo, const char* nombre, const char* valor);
void imprimir_texto(const char* texto);
void imprimir_variable(const char* nombre);
int yylex(void);

void yyerror(const char* msg) {
    fprintf(stderr, "Error de sintaxis: %s\n", msg);
}
%}

%union {
    char* text;
}

%token <text> SIMON_DICE NUMERO DECIMAL PALABRA BOOLEANO IMPRIMIR IMPRIMIR_TEXTO
%token PUNTO_COMA FIN_LINEA
%type <text> declaracion impresion impresion_texto

%%

// Regla inicial
programa:
    sentencias
    ;

// Regla para múltiples sentencias
sentencias:
    sentencias sentencia PUNTO_COMA
    | sentencia PUNTO_COMA
    ;

// Regla para una única sentencia
sentencia:
    declaracion
    | impresion
    | impresion_texto
    ;

// Declaración de variables
declaracion:
    SIMON_DICE NUMERO { 
        char tipo[50], nombre[50], valor[50];
        sscanf($2, "%s %s = %s", tipo, nombre, valor);
        agregar_variable("numero", nombre, valor); 
    }
    | SIMON_DICE DECIMAL { 
        char tipo[50], nombre[50], valor[50];
        sscanf($2, "%s %s = %s", tipo, nombre, valor);
        agregar_variable("decimal", nombre, valor); 
    }
    | SIMON_DICE PALABRA { 
        char tipo[50], nombre[50], valor[50];
        sscanf($2, "%s %s = \"%[^\"]\"", tipo, nombre, valor);
        agregar_variable("palabra", nombre, valor); 
    }
    | SIMON_DICE BOOLEANO { 
        char tipo[50], nombre[50], valor[50];
        sscanf($2, "%s %s = %s", tipo, nombre, valor);
        agregar_variable("booleano", nombre, valor); 
    }
    ;

// Impresión de texto
impresion_texto:
    SIMON_DICE IMPRIMIR_TEXTO { 
        char* content = strdup($2 + 1); // Extrae el texto sin la primera comilla
        content[strlen(content) - 1] = '\0'; // Quita la última comilla
        imprimir_texto(content);
        free(content);
    }
    ;

// Impresión de variables
impresion:
    SIMON_DICE IMPRIMIR { 
        imprimir_variable($2); 
    }
    ;

%%

// Implementación de las funciones de apoyo

void agregar_variable(const char* tipo, const char* nombre, const char* valor) {
    variables[var_count].nombre = strdup(nombre);
    variables[var_count].tipo = strdup(tipo);
    variables[var_count].valor = strdup(valor);
    var_count++;
    printf("Variable de tipo '%s' llamada '%s' almacenada con valor '%s'.\n", tipo, nombre, valor);
}

void imprimir_texto(const char* texto) {
    printf("Imprimiendo texto: %s\n", texto);
}

void imprimir_variable(const char* nombre) {
    for (int i = 0; i < var_count; i++) {
        if (strcmp(variables[i].nombre, nombre) == 0) {
            printf("Imprimiendo variable '%s': %s\n", nombre, variables[i].valor);
            return;
        }
    }
    printf("Error: Variable '%s' no encontrada.\n", nombre);
}

// Punto de entrada principal
int main() {
    return yyparse();
}
