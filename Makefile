.PHONY: install clean install-vim install-zsh
include params.mk
include $(shell uname -s | perl -ne 'print lc').mk

install: install-vim install-zsh

clean:
	rm -rf cache


#
# Vim
#
VIM_DEPS=
ifeq ($(VIM_JAVA),true)
VIM_DEPS += $(HOME)/.vim/eclim/plugin
endif

install-vim: $(HOME)/.vimrc

$(HOME)/.vimrc: $(HOME)/.vim/autoload/plug.vim $(foreach s,$(wildcard UltiSnips/*.snippets),$(HOME)/.vim/$(s)) $(VIM_DEPS) vimrc.mustache
	perl -Ivendor/experimental/lib -Ivendor/mustache-simple/lib -mMustache::Simple \
		-e 'use constant {true=>1, false=>0}; $$m=new Mustache::Simple(); print $$m->render("vimrc.mustache", {java=>$(VIM_JAVA), go=>$(VIM_GO), js=>$(VIM_JS), rust=>$(VIM_RUST), dotnet=>$(VIM_DOTNET)})' > $@
	vim --not-a-term +PlugInstall +qall
	rm -rf $(HOME)/.vim/plugged/papercolor-theme/autoload/airline

$(HOME)/.vim/autoload/plug.vim:
	curl -fLo $@ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

$(HOME)/.vim/UltiSnips/%.snippets: UltiSnips/%.snippets
	mkdir -p $(dir $@)
	cp $< $@

$(HOME)/.vim/eclim/plugin: cache/eclim.jar
	java -Dvim.files=$(HOME)/.vim -Declipse.home=$(ECLIPSE_HOME) -jar cache/eclim.jar install

cache/eclim.jar:
	curl -fLo $@ --create-dirs https://github.com/ervandew/eclim/releases/download/2.6.0/eclim_2.6.0.jar


#
# zsh
#
install-zsh: $(HOME)/.zshrc

$(HOME)/.zshrc: $(HOME)/.zsh/antigen.zsh zshrc
	cp zshrc $@
	zsh -c "source $@"

$(HOME)/.zsh/antigen.zsh:
	curl -fLo $@ --create-dirs https://github.com/zsh-users/antigen/releases/download/v1.2.1/antigen.zsh
