#!/usr/bin/env bash

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

LOG_FILE="logs/project.log"

# Logging functions

log_info() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${BLUE}[$timestamp] [INFO] ${NC} $message "
    echo "[$timestamp] [INFO] $message" >> "$LOG_FILE"

}

log_success() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${GREEN}[$timestamp] [SUCCESS] ${NC} $message "
    echo "[$timestamp] [SUCCESS] $message" >> "$LOG_FILE"

}

log_warning() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${YELLOW}[$timestamp] [WARNING] ${NC} $message" 
    echo "[$timestamp] [WARNING] $message" >> "$LOG_FILE"
}

log_error() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${RED}[$timestamp] [ERROR] ${NC} $message " 
    echo "[$timestamp] [ERROR] $message" >> "$LOG_FILE"
}

# Error handling

handle_interrupt() {
    log_error "Script interrupted by user."
    exit 130
}

trap handle_interrupt SIGINT

# Validation function

validate_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        log_error "File not found: $file"
        return 1
    fi

    if [[ ! -r "$file" ]]; then
        log_error "File is not readable: $file"
        return 1
    fi

    if [[ ! -s "$file" ]]; then
        log_warning "File is empty !: $file"
        return 1
    fi

    log_success "File is valid: $file"
    return 0
}

# File processing functions

count_lines() {
    local file="$1"

    if ! validate_file "$file"; then
        return 1
    
    fi
    log_info "Counting lines in: $file"
    
    wc -l "$file"

    log_success "Line count completed successfully."
}

extract_columns() {
    local file="$1"
    local columns="$2"
    local total_columns
    local column_number
    local selected_columns

    if ! validate_file "$file"; then
        return 1
    fi

    if [[ ! "$columns" =~ ^[0-9]+(,[0-9]+)*$ ]]; then
        log_error "Invalid column format: $columns. Use format like: 1,3,5"
        return 1
    fi

    total_columns=$(awk -F',' 'NR == 1 { print NF; exit }' "$file")

    IFS=',' read -ra selected_columns <<< "$columns"

    for column_number in "${selected_columns[@]}"; do
        if (( column_number < 1 || column_number > total_columns )); then
            log_error "Invalid column number: $column_number. File has $total_columns columns."
            return 1
        fi
    done

    log_info "Extracting columns: $columns from $file"

    awk -F',' -v cols="$columns" '
    BEGIN {
        count = split(cols, arr, ",")
    }

    NF > 0 {
        for (i = 1; i <= count; i++) {
            printf "%s ", $arr[i]
        }
        print ""
    }
    ' "$file"

    log_success "Column extraction completed successfully."
}

filter_data() {
        local file="$1"
        local pattern="$2"

        if ! validate_file "$file"; then
            return 1
        fi

        log_info "Filtering data in $file using pattern: [$pattern]"

        if grep -i -- "$pattern" "$file"; then
            log_success "Filtering completed successfully."
        else
            log_warning "No matches found for: [$pattern] "
            return 1
        fi
    }

calculate_stats() {
    local file="$1"
    local column="$2"

    if ! validate_file "$file"; then
        return 1
    fi

    if [[ ! "$column" =~ ^[0-9]+$ ]]; then
        log_error "Invalid column number: $column. Enter a single column number like: 5"
        return 1
    fi

    log_info "Calculating statistics for column [$column] in $file"

    if awk -F',' -v col="$column" '
    NR > 1 && $col != "" {
        value = $col

        if (count == 0 || value < min) {
            min = value
        }

        if (count == 0 || value > max) {
            max = value
        }

        sum += value
        count++
    }

    END {
        if (count == 0) {
            print "No numeric data found."
            exit 1
        }

        print "----------------"
        print "Statistics"
        print "----------------"
        print "Count  :", count
        print "Min    :", min
        print "Max    :", max
        print "Average:", sum / count
    }
    ' "$file"; then

        log_success "Statistics calculation completed successfully."
    else
        log_error "Statistics calculation failed."
        return 1
    fi
}

merge_files() {
    local output_file="output/merged.txt"
    local file

    for file in "$@"; do
            if ! validate_file "$file"; then
                log_error "Merge stopped because file is invalid: $file"
                return 1
            fi
    done

    log_info "Merging $# files..."

    cat "$@" > "$output_file"

    log_success "Files merged successfully into: $output_file"

}

deduplicate() {
    local file="$1"
    local original_count
    local unique_count
    local duplicates_removed

        if ! validate_file "$file"; then
            return 1
        fi
    log_info "Removing duplicate lines from: $file"

    original_count=$(wc -l < "$file")

    sort -u "$file" > "output/deduplicated.txt"

    unique_count=$(wc -l < "output/deduplicated.txt")

    duplicates_removed=$((original_count - unique_count))

    log_info "Original lines: $original_count"
    log_success "Unique lines: $unique_count"
    log_success "Duplicates removed: $duplicates_removed"
    log_success "Deduplication completed successfully."
}

command_exists() {
    local command_name="$1"

    if command -v "$command_name" > /dev/null 2>&1; then
        log_success "Command $command_name is installed."
    else
        log_error "Command $command_name is not installed."
        return 1
    fi
}

check_dependencies() {
    local commands=("awk" "grep" "sort" "wc" "sed")
    local cmd
    local missing=0

    log_info "Checking dependencies..."

    for cmd in "${commands[@]}"; do
        if ! command_exists "$cmd"; then
            missing=1
        fi
    done

    if [[ "$missing" -eq 0 ]]; then
        log_success "All required dependencies are installed."
    else
        log_error "One or more required dependencies are missing."
        return 1
    fi
}

init_directories() {
    mkdir -p logs

    log_info "Initializing directories..."

    mkdir -p data output

    log_success "Required directories are ready."
}

show_menu() {
    echo "========================================"
    echo "     Bash Data Processing Toolkit"
    echo "========================================"
    echo
    echo "1. Count Lines"
    echo "2. Extract CSV Columns"
    echo "3. Filter Data"
    echo "4. Calculate Statistics"
    echo "5. Merge Files"
    echo "6. Remove Duplicates"
    echo "7. Check Dependencies"
    echo "8. Initialize Directories"
    echo "9. Exit"
    echo
}

init_directories

while true; do

    show_menu

    read -p "Choose an option: " choice

        if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
            log_error "Invalid option. Please enter a number between 1 and 9."
            echo
            read -p "Press Enter to continue..."
            continue
        fi

    case "$choice" in

        1)
            read -p "Enter file path: " file
            count_lines "$file" || true
            ;;

        2)
            read -p "Enter CSV file path: " file
            read -p "Enter columns (example: 1,3,5): " columns

            extract_columns "$file" "$columns" || true
            ;;

        3)
            read -p "Enter file path: " file
            read -p "Enter search pattern: " pattern

            filter_data "$file" "$pattern" || true
            ;;

        4)
            read -p "Enter CSV file path: " file
            read -p "Enter numeric column number: " column

            calculate_stats "$file" "$column" || true
            ;;

        5)
            read -p "Enter files separated by spaces: " -a files

            merge_files "${files[@]}" || true
            ;;

        6)
            read -p "Enter file path: " file

            deduplicate "$file" || true
            ;;

        7)
            check_dependencies || true
            ;;

        8)
            init_directories
            ;;

        9)
            log_info "Exiting..."
            exit 0
            ;;

        *)
            log_error "Invalid choice."
            ;;

    esac

    echo
    read -p "Press Enter to continue..."

done