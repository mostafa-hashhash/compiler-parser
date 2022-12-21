%{ 
    #include <stdio.h>
    #include <stdlib.h>
    #include "y.tab.h"        // obtained from yacc file
    
    int yyerror(char *errorMsg);
    void success(char *successMsg);
%}

%%
"print" return (PRINT);
"and"|"assert"|"break"|"class"|"def"|"del" return (KEYWORD);
"except"|"exec"|"finally"|"for"|"from"|"global" return (KEYWORD);
"import"|"in"|"is"|"lambda"|"not"|"or"|"pass"|"raise" return (KEYWORD);
"return"|"try"|"while"|"with"|"yield" return (KEYWORD);
"if" return (IF);
"else" return (ELSE);
"elif" return (ELIF);

[0-9]+                  return NUMBER;
[_a-zA-Z][_a-zA-Z0-9]*  return ID ;

[ \t]                   ;
[ \n]                   return (NEWLINE);
\=                      return (ASSIGN);
\+                      return (PLUS);
\-                      return (MINUS);
\*                      return (MUL);
\/                      return (DIVIDE);
\>                      return (GREATER);
\<                      return (LESSER);
\>=                     return (GREATER_EQUAL);
\<=                     return (LESSER_EQUAL);
\==                     return (EQUAL);
\!=                     return (NOT_EQUAL);
\:                      return (COLON);
\(                      return (LBRACKET);
\)                      return (RBRACKET);
\;                      return (SEMICOLON);
\"([^\"\n])*\"          return (STRING_DQ);
\'([^\'\n])*\'          return (STRING_SQ);  
.                       { printf("\nunidentified token %s\n", yytext);  exit(1); }

%%

int main() {
    printf("\n--------------------------- PYTHON EXPRESSION PARSER ---------------------------\n");
    printf("\nEnter a python expression : \n");
    yyparse();
    return 0;
}

void success(char *successMsg) {
    fprintf(stderr, "\n%s\n", successMsg);
}

int yyerror(char *errorMsg){
    fprintf(stderr, "\n%s\n", errorMsg);
}

int yywrap() {
  return 1;
}