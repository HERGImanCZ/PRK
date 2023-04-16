MAKE=make
GCC=gcc

FILENAME=ll
PRINT_OUTPUT="y"

PARSER_BIN="ll_parser"

ROOT_DIR=$(shell pwd)
INCDIR=$(ROOT_DIR)/inc
INCFILES=$(wildcard $(INCDIR)/*.c)
#LIBOBJS = $(wildcard $(LIBDIR)/*.o)
#LIBNAMES = $(shell basename -s ".o" $(LIBOBJS))
#LIBS = $(addprefix -l, $(LIBNAMES))

BINDIR="./bin"
TESTDIR="./testfiles"
TEST_OK_FILE="test_ok.txt"
TEST_ERRORS_FILE="test_errors.txt"

.PHONY: parser test_ok test_errors subclean clean all

all: clean parser test_ok test_errors
	@if [ $(PRINT_OUTPUT) ]; then cat $(BINDIR)/$(TEST_OK_FILE).report; fi
	@if [ $(PRINT_OUTPUT) ]; then cat $(BINDIR)/$(TEST_ERRORS_FILE).report; fi


test:
	echo $(ROOT_DIR)
	echo $(LIBOBJS)
	echo $(LIBNAMES)
	echo $(LIBS)


parser:
	yacc -d $(FILENAME).y
	flex $(FILENAME).lex
	$(GCC) -o $(PARSER_BIN) lex.yy.c y.tab.c -ly
	@mv $(PARSER_BIN) $(BINDIR)/
#	@make -s subclean

test_ok:
	@./$(BINDIR)/$(PARSER_BIN) < $(TESTDIR)/$(TEST_OK_FILE) >$(BINDIR)/$(TEST_OK_FILE).report
test_errors:
	@./$(BINDIR)/$(PARSER_BIN) < $(TESTDIR)/$(TEST_ERRORS_FILE) >$(BINDIR)/$(TEST_ERRORS_FILE).report

subclean:
	@rm -rf lex.yy.c
	@rm -rf y.tab.h y.tab.c

clean: subclean
	@rm -rf $(BINDIR)/*