%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

typedef struct {
	   char* name;
	   int size;
	} Var;

extern int yylineno;
extern int yylex();
extern int yyparse();

int listIndex = 0;
Var variableList[128] = {};

void pushNewVariable(int size, char *name);
bool checkVariable(char *name);
void checkDuplicated(char *name);
void checkADD(char *name, char *name1);
void checkADDNUM(int num, char *name);
void moveNumberToVariable(int num, char *name);
void moveVariableToVariable(char *name, char *name1);
void yyerror(char *s);

%}

%union {
	int size;
	char *name;
	int num;
} 
%token BEGINING
%token BODY
%token PRINT
%token INPUT
%token MOVE
%token ADD
%token TO
%token END
%token SEMICOLON
%token INVALIDNAME
%token STRING
%token TERMINATOR
%token INVALID
%token <size> VAR_SIZE
%token <num> INTEGER
%token <name> VAR_NAME
%start jibuc

%%


jibuc		: BEGINING TERMINATOR body_program ending_program 	{;}
                ;

body_program    : declaration_program            			{;}
                | body_program body_Statement  	 			{;}
                | body_Statement          	 			{;}
                | body_program declaration_program   			{;}
                ;

body_Statement  : BODY TERMINATOR foreach_line      			{;}
                | BODY TERMINATOR          	 			{;}
                ;

foreach_line    :PRINT printvar TERMINATOR               		{;}
                |INPUT input_Statement TERMINATOR        		{;}
                |MOVE movement_program TERMINATOR               	{;}
                |ADD add_Statement TERMINATOR            		{;}
                |foreach_line PRINT printvar TERMINATOR          	{;}
                |foreach_line INPUT input_Statement TERMINATOR   	{;}
                |foreach_line MOVE movement_program TERMINATOR          {;}
                |foreach_line ADD add_Statement TERMINATOR       	{;} 
                ;

declaration_program :VAR_SIZE VAR_NAME TERMINATOR {pushNewVariable($1, $2);}
                ;

input_Statement  :VAR_NAME                            {checkDuplicated($1);}
                |VAR_NAME SEMICOLON input_Statement   {checkDuplicated($1);}
                ;

add_Statement    :VAR_NAME TO VAR_NAME     		 {checkADD($1, $3);}
                |INTEGER TO VAR_NAME		      {checkADDNUM($1, $3);}
                ;

movement_program :INTEGER TO VAR_NAME 	     {moveNumberToVariable($1, $3);}
                |VAR_NAME TO VAR_NAME      {moveVariableToVariable($1, $3);}
                ;


printvar        :STRING                     				 {;}
                |VAR_NAME                    	      {checkDuplicated($1);}
                |STRING SEMICOLON printvar  				 {;}
                |VAR_NAME SEMICOLON printvar          {checkDuplicated($1);}
                ;

ending_program  : END TERMINATOR 		 		  {exit(0);}
                ;

%%

int getIndex(char *name) {
    for(int i = 0; i < 128; i++) {
        if(strcmp(variableList[i].name, name)==0) { 
            return i;
        }
    }
}

void pushNewVariable(int size, char *name) { 
    if(checkVariable(name) == false) {
        Var newVariable;
        newVariable.size = size;
        newVariable.name = name;
        variableList[listIndex] = newVariable;
	listIndex++;
    }
    else {
        printf("Line %d: Variable Already Exists\n", yylineno);
        exit(0);
    }
}

void moveNumberToVariable(int num, char *name) { ;
    if(checkVariable(name)) {
        int i = getIndex(name);
	int temp = num;
	int count = 0;
	if(num < 10){
		count++;
	}
	while(temp != 0){
	    temp/=10;
	    count++;
	}
        if(variableList[i].size < count){
            printf("Line %d: Variable is not equial to its length \n", yylineno);
        }
    } else {
        printf("Line %d: Variable havent defined!\n", yylineno);
        exit(0);
    }
} 

void moveVariableToVariable(char *name, char *name1) {
    if(checkVariable(name) && checkVariable(name1)) {
        int i = getIndex(name);
        int j = getIndex(name1);
        if(variableList[i].size > variableList[j].size) {
            printf("Line %d: Error ! move to a smaller size variable is not allowed\n", yylineno);
	    exit(0);    
        }
    } else {
        printf("Line %d: Variable havent defined!\n", yylineno);
        exit(0);
    }
}

bool checkVariable(char *name) {
   bool flag = false;
   for(int i = 0; i < 128; i++) {  
        if(variableList[i].name != NULL) {
            if(strcmp(variableList[i].name, name)==0) {
                flag = true;
		return flag;   
            }
        }
    }
    return flag;
}

void checkDuplicated(char *name) {
    if(checkVariable(name) == false) {
        printf("Line %d: Variable havent defined!\n", yylineno);
        exit(0);
    }
}

void checkADD(char *name, char *name1) {
    checkDuplicated(name);
    checkDuplicated(name1);
}

void checkADDNUM(int num, char *name) {
    	checkDuplicated(name);
    	int i = getIndex(name);
	int temp = num;
	int count = 0;
	if(num < 10){
		count++;
	}
	while(temp != 0){
	    temp/=10;
	    count++;
	}
    if(variableList[i].size < temp) {
        printf("Line %d: Variable is not equial to its length\n", yylineno);
    }

}

int main(void) {
    listIndex = 0;
    return yyparse();
}

void yyerror(char *s) {
    fprintf(stderr, "Line %d: %s\n", yylineno, s);
}


