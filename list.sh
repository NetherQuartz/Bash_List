#!/bin/bash

function create_list() {
	local a=1
	while [[ $next != nil ]]
	do
		local file=part_$a
		local prev=
		if [[ $((a-1)) -lt 1 ]]
		then
			prev=nil
		else
			prev=$((a-1))
		fi

		local next=
		if [[ $a -eq 3 ]]
		then
			next=nil
		else
			next=$((a+1))
		fi

		echo $prev > $file
		local value=
		read -r value
		echo $value >> $file
		echo $next >> $file
		echo >> $file
		((a++))
	done
	echo 1 > list
	echo $((a-1)) >> list
}

function read_list() {
	local start=
	local end=
	for i in {1..2}
	do
		if [[ i -eq 1 ]]
		then
			read -r start
		else
			read -r end
		fi
	done < list
	local cur=$start
	local prev=
	local value=
	local next=
	while [[ $((0)) ]]
	do
		local file=part_$cur
		for i in {1..3}
		do
			case $i in
				1)
					read -r prev
					;;
				2)
					read -r value
					;;
				3)
					read -r next
					;;
			esac
		done < $file
		printf "%s " $value
		if [[ $next != "nil" ]]
		then
			cur=$next
		else
			echo
			break
		fi
	done
}

PS3="Выберите действие: "
select el in Создать Просмотреть Удалить Выйти
do
	case $el in
		"Создать")
			create_list
			;;
		"Просмотреть")
			if [[ $(ls list) ]]
			then
				read_list
			fi
			;;
		"Удалить")
			rm -f part_* list
			;;
		"Выйти")
			exit
			;;
	esac
done
