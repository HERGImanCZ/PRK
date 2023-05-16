%{
/* Variable declaration */
int lines_done=0;
int void_lines_done=0;
int lines_comment=0;

int plus=0;
int multiply=0;
int factorial=0;
int sum_ops=0;
int leftbr=0;
int rightbr=0;
int comma = 0;

int hexa_values=0;
int integer_value=0;
int unit_values=0;

int errors_detected=0;

#include "ll.h"
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>

int process_pattern(int number, char *Message, int Pattern);
void print_error(int ERRNO);
void print_msg(char *msg);
int hex_to_int(char* hex);
int unit_to_int(char* expr);


%}
%%
^#.*\n  {lines_comment=process_pattern(lines_comment,"Comment deleted.\n",PATT_NO);}
\+      {plus=process_pattern(plus,"Add operator detected.",PATT_PLUS);
            return PLUS;
        }
\*      {multiply=process_pattern(multiply,"Multiplication operator detected.",PATT_MULTI);
            return MULTI;
        }
\!      {factorial=process_pattern(factorial,"Factorial operator detected.",PATT_FACTOR);
            return FACTOR;
        }
"sum"\(   {sum_ops=process_pattern(sum_ops,"Sum operator detected.",PATT_SUM);
            return SUM;
        }
\(      {leftbr=process_pattern(leftbr,"Opening bracket detected.",PATT_LEFT_BR);
            return LEFT_BR;
        }
\)      {rightbr=process_pattern(rightbr,"Closing bracket detected.",PATT_RIGHT_BR);
            return RIGHT_BR;
        } 
\,      {comma=process_pattern(comma,"Comma detected.",PATT_COMMA);
            return COMMA;
        }
0[xX][0-9a-fA-F]+ {hexa_values=process_pattern(hexa_values,"Hexa number detected.",PATT_HEXA);
            yylval.integer = hex_to_int(yytext);
            return HEXA;
        }
[0-9]+  {integer_value=process_pattern(integer_value,"Int number detected.",PATT_INT);
            yylval.integer = atoi(yytext);
            return INT;
        }
[Oo][0]+  {unit_values=process_pattern(unit_values,"Unit number detected.",PATT_UNIT);
            yylval.integer = unit_to_int(yytext);
            return UNIT;
        }
^\n     {void_lines_done++;        
            print_msg("Void line detected.\n");
        }       
\n      {lines_done++;
            print_msg("Line detected.\n");
            return LINE_END;
        }

[ \t]+ ; /*Skip whitespace*/

.      {errors_detected=process_pattern(errors_detected,"An error detected.\n",PATT_ERR);} /* What is not from alphabet: lexer error  */

%%

int yywrap(void) {
return 1;
}
/*int main()
    {
        yylex();
        printf("%d of total errors detected in input file.\n",errors_detected);
        printf("%d of int numbers detected.\n",integer_value);
        printf("%d of unit numbers detected.\n",unit_values);
        printf("%d of hexa numbers detected.\n",hexa_values);
        printf("%d of comment lines canceled.\n",lines_comment);
        printf("%d of add operators detected.\n",plus);
        printf("%d of sum operators detected.\n",sum_ops);
        printf("%d of factorial operators detected.\n",factorial);
        printf("%d of multiplication operators detected.\n",multiply);
        printf("%d of opening brackets detected.\n",leftbr);
        printf("%d of closing brackets detected.\n",rightbr);
        printf("%d of void lines ignored.\nFile processed sucessfully.\n",void_lines_done);
        printf("Totally %d of valid code lines in file processed.\nFile processed sucessfully.\n",lines_done);
        
    }*/

void print_msg(char *msg){
    #ifdef VERBOSE
        printf("%s",msg);
    #endif
}

void print_error(int ERRNO){
    #ifdef VERBOSE
        char *message = Err_Messages[ERRNO];
        printf("%s - %d - %s\n\n",ErrMsgMain,ERR_PATTERN,message);
    #endif
}

int process_pattern(int number,char* Message, int Pattern) {
    if (Pattern == PATT_ERR) {       
        print_error(ERR_PATTERN);        
        //exit(ERR_PATTERN);
    }    

    print_msg(Message);
    //printf("%s",Message);
    
    number++;
    return number;
}

int hex_to_int(char* hex) {
    int result = 0;
    int i = 0;

    // Ignorování případného prefixu "0x" nebo "0X"
    if (hex[0] == '0' && (hex[1] == 'x' || hex[1] == 'X'))
        i = 2;

    // Konverze hexadecimálního čísla na integer
    for (; hex[i] != '\0'; i++) {
        result = result * 16;

        if (hex[i] >= '0' && hex[i] <= '9')
            result += hex[i] - '0';
        else if (hex[i] >= 'a' && hex[i] <= 'f')
            result += hex[i] - 'a' + 10;
        else if (hex[i] >= 'A' && hex[i] <= 'F')
            result += hex[i] - 'A' + 10;
        else {
            printf("Chybný vstup!\n");
            return 0;
        }
    }

    return result;
}

int unit_to_int(char* expr) {
    int count = 0;
    int i = 0;

    // Ignorování případného prefixu "o" nebo "O"
    if (expr[0] == 'o' || expr[0] == 'O')
        i = 1;

    // Počítání nul v zbytku výrazu
    while (expr[i] != '\0') {
        if (expr[i] == '0')
            count++;
        else
            break;

        i++;
    }

    return count;
}
