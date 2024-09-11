#!/bin/bash

declare -A arrMahasiswa

# Initialize data
initMahasiswa() {
    arrMahasiswa[0,0]="Andi"
    arrMahasiswa[0,1]="Teknik Informatika"
    arrMahasiswa[0,2]=78
    
    arrMahasiswa[1,0]="Lutfi"
    arrMahasiswa[1,1]="Sistem Informasi"
    arrMahasiswa[1,2]=83

    arrMahasiswa[2,0]="Nadia"
    arrMahasiswa[2,1]="Teknik Elektro"
    arrMahasiswa[2,2]=88
}

# Display mahasiswa data
displayMahasiswa() {
    printf "%-7s %-20s %s\n" "Nama" "Jurusan" "Nilai"
    printf "%-7s %-20s %s\n" "----" "-------" "-----"
    
    # Calculate the number of students dynamically
    total_students=$(( ${#arrMahasiswa[@]} / 3 ))

    for (( i=0; i<total_students; i++ )); do
        printf "%-7s %-20s %s\n" "${arrMahasiswa[$i,0]}" "${arrMahasiswa[$i,1]}" "${arrMahasiswa[$i,2]}"
    done
}

# Display the completion of the update
displayKelulusan() {
    lulus=0
    tidak_lulus=0

    # Calculate the number of students dynamically
    total_students=$(( ${#arrMahasiswa[@]} / 3 ))

    for (( i=0; i<total_students; i++ )); do
        if [ ${arrMahasiswa[$i,2]} -ge 80 ]; then
            ((lulus++))
        else
            ((tidak_lulus++))
        fi
    done

    echo "Statistik Kelulusan: "
    printf "%-25s %s\n" "Jumlah Mahasiswa Lulus" "Jumlah Mahasiswa Tidak Lulus"
    printf "%-25s %s\n" "----------------------" "----------------------------"
    printf "%-25d %d\n" $lulus $tidak_lulus
}

# Update student data
updateMahasiswa() {
        if [[ $updateChoice == [Yy] ]]; then
            echo -n "Masukkan Nama Mahasiswa yang ingin dicari: "
            read -r searchName

            # Enable case-insensitive matching
            shopt -s nocasematch
            
            # Find the student index by name (case-insensitive)
            studentIndex=-1
            for (( i=0; i<total_students; i++ )); do
                if [[ "${arrMahasiswa[$i,0]}" == "$searchName" ]]; then
                    studentIndex=$i
                    break
                fi
            done
            
            # Disable case-insensitive matching
            shopt -u nocasematch

            if [[ $studentIndex -ne -1 ]]; then
                echo "Informasi Mahasiswa: "
                printf "%-7s %-20s %s\n" "Nama" "Jurusan" "Nilai"
                printf "%-7s %-20s %s\n" "-----" "-----" "-----"
                printf "%-7s %-20s %s\n" "${arrMahasiswa[$studentIndex,0]}" "${arrMahasiswa[$studentIndex,1]}" "${arrMahasiswa[$studentIndex,2]}"

                echo -n "Apakah ingin mengganti jurusan mahasiswa ini? (Y/N): "
                read -r changeChoice

                if [[ $changeChoice == [Yy] ]]; then
                    echo -n "Masukkan Jurusan Baru: "
                    read -r newJurusan

                    # Update the department
                    arrMahasiswa[$studentIndex,1]="$newJurusan"

                    echo "Jurusan telah diupdate. Data Mahasiswa terbaru:"
                    displayMahasiswa
                    displayKelulusan
                    askToAddMahasiswa2
                else
                    echo "Tidak ada perubahan pada jurusan."
                fi
            else
                echo "Mahasiswa tidak ditemukan."
                askToAddMahasiswa
            fi

        else
            # User chose not to update data
            askToAddMahasiswa
        fi
}

# Function to add a new student
addMahasiswa() {
    echo -n "Masukkan Nama Mahasiswa Baru: "
    read -r newName

    echo -n "Masukkan Jurusan Mahasiswa Baru: "
    read -r newJurusan

    echo -n "Masukkan Nilai Mahasiswa Baru: "
    read -r newNilai

    # Find the next available index
    nextIndex=$(( ${#arrMahasiswa[@]} / 3 ))

    arrMahasiswa[$nextIndex,0]="$newName"
    arrMahasiswa[$nextIndex,1]="$newJurusan"
    arrMahasiswa[$nextIndex,2]="$newNilai"

    # Print the updated statistics and student data
    displayKelulusan
    echo "Data Mahasiswa setelah penambahan data baru:"
    displayMahasiswa

    # After adding new student, ask if the user wants to update data
    askToUpdateData
}

# Function to ask user if they want to add a new student
askToAddMahasiswa() {
    echo -n "Apakah ingin menambahkan data Mahasiswa Baru? (Y/N): "
    read -r addChoice

    if [[ $addChoice == [Yy] ]]; then
        addMahasiswa
    else
        exit 0
    fi
}

# Function to ask user if they want to update data
askToUpdateData() {
    echo -n "Apakah ingin mengupdate data Mahasiswa? (Y/N): "
    read -r updateChoice

    if [[ $updateChoice == [Yy] ]]; then
        updateMahasiswa
    else
	askToAddMahasiswa
    fi
}

# Function to ask user if they want to add a new student
askToAddMahasiswa2() {
    echo -n "Apakah ingin menambahkan data Mahasiswa Baru? (Y/N): "
    read -r addChoice

    if [[ $addChoice == [Yy] ]]; then
        addMahasiswa
    else
        exit 0
    fi
}

# Main script
initMahasiswa
echo "Data Mahasiswa Awal: "
displayMahasiswa
displayKelulusan
askToUpdateData
