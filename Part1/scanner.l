%{

#include <string.h>
#include <stdlib.h>

void printCurrentToken(char*, int);
%}

%%

[\t ]+ ;		//space will not be recognized.
BEGINING |	        
BODY     |          
END      |          
MOVE     |         
ADD      |  
TO	 |       
INPUT    |      
PRINT     		{ printf("current %s is a valid KEYWORD\n", yytext); }      
[Xx]+                   { printNum("Current INTEGER INPUT is", yytext); }
;                       { printf("Current %s is a SEMICOLON\n", yytext); }
\.                      { printf("Current %s is a TERMINATOR\n", yytext); }
[A-Za-z][A-Za-z0-9\-]*  { printf("Current %s is an IDENTIFIER\n", yytext);}
\"(\\.|[^"\\])*\"       { printf("Current %s is a STRING\n", yytext); }
[0-9]+                  { printf("Current %s is an INTEGER\n", yytext); }
.                       { printf("Current %s is an Invalid Syntax\n", yytext); }

%%

int main(){
    yylex();
}

void printNum(char* str, char* yytext){
	long int num = 9;
	int length = strlen(yytext);
	for(int i=1;i<length;i++)
	{
		num = (num * 10) + 9;
	}
	//printf(" num = %d. yytext = %s, size = %d.\n",num,yytext,size);
    	printf("%s: %s , total size is: %d, number range in: 0 - %ld\n", str, yytext, length, num);
}
