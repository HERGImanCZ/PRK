%{
/* Variable declaration */
int lines_done=0;
int void_lines_done=0;
int lines_comment=0;
int add_ops=0;
int mpy_ops=0;
int fact_ops=0;
int left_bra=0;
int right_bra=0;
int dec_values=0;
int unit_values=0;
int hexa_values=0;
int sum_ops=0;
int errors_detected=0;

#include "ll.h"

int process_pattern(int number, char *Message);

%}
%%
^#.*\n  {lines_comment=process_pattern(lines_comment,"Comment deleted.\n");}
\+     {add_ops=process_pattern(add_ops,"Add operator detected.");}
\*     {mpy_ops=process_pattern(mpy_ops,"Multiplication operator detected.");}
\@     {fact_ops=process_pattern(fact_ops,"Factorial operator detected.");}
\(     {left_bra=process_pattern(left_bra,"Opening bracket detected.");}
\)     {right_bra=process_pattern(right_bra,"Closing bracket detected.");} 
sum\(.+\,.+\)   {sum_ops=process_pattern(sum_ops,"Sum operator detected.");}
0[Xx][0-9A-Z]+ {hexa_values=process_pattern(hexa_values,"Hexa number detected.");} 
[0-9]+ {dec_values=process_pattern(dec_values,"Int number detected.");}
[Oo]0+ {unit_values=process_pattern(unit_values,"Unit number detected.");}
^\n    {void_lines_done++;printf("Void line detected.\n");}
\n     {lines_done++;printf("Line detected.\n");}
.      {errors_detected=process_pattern(errors_detected,"An error detected.\n");}
%%

int yywrap(){};
int main()
    {
        yylex();
        printf("%d of total errors detected in input file.\n",errors_detected);
        printf("%d of int numbers detected.\n",dec_values);
        printf("%d of unit numbers detected.\n",unit_values);
        printf("%d of hexa numbers detected.\n",hexa_values);
        printf("%d of comment lines canceled.\n",lines_comment);
        printf("%d of add operators detected.\n",add_ops);
        printf("%d of sum operators detected.\n",sum_ops);
        printf("%d of factorial operators detected.\n",fact_ops);
        printf("%d of multiplication operators detected.\n",mpy_ops);
        printf("%d of opening brackets detected.\n",left_bra);
        printf("%d of closing brackets detected.\n",right_bra);
        printf("%d of void lines ignored.\nFile processed sucessfully.\n",void_lines_done);
        printf("Totally %d of valid code lines in file processed.\nFile processed sucessfully.\n",lines_done);
        
    }

int process_pattern(int number,char* Message) {
    #ifdef VERBOSE 
        printf("%s",Message);
    #endif
    number++;
    return number;
}
