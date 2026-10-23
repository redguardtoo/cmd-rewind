# -*- Makefile -*-
SHELL = /bin/sh
EMACS ?= emacs

.PHONY: clean test compile

EMACS_BATCH_OPTS=--batch -Q \
-L . \
-l cmd-rewind.el

RM = @rm -rf

clean:
	$(RM) *~
	$(RM) \#*\#
	$(RM) *.elc

compile:
	$(RM) *.elc
	@$(EMACS) $(EMACS_BATCH_OPTS) -l tests/my-byte-compile.el 2>&1 | grep -E "([Ee]rror):" && exit 1 || exit 0

test: compile
	@$(EMACS) $(EMACS_BATCH_OPTS) -l tests/cmd-rewind-tests.el
