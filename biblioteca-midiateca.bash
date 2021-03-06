#!/bin/bash
## Adiciona arquivos da biblioteca pirata na midiateca pirata
## Rodando na crontab do usuário mediagoblin@entwickler.partidopirata.org diariamente

BIBLIOTECA_DIR="/var/lib/mediagoblin/mediagoblin/user_dev/media/public/media_entries"
MIDIATECA_DIR="/var/lib/mediagoblin/git/midiateca"

pushd ${MIDIATECA_DIR}
git pull origin master
rsync -avhP ${BIBLIOTECA_DIR}/ biblioteca/
git add biblioteca
git commit -am "Atualizando arquivos da biblioteca"
git push origin master
rm -rf biblioteca/*
popd

