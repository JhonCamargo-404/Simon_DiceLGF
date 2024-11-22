%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

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
void realizar_operacion(const char* operacion, const char* var1, const char* var2);
Variable* buscar_variable(const char* nombre);
int yylex(void);

void yyerror(const char* msg) {
    fprintf(stderr, "Error de sintaxis: %s\n", msg);
}
%}

%union {
    char* text;
}

%token <text> SIMON_DICE NUMERO DECIMAL PALABRA BOOLEANO IMPRIMIR IMPRIMIR_TEXTO
%token <text> SUMA RESTA MULTIPLICA DIVIDE MODULO
%token PUNTO_COMA FIN_LINEA
%type <text> declaracion impresion impresion_texto operacion

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
    | operacion
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
        char* content = strdup($2 + 1); 
        content[strlen(content) - 1] = '\0'; 
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

// Operaciones Aritméticas
operacion:
    SIMON_DICE SUMA { 
        char var1[50], var2[50];
        sscanf($2, "%[^,], %s", var1, var2);
        realizar_operacion("suma", var1, var2); 
    }
    | SIMON_DICE RESTA { 
        char var1[50], var2[50];
        sscanf($2, "%[^,], %s", var1, var2);
        realizar_operacion("resta", var1, var2); 
    }
    | SIMON_DICE MULTIPLICA { 
        char var1[50], var2[50];
        sscanf($2, "%[^,], %s", var1, var2);
        realizar_operacion("multiplica", var1, var2); 
    }
    | SIMON_DICE DIVIDE { 
        char var1[50], var2[50];
        sscanf($2, "%[^,], %s", var1, var2);
        realizar_operacion("divide", var1, var2); 
    }
    | SIMON_DICE MODULO { 
        char var1[50], var2[50];
        sscanf($2, "%[^,], %s", var1, var2);
        realizar_operacion("modulo", var1, var2); 
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

Variable* buscar_variable(const char* nombre) {
    for (int i = 0; i < var_count; i++) {
        if (strcmp(variables[i].nombre, nombre) == 0) {
            return &variables[i];
        }
    }
    return NULL;
}

void imprimir_texto(const char* texto) {
    printf("Imprimiendo texto: %s\n", texto);
}

void imprimir_variable(const char* nombre) {
    Variable* var = buscar_variable(nombre);
    if (var) {
        printf("Imprimiendo variable '%s': %s\n", nombre, var->valor);
    } else {
        printf("Error: Variable '%s' no encontrada.\n", nombre);
    }
}

void realizar_operacion(const char* operacion, const char* var1, const char* var2) {
    Variable* v1 = buscar_variable(var1);
    Variable* v2 = buscar_variable(var2);

    if (!v1 || !v2) {
        printf("Error: Una o ambas variables no existen.\n");
        return;
    }

    double valor1 = atof(v1->valor);
    double valor2 = atof(v2->valor);

    if (strcmp(operacion, "modulo") == 0 && (strcmp(v1->tipo, "numero") != 0 || strcmp(v2->tipo, "numero") != 0)) {
        printf("Error: El módulo solo puede aplicarse a números enteros.\n");
        return;
    }

    double resultado = 0;
    if (strcmp(operacion, "suma") == 0) {
        resultado = valor1 + valor2;
    } else if (strcmp(operacion, "resta") == 0) {
        resultado = valor1 - valor2;
    } else if (strcmp(operacion, "multiplica") == 0) {
        resultado = valor1 * valor2;
    } else if (strcmp(operacion, "divide") == 0) {
        if (valor2 == 0) {
            printf("Error: División por cero.\n");
            return;
        }
        resultado = valor1 / valor2;
    } else if (strcmp(operacion, "modulo") == 0) {
        resultado = (int)valor1 % (int)valor2;
    }

    printf("Resultado de la %s entre %s y %s: %.2f\n", operacion, var1, var2, resultado);
}

// Punto de entrada principal
int main() {
    return yyparse();
}
