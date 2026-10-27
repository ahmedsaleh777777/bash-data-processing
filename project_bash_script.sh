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
    echo -e "[$timestamp] [INFO] $message" >> "$LOG_FILE"

}

log_info "Starting data processing..."

log_success() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${GREEN}[$timestamp] [SUCCESS] ${NC} $message "
    echo -e "[$timestamp] [SUCCESS] $message" >> "$LOG_FILE"

}

log_success "File processed successfully."

log_warning() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${YELLOW}[$timestamp] [WARNING] ${NC} $message" 
    echo -e "[$timestamp] [WARNING] $message" >> "$LOG_FILE"
}

log_warning "File contains empty values."

log_error() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${RED}[$timestamp] [ERROR] ${NC} $message " 
    echo -e "[$timestamp] [ERROR] $message" >> "$LOG_FILE"
}

log_error "File is missing!!!"

# Error handling

handle_interrupt() {
    log_error "Script interrupted by user."
    exit 130
}

trap handle_interrupt SIGINT
echo sleeping for 3 seconds ...
sleep 3

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
    validate_file "$file"
     wc -l "$file"
}

extract_columns() {
    local file="$1"
    local columns="$2"

    validate_file "$file"

    if [[ ! "$columns" =~ ^[0-9]+(,[0-9]+)*$ ]]; then
        log_error "Invalid column format: $columns Use format like: 1,3,5"
        return 1    
    fi

    #total_columns=$(awk -F',' 'NR==1 {print NF; exit}' "$file")
    

    awk -F',' -v cols="$columns" '
    BEGIN {
     count = split(cols, arr, ",")
      }

        {
            for (i=1; i <= count; i++) {
                printf "%s ", $arr[i]
            }
            print ""
        }
        ' "$file"
}

filter_data() {
        local file="$1"
        local pattern="$2"

        validate_file "$file"

        if grep -i "$pattern" "$file"; then
            log_success "Matching data found for: [$pattern] "
        else
            log_warning "No matches found for: [$pattern] "
            return 1
        fi
    }

# Test preparation

prepare_test_files() {
    mkdir -p "test-files"

    echo "Ahmed Saleh" > "test-files/found.txt"
    echo "test data" > "test-files/unreadable.txt"
    > "test-files/empty.txt"

    chmod a-r "test-files/unreadable.txt"
}

prepare_test_files

# Temporary tests
validate_file test-files/found.txt || true
echo "=============================="
validate_file test-files/notfound.txt || true
echo "=============================="
validate_file test-files/unreadable.txt || true
echo "=============================="
validate_file test-files/empty.txt || true
echo "=============================="
count_lines logs/project.log
echo "=============================="
extract_columns data/data.csv 1,2
echo "=============================="
filter_data data/data.csv "^a"
echo "=============================="
filter_data data/data.csv "hahaha" || true