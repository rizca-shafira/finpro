declare -A arrMahasiswa
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Inisialisasi Data Mahasiswa
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

# Tampilkan Data Mahasiswa
displayMahasiswa() {
    printf "${GREEN}%-7s %-20s %s${NC}\n" "Nama" "Jurusan" "Nilai"
    printf "${GREEN}%-7s %-20s %s${NC}\n" "----" "-------" "-----"
    
    # Calculate the number of students dynamically
    total_students=$(( ${#arrMahasiswa[@]} / 3 ))

    for (( i=0; i<total_students; i++ )); do
        printf "%-7s %-20s %s\n" "${arrMahasiswa[$i,0]}" "${arrMahasiswa[$i,1]}" "${arrMahasiswa[$i,2]}"
    done
    printf "\n"
}

# Tampilkan Statistik Kelulusan Mahasiswa
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
    printf "${GREEN}%-25s %s${NC}\n" "Jumlah Mahasiswa Lulus" "Jumlah Mahasiswa Tidak Lulus"
    printf "${GREEN}%-25s %s${NC}\n" "----------------------" "----------------------------"
    printf "%-25d %d\n" $lulus $tidak_lulus
    printf "\n"
}

# Update Data Mahasiswa?
askToUpdateData() {
    echo -n "Apakah ingin mengupdate data Mahasiswa? (Y/N): "
    read -r updateChoice
}

updateMahasiswa() {
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
        #update data mahasiswa
        
        if [[ $changeChoice == [Yy] ]]; then
            echo -n "Masukkan Jurusan Baru: "
            read -r newJurusan
            # Update the department
            arrMahasiswa[$studentIndex,1]="$newJurusan"
            echo "Jurusan telah diupdate. Data Mahasiswa terbaru:"
            #displayMahasiswa
            #displayKelulusan
            #askToAddMahasiswa2
        else
            echo "Tidak ada perubahan pada jurusan."
        fi
    else
        echo "Mahasiswa tidak ditemukan."
        #askToAddMahasiswa
    fi
}

# Tambah Data Mahasiswa
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
    #displayMahasiswa

    # After adding new student, ask if the user wants to update data
    #askToUpdateData
}

# Function to ask user if they want to add a new student
askToAddMahasiswa() {
    echo -n "Apakah ingin menambahkan data Mahasiswa Baru? (Y/N): "
    read -r addChoice
}

fungsikecil() {
    askToAddMahasiswa
    if [[ $addChoice == [Yy] ]]; then
        addMahasiswa
        displayMahasiswa
        fungsiutama
    else
        exit 0
    fi
}

fungsiutama() {
    askToUpdateData
    if [[ $updateChoice == [Yy] ]]; then
        updateMahasiswa
        if [[ $studentIndex -ne -1 ]]; then
            displayMahasiswa
            displayKelulusan
            #disini
            fungsikecil
        else
            fungsikecil
        fi
    else
        #disini   
        fungsikecil
    fi
}

initMahasiswa
echo "Data Mahasiswa Awal: " 
displayMahasiswa
displayKelulusan
fungsiutama