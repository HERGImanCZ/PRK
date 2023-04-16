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
extern int yylineno, yylval;

%}

%token PLUS
%token MULTI
%token FACTOR
%token SUM
%token LEFT_BR
%token RIGHT_BR
%token COMMA
%token HEXA
%token INT
%token UNIT
%token LINE_END

%%
HergiLang:
    HergiLang vyraz LINE_END { printf("Syntax OK, Rule1\n"); } //Rule1
    | vyraz LINE_END { printf("Syntax OK, Rule2\n");} //Rule2
    ;

vyraz:
    term vyraz1 {printf("Rule3\n");} //Rule3
    ;

vyraz1:
    PLUS term vyraz1 {printf("Rule4\n");} //Rule4
    | {printf("Rule5\n");} //Rule5
    ;

term:
    vyber term1 {printf("Rule6\n");} //Rule6
    ;

term1:
    MULTI vyber term1 {printf("Rule7\n");} //Rule7
    | {printf("Rule8\n");} //Rule8
    ;

vyber:
    vyber1 unarend {printf("Rule9\n");} //Rule9
    ;

vyber1:
    LEFT_BR vyraz RIGHT_BR {printf("Rule10\n");} //Rule10
    | SUM vyraz COMMA vyraz RIGHT_BR {printf("Rule11\n");} //Rule11
    | INT {printf("Rule12\n");} //Rule12
    | HEXA {printf("Rule13\n");} //Rule13
    | UNIT {printf("Rule14\n");} //Rule14
    ;

unarend:
    FACTOR {printf("Rule15\n");} //Rule15
    | {printf("Rule16\n");} //Rule16
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