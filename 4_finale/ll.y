%{
/*
HergiLang=vyraz;

vyraz=term, vyraz1;
vyraz1="+",term,vyraz1|;
term=vyber, term1;
term1="*", vyber, term1|;
vyber=vyber1,unarend;
vyber1="(", vyraz , ")" | "sum(",vyraz,",",vyraz,")" | cislo | startHexa, cisloHexa | startJedn, cisloJedn;
cislo=decimal , {decimal};
decimal = "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"0";
cisloHexa = hexa , {hexa};
hexa = "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"0"|"A"|"B"|"C"|"D"|"E"|"F";
startHexa = "0x" | "0X";
cisloJedn = jedn, {jedn};
jedn = "0";
startJedn = "O" | "o";
unarend = "@"|;
*/

#include <stdio.h>
//#include "prk-stack.h"
//#include "prints.h"

int yylex();
void yyerror(const char *s);
extern int yylineno;

int calc_sum(int x, int n);
int calc_fact(int x);
//extern int yylineno, yylval;

%}

%union {
    int integer;
}

%token PLUS
%token MULTI
%token FACTOR
%token SUM
%token LEFT_BR
%token RIGHT_BR
%token COMMA
%token<integer> HEXA
%token<integer> INT
%token<integer> UNIT
%token LINE_END

%type <integer> HergiLang vyraz vyraz1 term term1 vyber vyber1 unarend

%%
//DONE
HergiLang:
    HergiLang vyraz LINE_END { 
        printf("Syntax OK, Rule1\n");
        printf("Result: %d\n", $2);
    } //Rule1
    | vyraz LINE_END { 
        printf("Syntax OK, Rule2\n");
        printf("Result: %d\n", $1);
    } //Rule2
    ;

vyraz:
    term vyraz1 {
        printf("Rule3\n");
        $$ = $1 + $2;
    } //Rule3
    ;

vyraz1:
    PLUS term vyraz1 {
        printf("Rule4\n");
        $$ = $2 + $3;
    } //Rule4
    | {
        printf("Rule5\n");
        $$ = 0;
    } //Rule5
    ;

term:
    vyber term1 {
        printf("Rule6\n");
        $$ = $1 * $2;
    } //Rule6
    ;

term1:
    MULTI vyber term1 {
        printf("Rule7\n");
        $$ = $2 * $3;
    } //Rule7
    | {
        printf("Rule8\n");
        $$ = 1;
    } //Rule8
    ;

//DONE
vyber:
    vyber1 unarend {
        printf("Rule9\n");
        if($2 == 1){
            $$ = calc_fact($1);
        }
        else{
            $$ = $1;
        }
    } //Rule9
    ;

//DONE
vyber1:
    LEFT_BR vyraz RIGHT_BR {
        printf("Rule10\n");
        $$ = $2;
    } //Rule10
    | SUM vyraz COMMA vyraz RIGHT_BR {
        printf("Rule11\n");
        $$ = calc_sum($2, $4);
    } //Rule11
    | HEXA {
        printf("Rule12\n");
        $$ = $1;
    } //Rule12
    | INT {
        printf("Rule13\n");
        $$ = $1;
    } //Rule13
    | UNIT {
        printf("Rule14\n");
        $$ = $1;
    } //Rule14
    ;

//DONE
unarend:
    FACTOR {
        printf("Rule15\n");
        $$=1;
    } //Rule15
    | {
        printf("Rule16\n");
        $$=0;
    } //Rule16
    ;

%%

void yyerror(const char* s) {   
    printf("%s\n",s);
}

int main(){
    // yydebug = 1;
    //debug_print("Entering the main");
    printf("Entering the main\n");
    yyparse();   
}

int calc_sum(int x, int n){
    int res = 0;
    int i;
    for(i = 0; i < n; i++){
        res += x;
    }
    return res;
}

int calc_fact(int x){
    int res = 1;
    int i;
    for(i = 0; i<x; i++){
        res *= i;
    }
    return res; 
}