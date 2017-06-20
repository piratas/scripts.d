#!/bin/bash
##
## Rotina de backup não eficiente de sites do partidopirata.org
## Rodar somente como root, afim de preservar as permissões e dono/grupo dos arquivos
##
## Para sincronizar localmente os backups no servidor, é necessário ter um usuário incluído no grupo `backup-local`. A partir daí é possível usar o rsync desta forma:
## rsync -avhzPe 'ssh -p 4242' usuario@enwtickler.partidopirata.org:/home/backups/tars/*.xz .
## Substitua o ponto '.' pelo diretório local alvo se necessário.
##
## Para extrair corretamente, é necessário ser root, por exemplo:
## sudo tar -xf backup_partidopirata.org_1478368834.tar.xz
##

##
## Diretório onde backups são armazenados no entwickler
## Permissoẽs:
## drwxr-xr-x 2 root backup-local 4096 Nov  5 19:08 tars
##
BACKUP_BASE_DIR="/home/backups/tars"

##
## Lista de nomes dos sites para usar nos nomes de arquivos tar
## E lista de diretórios absolutos onde se encontram os arquivos para backup
## Aviso: manter consistentes e alinhadas estas duas listas.
## Se isto se tornar tedioso, portar este script para perl ou python.
##
SITES_NOMES=( \
"partidopirata.org" \
"anapirata.partidopirata.org" \
"gtc.partidopirata.xyz" \
"saopaulo.partidopirata.org" \
"mg.movimentopirata.xyz" \
"biblioteca.partidopirata.org" \
#"moodle.escolapirata.org" \
"social.pirata.xyz" \
#"naofode.xyz" \
#"nao.usem.xyz" \
#"nfde.xyz" \
"mumble.conf" \
"ssh.conf" \
"tor.conf" \
"onion.conf" \
"php-fpm.conf" \
)
SITES_CAMINHOS=( \
## partidopirata.org
"/home/wordpress/www" \
## anapirata.partidopirata.org
"/home/wordpress/anapirata" \
## gtc.partidopirata.xyz
"/home/wordpress/gtc" \
## saopaulo.partidopirata.org
"/home/wordpress/saopaulo" \
## mg.movimentopirata.xyz
"/var/www/www/wp/mg.movimentopirata.xyz" \
## biblioteca.partidopirata.org
"/home/biblioteca/mediagoblin" \
## moodle.escolapirata.org
#"/home/moodle/moodle.escolapirata.org" \
## social.pirata.xyz
"/var/www/git/social.pirata.xyz/file" \
## naofode.xyz
#"/home/naofode/naofode.xyz" \
## nao.usem.xyz
#"/home/naofode/nao.usem.xyz" \
## nfde.xyz
#"/home/naofode/nfde.xyz" \
## mumble.conf
"/etc/mumble-server.ini" \
## ssh.conf
"/etc/ssh" \
## tor.conf
"/etc/tor" \
## onion.conf
"/var/lib/tor" \
## php-fpm.conf
"/var/php/fpm/pool.d" \
)

##
## Daqui pra baixo provavelmente não precisa alterar nada.
## Quem for tentar "melhorar" esta parte, leia antes (até o fim):
## http://tldp.org/LDP/abs/html/index.html
##
## Se o script fosse em python, isto seria desnecessário
if [ ${#SITES_NOMES[@]} -eq ${#SITES_CAMINHOS[@]} ]
then
	if [ -d "${BACKUP_BASE_DIR}" ]
	then
	        pushd "${BACKUP_BASE_DIR}"
	        for SITE in $(seq 0 1 $(expr ${#SITES_NOMES[@]} - 1))
	        do
	                mkdir -p "${BACKUP_BASE_DIR}/tmp/${SITES_NOMES[SITE]}"
	                rsync -avvhP "${SITES_CAMINHOS[SITE]}/" "${BACKUP_BASE_DIR}/tmp/${SITES_NOMES[SITE]}/"
	                XZ_OPT=-e9 ionice -c 2 -n 7 nice -n 19 tar -cvpSJ -f "${BACKUP_BASE_DIR}/backup_${SITES_NOMES[SITE]}_$(date +%s).tar.xz" -C "${BACKUP_BASE_DIR}/tmp/" "${SITES_NOMES[SITE]}"
	                rm -r "${BACKUP_BASE_DIR}/tmp/${SITES_NOMES[SITE]}"
	        done
	        popd
	else
		echo "O diretório ${BACKUP_BASE_DIR} não existe."
	fi
else
        echo "Leia a documentação do script antes de fazer merda."
fi

