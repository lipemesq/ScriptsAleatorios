#!/bin/bash

#LOG_PATH=~/nobackup/log-firewall
#TIPOS_PATH=~/nobackup/tipos-bloqueios

NOME_HOJE=$(date +%Y-%m-%d)

#1: Percorre o arquivo e separa somente o campo que contém o nome do erro
#2: ordena para poder usar o uniq
#3: unifica as ocorrências e conta o número de cada uma
#4: FORMATAÇÃO - retira os espaços inicias deixados pelo uniq
#5: manda para o temporário "teste"
#cut -f 6 -d' ' log-firewall | sort | uniq -c | sed -e 's/^[ \t]*//' > teste
> ERROS_${NOME_HOJE}
awk -v outf="ERROS_${NOME_HOJE}" '{c[$6]++} END {
	for (line in c) { 
		if (c[line] > 20000) {
			print line, c[line] >> outf
		} 
		print line, c[line] }}' log-firewall | sort > erros-log-firewall_${NOME_HOJE}

if [ -s ERROS_${NOME_HOJE} ]
then 
	#sendmail flm17@dinf.ufpr.br  < ERROS_${NOME_HOJE}
	echo "AGORA TEM QUE MANDAR EMAIL" 
	cat ERROS_${NOME_HOJE} 
fi

awk 'FNR==NR{a[$1]=$2; next}{if (a[$1]) print $1, a[$1]; else print $1, "0"}' \
	erros-log-firewall_${NOME_HOJE} tiposFinal.txt > log-firewall_${NOME_HOJE} 

if [ $1 -eq 1 ] 
then
	column -t log-firewall_${NOME_HOJE} >> aux_${NOME_HOJE}.tmp
	mv aux_${NOME_HOJE}.tmp log-firewall_${NOME_HOJE}
fi

echo -e "\n"'********* V6 *********'
grep V6 < log-firewall_${NOME_HOJE} 
echo -e "\n"'********* V4 *********' 
grep -v V6 < log-firewall_${NOME_HOJE} 
