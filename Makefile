#
# COMP30023 Computer Systems Project 1
# Ibrahim Athir Saleem (isaleem) (682989)
#
# Makefile
#

CC = gcc
CFLAGS = -Wall -Wextra -std=gnu99

OBJ = main.o argparse.o process.o proc_creator.o linked_list.o disk.o memory.o round_robin_queue.o
EXE = swap

VALGRIND_OPTS = -v --leak-check=full

## Top level target is executable.
$(EXE): $(OBJ)
	$(CC) $(CFLAGS) -o $(EXE) $(OBJ)

## Clean: Remove object files and core dump files.
clean:
	rm -f $(OBJ)

## Clobber: Performs Clean and removes executable file.
clobber: clean
	rm -f $(EXE)

## Run
run: $(EXE)
	./$(EXE) -f testdata/testFirst1 -a first -m 1000 -q 7

## Test
test: $(EXE)
	./$(EXE) -f testdata/input.txt -a first -m 1000 -q 7 | diff - testdata/output.txt
	./$(EXE) -f testdata/testFirst1 -a first -m 1000 -q 7 | diff - testdata/testFirst1.out
	./$(EXE) -f testdata/testBest1 -a best -m 1000 -q 7 | diff - testdata/testBest1.out
	./$(EXE) -f testdata/testWorst1 -a worst -m 1000 -q 7 | diff - testdata/testWorst1.out

## Valgrind
valgrind: $(EXE)
	valgrind $(VALGRIND_OPTS) --log-file=valgrind.1.log ./$(EXE) -f testdata/input.txt -a first -m 1000 -q 7
	valgrind $(VALGRIND_OPTS) --log-file=valgrind.2.log ./$(EXE) -f testdata/testFirst1 -a first -m 1000 -q 7
	valgrind $(VALGRIND_OPTS) --log-file=valgrind.3.log ./$(EXE) -f testdata/testBest1 -a best -m 1000 -q 7
	valgrind $(VALGRIND_OPTS) --log-file=valgrind.4.log ./$(EXE) -f testdata/testWorst1 -a worst -m 1000 -q 7

%.o: %.c.pyf
	./pyfect $< | $(CC) $(CFLAGS) -x c -c -o $@ -

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

## Dependencies
main.o: argparse.h process.h proc_creator.h linked_list.h disk.h memory.h round_robin_queue.h
argparse.o: argparse.h
process.o: process.h
proc_creator.o: proc_creator.h process.h
linked_list.o: linked_list.h
disk.o: disk.h process.h linked_list.h
memory.o: memory.h process.h linked_list.h
round_robin_queue.o: round_robin_queue.h process.h linked_list.h
