#!/bin/bash

set -e

# Utility functions

## For ease of iterative experimentation
doo () {
    $@
    # echo $@
}

# This function was originally named errm to be short for "error message", but
# then I realized that it sounds like a person saying, "Errm, excuse me, I don't
# think that's what you meant to do."
errm () {
    2>&1 echo -e "$@"
}

# START HERE.
main () {
    cd $HOME
    confirm_no_clobber
    confirm_have_goodies
    for i in ${DOTS[@]}; do
        link_dot $i
    done
    # TODO: Make sure permissions are legit. .ssh and .ghci, I'm lookin at you.
}

# Subroutines
confirm_no_clobber() {
    NOTADOT=''

    for i in ${DOTS[@]}; do
        if [ ! -L $i -a -e $i ]; then
            NOTADOT="${NOTADOT}$i "
        fi
    done

    if [ -n "$NOTADOT" ]; then
        errm "\n  ABORT"
        errm "\n  These exist but are not symlinks:"
        errm "    $NOTADOT"
        exit 2
    fi
}

confirm_have_goodies() {
    NOFINDINGS=''

    if [ ! -e "$EXPORT_DIR" ]; then
        errm "\n  ABORT\n\n  Where ya gonna copy them files from again?"
        errm "    Couldn't find export dir: '$EXPORT_DIR'"
        exit 2
    fi

    for i in ${DOTS[@]}; do
        goody="$EXPORT_DIR/$i"
        # Exists, is readable?
        if [ ! -r "$goody" ]; then
            NOFINDINGS="${NOFINDINGS}$i"
        # Searchable if directory?
        elif [ -d "$goody" -a ! -x "$goody" ]; then
            NOFINDINGS="${NOFINDINGS}$i"
        fi
    done

    if [ -n "$NOFINDINGS" ]; then
        errm "\n  ABORT\n\n  These goodies don't exist in a state we can use!"
        errm "    $NOFINDINGS"
        exit 2
    fi
}

link_dot() {
    dot=$1
    doo rm -f $dot
    doo ln -s $EXPORT_DIR/$dot .
}

# Initialize globals
EXPORT_DIR=$(dirname "${PWD}/$0")
DOTS=(
    .ackrc
    .bash_aliases
    .bashrc
    .cvsignore
    .cvsrc
    .dircolors
    .emacs.d
    .ghci
    .gitconfig
    .goobookrc
    .inputrc
    .irssi
    .mailcap
    .mutt
    .muttrc
    .ncmpcpp
    .nethackrc
    .newsbeuter
    .offlineimap
    .offlineimaprc
    .tmux
    .tmux.conf
    .toprc
    .vim
    .vimrc
)

# Fire missiles
main
