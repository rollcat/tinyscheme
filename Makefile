FEATURES ?= -DSUN_DL=1 -DUSE_DL=1 -DUSE_MATH=1 -DUSE_ASCII_NAMES=1

CC = musl-gcc
AR = ar crs

INCS = -I.
LIBS = -ldl -lm

ifeq (${DEBUG},1)
OPT_FLAGS = -g -Og
else
OPT_FLAGS = -Os
endif

CPPFLAGS = ${FEATURES}
CFLAGS   = -std=gnu11  -fpic -Wall -Wextra -Wpedantic -Werror -Wfatal-errors \
           ${OPT_FLAGS} ${INCS} ${CPPFLAGS}
LDFLAGS  = -static -s ${LIBS}

SCM = ${shell find . -name "*.scm"}
SRC = dynload.c scheme.c
HDR = dynload.h opdefines.h scheme-private.h scheme.h
OBJ = ${SRC:.c=.o}

all: options libtinyscheme.so libtinyscheme.a scheme

test: scheme
	./scheme -1 test.scm

autofmt:
	astyle \
		--mode=c --style=java --unpad-paren --pad-header \
		--pad-oper --delete-empty-lines --break-blocks \
		--align-pointer=name --indent-labels --indent-preproc-define \
		--indent-preproc-cond --indent-col1-comments --convert-tabs \
		--max-code-length=72 --lineend=linux \
		-R "*.c" "*.h"
	emacs --script indent-scm.el -f main ${SCM}

options:
	@echo tinyscheme build options
	@echo "CFLAGS  = ${CFLAGS}"
	@echo "LDFLAGS = ${LDFLAGS}"
	@echo "CC      = ${CC}"

clean:
	@rm -f *.o *.so *.a *.ilk *.map *.pdb *.exp *~ TAGS

tags: TAGS
TAGS: ${SRC} ${HDR}
	etags ${SRC} ${HDR}

%.o: %.c ${HDR}
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

libtinyscheme.so: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

scheme: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

libtinyscheme.a: ${OBJS}
	@echo AR -o $@
	@${AR} $@ ${OBJS}

.PHONY: all test autofmt options clean tags
print-%: ; @echo $*=$($*)
