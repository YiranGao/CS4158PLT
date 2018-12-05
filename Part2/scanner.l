%{

#include <string.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

int getSize(char* size);

%}


%option yylineno

%%

[\t ]+ ;		//space will not be recognized.
BEGINING 		{ return BEGINING;}	        
BODY    		{ return BODY;}
END      		{ return END;}
MOVE     		{ return MOVE;}
ADD      		{ return ADD;}
TO	 		{ return TO;}
INPUT    		{ return INPUT;}
PRINT			{ return PRINT;}   
";"                     { return SEMICOLON; }
\.                      { return TERMINATOR; }
[0-9]+                  { yylval.num = atoi(yytext); return INTEGER; }
[Xx]+                   { yylval.size = getSize(yytext); return VAR_SIZE; }
[A-Za-z][A-Za-z0-9\-]*  { yylval.name = malloc(sizeof(char*) * strlen(yytext)); strcpy(yylval.name, yytext); return VAR_NAME; }
\"(\\.|[^"\\])*\"       { return STRING; }
.                       { return INVALID; }

%%

int yywrap(void) {
    return 1;  
}

int getSize(char* size) {
    return strlen(size);
}
