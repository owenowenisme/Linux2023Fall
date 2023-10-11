#!/bin/bash

search_dir="compressed_files"

strings_file="student_id"

> wrong_list
> missing_list
rm -rf compressed_files/rar/*
rm -rf compressed_files/tar.gz/*
rm -rf compressed_files/zip/*
rm -rf compressed_files/unknown/*
i = 0
while read -r string; do
    ((i++))
    matching_files=$(find "$search_dir" -type f -name "${string}*" -print)
    
    if [ -n "$matching_files" ]; then
    echo -n "$i $matching_files: "
        parts=$(echo "$matching_files" | awk -F"/" '{print $2}')
        echo "$parts" | while read -r part; do
            stu_id=$(echo "$part" | awk -F"." '{print $1}')
            file_ext=$(echo "$part" | awk -F"." '{print $2}')
            if [ "$file_ext" == "rar" ];then
                unrar e "$matching_files" compressed_files/rar > /dev/null 2>&1
                echo "Stored in Folder rar"
            elif [ "$file_ext" == "zip" ];then 
                unzip  "$matching_files" -d compressed_files/zip > /dev/null 2>&1
                echo "Stored in Folder zip"
            elif [ "$file_ext" == "tar" ]; then
                tar -xzvf "$matching_files" -C compressed_files/tar.gz > /dev/null 2>&1
                echo "Stored in Folder tar.gz"
            else
                echo "$stu_id">>wrong_list
                cp "$matching_files" compressed_files/unknown
                echo "Wrong file! Stored in Folder unknown"
            fi
        done
    else
        echo "$string" >> missing_list
        echo "$i $string File not found!"
    fi
done < "$strings_file"
