%{
    #include <stdio.h>
    int yydebug=1;
    int yylex(void);

    int yyerror(char *errorMsg);
    void success(char *successMsg);
%}

// tokens
%token ID NUMBER STRING_DQ STRING_SQ
%token ASSIGN PLUS MINUS MUL DIVIDE LBRACKET RBRACKET SEMICOLON NEWLINE GREATER LESSER GREATER_EQUAL LESSER_EQUAL EQUAL NOT_EQUAL
%token PRINT KEYWORD
%token IF ELSE ELIF COLON

// set precedence
%right ASSIGN
%left PLUS MINUS
%left MUL DIVIDE

%%

/* Parser Grammar */

start: stmt NEWLINE {
            success("This is a valid python expression");
            YYACCEPT; 
        }
        
        | stmt SEMICOLON {
            success("This is a valid python expression");
            YYACCEPT; 
        }
    ;

stmt:  assign_arithmetic
    |  assign_str
    |  display
    |  branching
    ;

condition: identifier GREATER expr
    | identifier LESSER expr
    | identifier GREATER_EQUAL expr
    | identifier LESSER_EQUAL expr
    | identifier EQUAL expr
    | identifier NOT_EQUAL expr
    ;

/* TODO: group all the comparison operators into one token-name and use it as ( condition: identifier COMP expr ) */

branching: IF expr COLON NEWLINE stmt NEWLINE ELSE COLON NEWLINE stmt NEWLINE    // if else
    | IF expr COLON NEWLINE stmt NEWLINE ELIF expr COLON NEWLINE stmt NEWLINE ELSE COLON NEWLINE stmt NEWLINE   // if elif else
    | IF expr COLON NEWLINE stmt NEWLINE ELIF expr COLON NEWLINE stmt NEWLINE             // if elif
    | IF expr COLON NEWLINE stmt NEWLINE                                                  // if
    ;
    

identifier: ID | keyword { 
            yyerror("\nkeyword can't be used as a identifier\n"); 
            YYABORT; 
        }
    ;
        
keyword: PRINT | KEYWORD
    ;
    
assign_str:  identifier ASSIGN strings
    ;

display: PRINT strings
    | PRINT strings MUL NUMBER
    | PRINT strings PLUS strings
    | PRINT expr
    ;
    
strings: STRING_DQ | STRING_SQ
    ;

assign_arithmetic: identifier ASSIGN expr
    ;

expr: expr PLUS expr        // a =  3 + 4
    | expr MINUS expr      // a = 3 - 4
    | expr MUL expr       // a = 3 * 4
    | expr DIVIDE expr
    | identifier          // a = x
    | NUMBER                  // a = 3 
    | LBRACKET expr RBRACKET   // (3 + 4)
    | SIGN identifier       // a = -x
    | SIGN NUMBER          // a = -3
    | condition
    ;

SIGN: PLUS
    | MINUS
    ;

%%