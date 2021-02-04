#!/bin/bash

data_fold=$(date +%Y'-'%m'-'%d)
hour_fold=$(date +%Y'-'%m'-'%d'_'%H)
currentdate=$(date +%Y'-'%m'-'%d'_'%H':'%M':'%S)

mkdir -p ./user_and_temp/$data_fold/$hour_fold
touch ./user_and_temp/$data_fold/$hour_fold/cpu_$currentdate.txt
txt_path="./user_and_temp/$data_fold/$hour_fold/cpu_$currentdate.txt"

CPU0=`sensors  coretemp-isa-0000 | tail -n +4 | tr -s " " | awk -F [øC+] '{print $1$3}'`
CPU1=`sensors  coretemp-isa-0001 | tail -n +4 | tr -s " " | awk -F [øC+] '{print $1$3}'`
temp_zone0=`cat /sys/class/thermal/thermal_zone0/temp`
temp_zone1=`cat /sys/class/thermal/thermal_zone1/temp`

echo "cpu temperature" >> $txt_path
max0=0.0
        for i in $CPU0;do
		# echo $i >> cpu_temp.txt
                if [ ${i%.*} -gt ${max0%.*} ];then
            		max0=$i
                fi
        done
echo "max0" >> $txt_path
echo ${max0%.*} >> $txt_path

echo " ">> $txt_path
max1=0.0
        for j in $CPU1;do
		# echo $j >> cpu_temp.txt
                if [ ${j%.*} -gt ${max1%.*} ];then
            		max1=$j
                fi
        done
echo "max1" >> $txt_path
echo ${max1%.*} >> $txt_path

echo " " >> $txt_path
echo "Package id 0:"  >> $txt_path
echo ${temp_zone0%000} >> $txt_path
echo "Package id 1:" >> $txt_path
echo ${temp_zone1%000} >> $txt_path
echo " " >> $txt_path
echo "##################" >> $txt_path
echo " " >> $txt_path

echo "Online users" >> $txt_path
w | while read line
do
echo $line >> $txt_path
done
echo "%%%%%%%%%%%%%%%%%%%%%%" >> $txt_path
echo " " >> $txt_path

echo "Memory Usage" >> $txt_path
pick_mem=30

./find_the_bitch.sh | tail -n +3  | while read line
do
echo $line >> $txt_path

if [ $(echo $line | awk '{print $1}') != "Binary" ];then
	first_char=$(echo $line | awk '{print $1}')
	if [ ${first_char%.*} -gt $pick_mem ];then
		user_name=$(echo $line | awk '{print $2}')
		if [ $user_name != "root" ];then
			echo $user_name
			killall -u $user_name

		fi
	fi
fi

done
echo "##################" >> $txt_path
echo " " >> $txt_path

echo "parallel processes" >> $txt_path
ps aux|awk '{a[$1]++}END{for (b in a)print a[b],b}' | sort -rn | while read line
do
echo $line >> $txt_path
done

echo "##################" >> $txt_path
echo " " >> $txt_path

echo "GPU usage" >> $txt_path
nvidia-smi | awk 'NR==9,NR==10{print}' >> $txt_path
nvidia-smi | awk 'NR==13,NR==14{print}' >> $txt_path
nvidia-smi | awk 'NR==17,NR==18{print}' >> $txt_path
nvidia-smi | awk 'NR==21,NR==22{print}' >> $txt_path


