

PLATFORM=linux

#environment
INC_PATH=./include
SRC_PATH=./src
RES_PATH=./res
HEADER:=$(wildcard $(INC_PATH)/*.h)

#compiler
CC=gcc
CXX=g++
LD=ld
STRIP=strip
AR=ar rcs
RM=rm -rf
MKDIR=mkdir -p
CFLAGS:=-I$(INC_PATH) -O2

#target
TARGET:=./lib/libframework.a 
TARGET+=./lib/libautomated.a
TARGET+=./lib/libbasic.a
TARGET+=./lib/libconsole.a

ifeq ($(PLATFORM), linux) 
	TARGET+=./lib/libcurses.a
else ifeq ($(PLATFORM), windows)
	TARGET+=./lib/libwin.a
else
	$(error "only support linux and windows")
endif

obj-framework :=./src/CUError.o ./src/MyMem.o ./src/TestDB.o ./src/TestRun.o ./src/Util.o
obj-automated :=./src/Automated.o ./src/AutomatedTest.o
obj-console := ./src/Console.o ./src/ConsoleTest.o
obj-basic := ./src/Basic.o ./src/BasicTest.o
obj-win := ./src/Win.o ./src/WinTest.o
obj-curses := ./src/Curses.o ./src/CursesTest.o

obj-all += $(obj-framework)
obj-all += $(obj-automated)
obj-all += $(obj-console)
obj-all += $(obj-basic)
obj-all += $(obj-win)
obj-all += $(obj-curses)


default : prepare_dir $(TARGET)

prepare_dir : lib

lib:
	$(MKDIR) lib

./lib/libframework.a : $(obj-framework)
	$(AR) $@ $^

./lib/libautomated.a : $(obj-automated)
	$(AR) $@ $^

./lib/libbasic.a : $(obj-basic)
	$(AR) $@ $^

./lib/libcurses.a : $(obj-curses)
	$(AR) $@ $^

./lib/libwin.a : $(obj-win)
	$(AR) $@ $^

./lib/libconsole.a : $(obj-console)
	$(AR) $@ $^

%.o:%.c $(HEADER)
	$(CC) -c -o $@ $< $(CFLAGS)

./src/WinTest.o:./src/WinTest.cpp $(HEADER)
	$(CXX) -c -o $@ $< $(CFLAGS)

clean:
	$(RM) $(TARGET)
	$(RM) $(obj-all)
info:
	@echo "HEADER = $(HEADER)"

.PHONY : info clean
