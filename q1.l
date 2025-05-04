%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include "y.tab.h"
%}

%%
"if" { 
    yylval.ch=strdup(yytext);
    // printf("IF -- %s\n",yylval.ch);
    return IF;

}
"else" { 
    yylval.ch=strdup(yytext);
    // printf("ELSE -- %s\n",yylval.ch);
    return ELSE;

}
"while" { 
    yylval.ch=strdup(yytext);
    // printf("WHILE -- %s\n",yylval.ch);
    return WHILE;

}
"BcsMain" { 
    yylval.ch=strdup(yytext);
    // printf("BCSMAIN -- %s\n",yylval.ch);
    return BcsMain;

}
"int" { 
    yylval.ch=strdup(yytext);
    // printf("INT -- %s\n",yylval.ch);
    return INT;

}
"bool" { 
    yylval.ch=strdup(yytext);
    // printf("BOOL -- %s\n",yylval.ch);
    return BOOL;

}
[a-zA-Z][a-zA-Z0-9]* { 
    yylval.ch=strdup(yytext);
    // printf("ID -- %s\n",yylval.ch);
    return id;

}
[0-9]+ { 
    yylval.i=atoi(yytext);
    // printf("NUM -- %s\n",yylval.ch);
    return num;

}
"<"|">"|"<="|">="|"=="|"!=" { 
    yylval.ch=strdup(yytext);
    // printf("RELOP -- %s\n",yylval.ch);
    return relop;

}
[(|)|{|}|;|=|+|*] { 
    yylval.ch=strdup(yytext);
    // printf("PUNCTUATOR -- %s\n",yylval.ch);
    return *yytext;

}
\n {}
. {}
%%

int yywrap(){ 

    return 1;

}