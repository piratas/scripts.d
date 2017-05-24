#/bin/bash
## Comentar linhas a serem ignoradas com uma # simples
## Linhas com ## dupla são comentários

## Selecionar domínios
DOMINIOS=( \
#"movimentopirata.xyz" \
"partidopirata.org" \
#"partidopirata.xyz" \
#"piratas.xyz" \
#"pirata.xyz" \
)

## Selecionar subdomínios
SUBDOMINIOS=( \
"entwickler" \
#"42" \
"404" \
"502" \
"503" \
"775" \
"781" \
#"ad" \
#"adhocracy" \
"anapirata" \
#"apoiar" \
#"apoiar-dev" \
"apoio" \
#"apoio-dev" \
#"assembleia" \
#"assembleia2014" \
#"assembleia2016" \
"biblioteca" \
#"blog" \
#"crowdfunding" \
#"dev" \
"embarque" \
#"faq" \
"ftp" \
#"financiamento" \
"git" \
"github" \
"gtc" \
"gti" \
"hub" \
#"imap" \
"iniciativa" \
#"irc" \
"iuf" \
"ipfs" \
#"lf" \
#"liquidfeedback" \
#"listas" \
"loomio" \
#"mail" \
#"membros" \
#"midia" \
"mg" \
"mumble" \
#"mx" \
#"nao" \
#"nao-dev" \
"noosfero" \
#"ns" \
#"pad" \
#"radio" \
#"rede" \
#"rs" \
"rio" \
#"rj" \
#"sac" \
"saopaulo" \
#"sim" \
#"site" \
#"smtp" \
#"status" \
"social" \
"sul" \
#"taiga" \
#"teste" \
"tesouraria" \
"torrent" \
"transparencia" \
#"trello" \
"wiki" \
"www" \
"zeronet" \
)

## TODO: Usar webroot, pra não precisar parar o servidor web
CERTBOT_MODO="certonly"

## Selecionar porta para tls-sni-01 (aparentemente só funciona 443 e 80, daí a necessidade de parar o servidor web)
CERTBOT_PORTA="443"

## Conta para gerar certificados
CERTBOT_CONTA="admin@partidopirata.org"

## Parâmetros
CERTBOT_OPCOES=(
"--standalone" \
"--standalone-supported-challenges tls-sni-01" \
"--tls-sni-01-port ${CERTBOT_PORTA}" \
#"--agree-tos" \
#"--keep-until-expiring" \
"--allow-subset-of-names"
#"--no-self-upgrade" \
"--email ${CERTBOT_CONTA}" \
)

## Não deveria ser necessário alterar daqui pra frente
sudo systemctl -l stop nginx.service
for DOMINIO in ${DOMINIOS[@]}
do
sudo certbot "${CERTBOT_MODO}" "${CERTBOT_OPCOES}" -d "${DOMINIO}" $(for SUBDOMINIO in ${SUBDOMINIOS[@]}; do echo -n " -d ${SUBDOMINIO}.${DOMINIO}"; done)
done
sudo systemctl -l start nginx.service

