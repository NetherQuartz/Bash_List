#!/bin/bash

function create_list {
	local len=
	printf "Введите длину списка: "
	read -r len
	echo "Вводите элементы построчно:"
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
		if [[ $a -eq len ]]
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
	echo 1 > list         # начало списка
	echo $((a-1)) >> list # конец списка
	echo $len >> list     # максимальный номер части
}

function read_list {
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

function insert {
	local start=
	local end=
	local max=

	local new_val=
	printf "Введите значение: "
	read -r new_val

	for i in {1..3}
	do
		if [[ i -eq 1 ]]
		then
			read -r start
		elif [[ i -eq 2 ]]
		then
			read -r end
		else
			read -r max
		fi
	done < list

	local cur=$start
	local prev=
	local value=
	local next=
	printf "Введите позицию (от 1): "
	local pos=
	read -r pos

	if (($(ls -l part_* | wc -l) + 1 == pos && pos > 0))
	then
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
		done < part_$end

		((max++))

		echo $prev > part_$end
		echo $value >> part_$end
		echo $max >> part_$end
		echo >> part_$end
		
		echo $end > part_$max
		echo $new_val >> part_$max
		echo nil >> part_$max
		echo >> part_$max

		echo $start > list
		echo $max >> list
		echo $max >> list
		
		return

	elif ((pos == 1))
	then
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
		done < part_$start
		((max++))
		echo $max > part_$start
		echo $value >> part_$start
		echo $next >> part_$start
		echo >> part_$start

		echo nil > part_$max
		echo $new_val >> part_$max
		echo $start >> part_$max
		echo >> part_$max

		echo $max > list
		echo $end >> list
		echo $max >> list

		return
	elif ((pos < 1 || pos > $(ls -l part_* | wc -l) + 1))
	then
		echo "Неверный индекс!"
		return
	fi

	local c=0
	local new_prev=
	local new_next=
	while [[ c -lt pos ]]
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

		new_prev=$prev
		new_next=$cur

		if [[ $next != "nil" ]]
		then
			cur=$next
		fi
		((c++))
	done

	((max++))

	local np_prev=
	local np_value=
	local np_next=
	local nn_prev=
	local nn_value=
	local nn_next=

	for i in {1..3}
		do
			case $i in
				1)
					read -r np_prev
					;;
				2)
					read -r np_value
					;;
				3)
					read -r np_next
					;;
			esac
		done < part_$new_prev

	for i in {1..3}
		do
			case $i in
				1)
					read -r nn_prev
					;;
				2)
					read -r nn_value
					;;
				3)
					read -r nn_next
					;;
			esac
		done < part_$new_next

		echo $np_prev > part_$new_prev
		echo $np_value >> part_$new_prev
		echo $max >> part_$new_prev
		echo >> part_$new_prev
		
		echo $max > part_$new_next
		echo $nn_value >> part_$new_next
		echo $nn_next >> part_$new_next
		echo >> part_$new_next
		
		echo $new_prev > part_$max
		echo $new_val >> part_$max
		echo $new_next >> part_$max

		echo $start > list
		echo $end >> list
		echo $max >> list
}

PS3="Выберите действие: "
select el in Создать Вставить Удалить Просмотреть Очистить Выйти
do
	case $el in
		"Создать")
			rm -f part_* list
			create_list
			;;
		"Просмотреть")
			if [[ $(ls list) ]]
			then
				read_list
			fi
			;;
		"Очистить")
			rm -f part_* list
			;;
		"Выйти")
			exit
			;;
		"Вставить")
			insert
			;;
		"Удалить")
			delete
			;;
	esac
done
