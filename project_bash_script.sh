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

calculate_stats() {
    local file="$1"
    local column="$2"

    validate_file "$file"

    if [[ ! "$column" =~ ^[0-9]+$ ]]; then
        log_error "Invalid column format: $column Use format like: 1,3,5"
        return 1    
    fi

        awk -F',' -v col="$column" '
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
            print "----------------"
            print "Statistics"
            print "----------------"
            print "Count  :", count
            print "Min    :", min
            print "Max    :", max
            print "Average:", sum / count
        }
        ' "$file"

}

merge_files() {
    local output_file="output/merged.txt"
    local file

    mkdir -p "output"

    for file in "$@"; do
            if ! validate_file "$file"; then
                log_error "Merge stopped because file is invalid: $file"
                return 1
            fi
    done

cat "$@" > "$output_file"

log_success "Files merged successfully into: $output_file"

}

deduplicate() {
    local file="$1"
    local original_count
    local unique_count
    local duplicates_removed

    validate_file "$file"

    original_count=$(wc -l < "$file")

    sort -u "$file" > "output/deduplicated.txt"

    unique_count=$(wc -l < "output/deduplicated.txt")

    duplicates_removed=$((original_count - unique_count))

    log_info "Original lines: $original_count"
    log_success "Unique lines: $unique_count"
    log_success "Duplicates removed: $duplicates_removed"

}

command_exists() {
    local command_name="$1"
    if command -v "$command_name" > /dev/null 2>&1; then
        log_success "$command_name is installed."
    else
        log_error "$command_name is not installed."
        return 1
    fi
}

check_dependencies() {
    local commands=("awk" "grep" "sort" "wc" "sed" "haha")
    local cmd

    log_info "Checking dependencies..."

    for cmd in "${commands[@]}"; do
        command_exists "$cmd"
    done
}

# Test preparation
add_line() {
    echo "============================================================"
}
prepare_test_files() {
    mkdir -p "test-files"

    echo "Ahmed Saleh" > "test-files/found.txt"
    echo "test data" > "test-files/unreadable.txt"
    > "test-files/empty.txt"

    chmod a-r "test-files/unreadable.txt"

    cat > test-files/duplicates.txt <<'EOF'
    Linux
    Docker
    Linux
    Kubernetes
    Docker
    Git
EOF
}

prepare_test_files

# Temporary tests
validate_file test-files/found.txt || true
add_line
validate_file test-files/notfound.txt || true
add_line
validate_file test-files/unreadable.txt || true
add_line
validate_file test-files/empty.txt || true
add_line
count_lines logs/project.log
add_line
extract_columns data/data.csv 1,2
add_line
filter_data data/data.csv "^a"
add_line
filter_data data/data.csv "hahaha" || true
add_line
calculate_stats "data/data.csv" 5
add_line
echo "File 1 data" > data/file1.txt
echo "File 2 data" > data/file2.txt
echo "File 3 data" > data/file3.txt
merge_files data/file1.txt data/file2.txt data/file3.txt
cat output/merged.txt
add_line
echo "test-files/duplicates.txt:" && cat test-files/duplicates.txt
deduplicate test-files/duplicates.txt
add_line
command_exists awk
command_exists hahahaha || true
add_line
check_dependencies