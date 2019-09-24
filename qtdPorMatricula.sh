#/bin/bash	

for d in $(ls | grep ^CI); do			# Percorre as disciplinas ofertadas
	for a in $(seq 1988 2002); do		# Percorre os anos
		for s in $(seq 1 2); do			# Percorre os semestres
			
			# Pega todos os cursos que fizeram aquela disciplina naquele ano/semestre e guarda em um temporário C
			CUR=$(cat ${d}\/${a}${s}.dados | grep -v curso | awk -F ':' '{print $1}')
			echo ${CUR} | sort -u >> tempC_${d}_${a}${s}_.txt
			
			# Pra cada curso em C, conta o número de matrículas naquela disciplina e salva em M
			for t in $(cat tempC_${d}_${a}${s}_.txt); do
				echo ${CUR} | grep ${t} | wc -l >> tempM_${d}_${a}${s}_.txt
			done
			
		done
	done
	
	echo -n "_____  " >> E${d}.txt
	cat tempC_${d}* | sort -u |  tr '\n' "_" | sed "s=_=__=g" >> E${d}.txt
	echo "\n" >> E${d}.txt
	
	CURSOS="$(cat tempC_${d}* | sort -u)"
	
	for c in $(ls | grep tempM_${d} | sort); do
		ANO="$(echo ${c} | awk -F '_' '{print $3}')"
		echo ${ANO} | tr '\n' "_" | sed "s=_=  =g" >> E${d}.txt
		
		NN=1
		for atual in ${CURSOS}; do

			OP="$(cat tempC_${d}_${ANO}* | grep ${atual} | wc -c)"
			if [ ${OP} -eq 0 ]; then
		   	echo -n "00__" >> E${d}.txt
		   else
		   	printf "%2d" "$(cat ${c} | head -n ${NN} | tail -n+${NN} | tr -d '\n')" >> E${d}.txt
		   	echo -n "__" >> E${d}.txt
				NN=$((NN+1))
		   fi
		
		done

		echo "" >> E${d}.txt
	done
	
done
rm temp*
