#!/bin/bash

#echo "entrant al programa"
#while true; do
#	read -n 1 key
# if [[ $key == "q" || $key == "Q" ]]; then
#	if [[ $key == "q" ]]; then
#	echo "Sortint de l'aplicació"
#	exit 0 
#	fi 
#done

#Exercici 1

echo "Entrant al programa"
opcio='x'
codi_pais="XX"
estat_pais="XX"
codi_estat="XX"
poblacio="XX"
codi_pais_anterior="XX"
codi_estat_anterior="XX"

while [ $opcio != q ]; do
	read opcio

	case $opcio in
		 'q')
			echo "Sortint de l'aplicacio"
			exit 0
			;;
	#Exercici 2
		'lp')
		 echo "Country_Code Country_Name"
		 cut -d',' -f7,8 cities.csv | uniq
		 #sork7,2 cities.ksv
		 ;;


	#Exercici 3

		'sc')
		read -p "Introdueix el nom del païs: " nom_pais
		codi_pais=$(awk -F',' -v nombre="$nom_pais" '$8 == nombre {print $7}' cities.csv | uniq)

		if [ -z "$nom_pais" ]; then
	        	codi_pais=$codi_pais_anterior
		else
			codi_pais_anterior=$codi_pais
		fi
			
		;;


	#Exercici 4

		'se')
		if [ -z $nom_pais ];then
			echo "No s'ha seleccionat cap país"
		else
			read -p "Introdueix l'estat del païs: " estat_pais
			codi_estat=$(awk -F',' -v nombre="$estat_pais" '$5 == nombre {print $4}' cities.csv | uniq)
			
		fi

		if [ -z $estat_pais ]; then
			codi_estat=$codi_estat_anterior
			
		else
			codi_estat_anterior=$codi_estat
		fi
		;;

	#Exercici 5 

		'le')
		#res=$(awk -F',' -v codi_pais="$codi_pais" '$7 == codi_pais {print $5}' cities.csv)
		if [ -z $nom_pais ]; then
                        echo "No s'ha seleccionat cap país"
                else
			awk -F',' -v codi_pais="$codi_pais" '$7 == codi_pais {print $5}' cities.csv | uniq
		fi
		;;


	#Exercici 6

		'lcp')
		#res=$(awk -F',' -v codi_pais="$codi_pais" '$7 == codi_pais {print $2, $11}' cities.csv)
		if [ -z $nom_pais ]; then
			echo "No s'ha seleccionat cap país"
		else
			awk -F',' -v codi_pais="$codi_pais" '$7 == codi_pais {print $2, $11}' cities.csv
		fi
		;;

	
	#Exercici 7

		'ecp')
		#res=$(awk -F',' -v codi_pais="$codi_pais" '$7 == codi_pais {print $2, $11}' cities.csv)
		if [ -z $nom_pais ]; then
                        echo "No s'ha seleccionat cap país"
                else
			touch $codi_pais.csv	
			awk -F',' -v codi_pais="$codi_pais" '$7 == codi_pais {print $2, $11}' cities.csv > $codi_pais.csv	
		fi
		;;

	
	
	#Exercici 8 i 9
		'lce')
		
		#res=$(awk -F',' -v codi_estat="$codi_estat" -v codi_pais="$codi_pais" '$4 == codi_estat {print $2, $11}' cities.csv)
		if [ -z $nom_pais ]; then
                        echo "No s'ha seleccionat cap país"
		else 
			if [ -z $estat_pais ]; then
				echo "No s'ha seleccionat cap estat"

                	else
				touch $codi_pais_$codi_estat.csv
				awk -F',' -v codi_estat="$codi_estat" '$4 == codi_estat {print $2, $11}' cities.csv
                		awk -F',' -v codi_estat="$codi_estat" '$4 == codi_pais {print $2, $11}' cities.csv > ${codi_pais}_${codi_estat}.csv
		
			fi
		fi
		;;


	#Exercici 10
		'gwd')
		read -p "Introdueix una població: " poblacio
		wdid=$(awk -F',' -v codi_estat="$codi_estat" -v codi_pais="$codi_pais" -v poblacio="$poblacio" '{if ($7 == codi_pais && $4 == codi_estat && $2 == poblacio                ) print $11}' cities.csv | uniq) 
		if [ -z $wdid ]; then
			echo "Selecioni previament l'estat"
		else 
			curl https://www.wikidata.org/wiki/Special:EntityData/$wdid.json > $wdid.json
			echo "S'ha guardat a $wdid.json"
		fi
		;;	

	#Exercici 11
	'estadistica')
		awk -F',' 'BEGIN {c1=0.0;c2=0.0;c3=0.0;c4=0.0;c5=0.0;c6=0.0} { if ( NR > 0) {c1+=($9>0);c2+=($9<0);c3+=($10>0);c4+=($10<0);c5+=($9==0);c6+=($11=="")} } END {print "NORD " c1; print "SUD " c2; print "EST " c3; print "OEST " c4; print "Sense Ubicació " c5; print "Sense Wikidata " c6}' cities.csv	
		;;
		*)
		echo "Opció no valida"
		;;	
	esac

done					
