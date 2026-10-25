#!/usr/bin/env bash

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

LOG_FILE="logs/project.log"

log_info() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${BLUE}[$timestamp] [INFO] $message ${NC}" | tee -a "$LOG_FILE"
}

log_info "Starting data processing..."

log_success() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${GREEN}[$timestamp] [SUCCESS] $message ${NC}" | tee -a "$LOG_FILE"
}

log_success "File processed successfully."

log_warning() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${YELLOW}[$timestamp] [WARNING] $message${NC}" | tee -a "$LOG_FILE"
}

log_warning "File contains empty values."

log_error() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${RED}[$timestamp] [ERROR] $message ${NC}" | tee -a "$LOG_FILE"
}

log_error "File is missing!!!"

handle_interrupt() {
    log_error "Script interrupted by user."
    exit 130
}

trap handle_interrupt SIGINT
echo sleeping for 3 seconds ...
sleep 3

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

validate_file ~/found.txt || true
validate_file ~/notfound.txt || true
validate_file ~/unreadable.txt || true
validate_file ~/empty.txt || true

