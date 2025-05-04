#!/bin/bash
clear
rm -rf *.yy.c *.tab.c *.tab.h
yacc -d q1.y
lex q1.l
gcc lex.yy.c y.tab.c -o o
./o < ip1.txt > op1.txt
cat op1.txt
./o <ip2.txt > op2.txt
echo "\n--------------------------------------------------------\n"
cat op2.txt
