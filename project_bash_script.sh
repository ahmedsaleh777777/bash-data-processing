#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="logs/project.log"

log_info() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$timestamp] [INFO] $message" | tee -a "$LOG_FILE"
}
log_info "Starting data processing..."

log_success() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$timestamp] [SUCCESS] $message" | tee -a "$LOG_FILE"
}
log_success "File processed successfully."

log_warning() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$timestamp] [WARNING] $message" | tee -a "$LOG_FILE"
}
log_warning "File contains empty values."

log_error() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo [$timestamp] [ERROR] $message | tee -a "$LOG_FILE"
}
log_error "File is missing!!!"