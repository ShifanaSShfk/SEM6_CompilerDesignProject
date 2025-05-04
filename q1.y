%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    extern int yylex();
    void yyerror(char const *s);
    int t=1,l=1;
    struct node{
        char code[500];
        char addr[10];
        char t[10];
        char f[10];
    };
    typedef struct node* node;
    node create(char* addr){
        node n=(node)malloc(sizeof(struct node));
        strcpy(n->addr,addr);
        return n;
    }
    char var[10];
    char* temp(){
        sprintf(var,"t%d",t);
        t++;
        return var;
    }
    char* label(){
        sprintf(var,"L%d",l);
        l++;
        return var;
    }
    void shift(const char *input, char *output) {
        *output++='\t';
        while (*input) {
            if (input == output || *(input - 1) == '\n') {
                *output++ = '\t';  // Add tab at the start of a line
            }
            *output++ = *input++;
        }
        *output = '\0';  // Null-terminate the output string
    }
%}

%union{
    char *ch;
    int i;
    struct node* node;
} 


%type <node> start declist decl type stmtlist stmt expr aexpr term factor

%token <ch> BcsMain IF ELSE WHILE INT BOOL id relop
%token <i> num

%left '+'
%left '*'

%%
start:BcsMain'{'declist stmtlist'}' {
    printf("%s",$4->code);
};
declist: declist decl|decl {

};
decl: type id ';' {

};
type: INT {

}| BOOL{
    
};
stmtlist : stmtlist ';' stmt {
    $$=create("stmt");
    snprintf($$->code,2000,"%s\n%s",$1->code,$3->code);
}| stmt {
    $$=create("stmt");
    strcpy($$->code,$1->code);
};
stmt: id'='aexpr {
    $$=create($1);
    char s[100];
    snprintf(s,2000,"%s%s%s",$1,"=",$3->addr);
    snprintf($$->code,2000,"%s%s\n",$3->code,s);
}| IF'('expr')''{'stmtlist'}'ELSE'{'stmtlist'}' {
    $$=create("if-else");
    char* lt=label();
    char op1[1024],op2[1024];
    shift($6->code,op1);
    shift($10->code,op2);
    snprintf($$->code,4000,"%s\n%s:\n%s\n\tgoto %s\n%s:\n%s\n%s:\n",$3->code,$3->t,op1,lt,$3->f,op2,lt);
}| WHILE'('expr')''{'stmtlist'}' {
    $$=create("while");
    char* loop=label();
    char op[1024];
    shift($6->code,op);
    snprintf($$->code,4000,"%s:\n%s\n%s:\n%s\n\tgoto %s\n%s:\n",loop,$3->code,$3->t,op,loop,$3->f);
};
expr: aexpr relop aexpr {
    $$=create(temp());
    strcpy($$->t,label());
    strcpy($$->f,label());
    snprintf($$->code,2000,"%s%sif %s%s%s goto %s\ngoto %s\n",$1->code,$3->code,$1->addr,$2,$3->addr,$$->t,$$->f);
}| aexpr {
    $$=create($1->addr);
    strcpy($$->code,$1->code);
};
aexpr: aexpr'+'aexpr {
    $$=create(temp());
    char s[100];
    snprintf(s,100,"%s%s%s%s%s",$$->addr,"=",$1->addr,"+",$3->addr);
    snprintf($$->code,2000,"%s%s%s\n",$1->code,$3->code,s);
}| term {
    $$=create($1->addr);
    strcpy($$->code,$1->code);
};
term: term'*'factor {
    $$=create(temp());
    char s[100];
    snprintf(s,100,"%s%s%s%s%s",$$->addr,"=",$1->addr,"*",$3->addr);
    snprintf($$->code,2000,"%s%s%s\n",$1->code,$3->code,s);
}| factor{
    $$=create($1->addr);
    strcpy($$->code,$1->code);
};
factor: id{
    $$=create($1);
    strcpy($$->code,"");
}| num{
    char v[10];
    sprintf(v,"%d",$1);
    $$=create(v);
    strcpy($$->code,"");
};
%%

void yyerror(char const *s){
    printf("%s",s);
}

int main(){
    yyparse();
    return 0;
}