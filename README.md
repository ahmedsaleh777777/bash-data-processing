# Bash Data Processing & Automation Toolkit

## Description

The Bash Data Processing & Automation Toolkit is an interactive Bash script for performing common file and data processing operations on Linux.

The script provides a menu that allows the user to:

- Count lines in files
- Extract selected columns from CSV files
- Filter data using search patterns
- Calculate statistics for numeric CSV columns
- Merge multiple files
- Remove duplicate lines
- Check required Linux dependencies
- Initialize required project directories

The script also includes input validation, file validation, logging, error handling, and user-friendly feedback.

## Requirements

The project requires a Linux environment with Bash and the following commands installed:

- `awk`
- `grep`
- `sort`
- `wc`
- `sed`

Other standard Linux utilities used by the script include:

- `cat`
- `mkdir`
- `date`

The script uses:

```bash
#!/usr/bin/env bash
```

and enables Bash strict mode:

```bash
set -euo pipefail
```

## Installation

Clone or copy the project to your Linux machine.

Example using Git:

```bash
git clone <repository-url>
cd bash-data-processing
```

Give the main script execute permission:

```bash
chmod +x project_bash_script.sh
```

Run the script:

```bash
./project_bash_script.sh
```

## Usage

When the script starts, the following interactive menu is displayed:

```text
========================================
     Bash Data Processing Toolkit
========================================

1. Count Lines
2. Extract CSV Columns
3. Filter Data
4. Calculate Statistics
5. Merge Files
6. Remove Duplicates
7. Check Dependencies
8. Initialize Directories
9. Exit
```

Enter a number between `1` and `9` to select an operation.

After each operation, press Enter to return to the main menu.

## Project Structure

```text
bash-data-processing/
├── data/
├── logs/
│   └── project.log
├── output/
├── screenshots/
├── project_bash_script.sh
└── README.md
```

## Logging

The script records INFO, SUCCESS, WARNING, and ERROR messages.

Example:

```text
[INFO] Processing file...
[SUCCESS] Processing completed successfully.
[WARNING] No matching data found.
[ERROR] File not found.
```

Log messages are stored in:

```text
logs/project.log
```

## Error Handling

The script validates:

- Menu input
- File existence
- File readability
- Empty files
- CSV column format and range
- Required Linux commands

Invalid input returns the user to the main menu instead of crashing the application.