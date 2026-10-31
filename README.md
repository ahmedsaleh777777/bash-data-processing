# Bash Data Processing & Automation Toolkit

## Project Name

**Bash Data Processing & Automation Toolkit**

## Description

The Bash Data Processing & Automation Toolkit is an interactive Bash application designed to perform common file and data processing tasks on Linux.

The script provides a menu-based interface that allows users to:

- Count lines in files
- Extract selected columns from CSV files
- Filter data using search patterns
- Calculate statistics for numeric CSV columns
- Merge multiple files
- Remove duplicate lines
- Check required Linux commands
- Initialize the required project directories

The project also includes:

- Input validation
- File validation
- Logging
- Error handling
- Colored terminal messages
- Dependency checking
- Interactive menu navigation

---

## Requirements

The project requires a Linux environment with Bash.

The following Linux commands/tools are used:

- `awk`
- `grep`
- `sort`
- `wc`
- `sed`
- `cat`
- `mkdir`
- `date`

The script uses Bash strict mode:

```bash
set -euo pipefail
```

---

## Installation

Clone the project repository:

```bash
git clone https://github.com/ahmedsaleh777777/bash-data-processing.git
```

Enter the project directory:

```bash
cd bash-data-processing
```

Give execute permission to the main script:

```bash
chmod +x project_bash_script.sh
```

---

## Usage

Run the script using:

```bash
./project_bash_script.sh
```

The following interactive menu will be displayed:

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

Choose an option:
```

Select an option between `1` and `9`.

After each operation, the script displays:

```text
Press Enter to continue...
```

Press Enter to return to the main menu.

---

## Functions

### `count_lines()`

Counts the number of lines in a file.

The function validates the file before processing it.

Example:

```bash
count_lines "data/sample.txt"
```

Example output:

```text
[SUCCESS] File is valid: data/sample.txt
[INFO] Counting lines in: data/sample.txt
10 data/sample.txt
[SUCCESS] Line count completed successfully.
```

---

### `extract_columns()`

Extracts selected columns from a CSV file.

The function accepts:

- File path
- Column numbers separated by commas

Example:

```bash
extract_columns "data/data.csv" "1,3"
```

Example input:

```text
name,age,city,job,salary
Ahmed,25,Cairo,Engineer,5000
Ali,30,Giza,Admin,4500
Mona,28,Alexandria,Developer,6000
```

Example output:

```text
name city
Ahmed Cairo
Ali Giza
Mona Alexandria
```

The function validates both the column format and column range.

---

### `filter_data()`

Filters lines from a file using a search pattern.

The search is case-insensitive.

Example:

```bash
filter_data "data/data.csv" "Ahmed"
```

Example output:

```text
Ahmed,25,Cairo,Engineer,5000
```

If no matching data is found:

```text
[WARNING] No matches found for: [pattern]
```

---

### `calculate_stats()`

Calculates statistics for a selected numeric CSV column.

The function calculates:

- Count
- Minimum
- Maximum
- Average

Example:

```bash
calculate_stats "data/data.csv" 5
```

Example output:

```text
----------------
Statistics
----------------
Count  : 3
Min    : 4500
Max    : 6000
Average: 5166.67
```

---

### `merge_files()`

Merges multiple files into one output file.

Example:

```bash
merge_files "data/file1.txt" "data/file2.txt" "data/file3.txt"
```

The merged file is saved as:

```text
output/merged.txt
```

Example message:

```text
[INFO] Merging 3 files...
[SUCCESS] Files merged successfully into: output/merged.txt
```

---

### `deduplicate()`

Removes duplicate lines from a file.

Example:

```bash
deduplicate "data/sample.txt"
```

The output is saved as:

```text
output/deduplicated.txt
```

Example output:

```text
[INFO] Original lines: 6
[SUCCESS] Unique lines: 4
[SUCCESS] Duplicates removed: 2
[SUCCESS] Deduplication completed successfully.
```

---

### `command_exists()`

Checks whether a Linux command is installed and available in the system PATH.

Example:

```bash
command_exists "awk"
```

Example output:

```text
[SUCCESS] Command awk is installed.
```

If the command is not available:

```text
[ERROR] Command example-command is not installed.
```

---

### `check_dependencies()`

Checks whether all required commands are installed.

The current dependencies are:

```text
awk
grep
sort
wc
sed
```

Example:

```bash
check_dependencies
```

Example output:

```text
[INFO] Checking dependencies...
[SUCCESS] Command awk is installed.
[SUCCESS] Command grep is installed.
[SUCCESS] Command sort is installed.
[SUCCESS] Command wc is installed.
[SUCCESS] Command sed is installed.
[SUCCESS] All required dependencies are installed.
```

---

### `init_directories()`

Creates the required project directories if they do not already exist.

The directories are:

```text
data/
output/
logs/
```

Example:

```bash
init_directories
```

Example output:

```text
[INFO] Initializing directories...
[SUCCESS] Required directories are ready.
```

---

## Input Validation

The script validates menu input.

If the user enters non-numeric input:

```text
abc
```

The script displays:

```text
[ERROR] Invalid option. Please enter a number between 1 and 9.
```

If the user enters an unavailable numeric option:

```text
15
```

The script displays:

```text
[ERROR] Invalid choice.
```

The script returns to the main menu instead of crashing.

---

## File Validation

Files are validated before processing.

The script checks whether the file:

- Exists
- Is a regular file
- Is readable
- Is not empty

Example error:

```text
[ERROR] File not found: data/example.txt
```

---

## Logging

The script uses four logging levels:

- `INFO`
- `SUCCESS`
- `WARNING`
- `ERROR`

Example terminal output:

```text
[INFO] Processing file...
[SUCCESS] Processing completed successfully.
[WARNING] No matches found.
[ERROR] File not found.
```

Logs are stored in:

```text
logs/project.log
```

Terminal messages use colors while the log file stores clean text without color escape codes.

---

## Error Handling

The script uses:

```bash
set -euo pipefail
```

It also handles `Ctrl+C` using:

```bash
trap handle_interrupt SIGINT
```

When the user interrupts the script:

```text
[ERROR] Script interrupted by user.
```

The script exits with status code `130`.

---

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

---

## Example Workflow

Run the script:

```bash
./project_bash_script.sh
```

Select:

```text
2
```

Enter the CSV file:

```text
data/data.csv
```

Enter columns:

```text
1,3
```

Example result:

```text
[SUCCESS] File is valid: data/data.csv
[INFO] Extracting columns: 1,3 from data/data.csv

name city
Ahmed Cairo
Ali Giza
Mona Alexandria

[SUCCESS] Column extraction completed successfully.
```

Press Enter to return to the main menu.
## Testing

The Bash Data Processing & Automation Toolkit was tested using both valid and invalid inputs.

Each implemented feature was tested with successful and failure scenarios. Screenshots were captured during development to document the test results.

| Feature | Valid Test | Invalid Test | Evidence | Status |
|---|---|---|---|---|
| File Validation | Existing readable file | Missing, unreadable, and empty files | Screenshot 04 – File Validation | Pass |
| Count Lines | Valid file | Invalid file path | Screenshot 05 – Count Lines | Pass |
| Extract CSV Columns | Valid columns such as `1,3` | Invalid format and unavailable column number | Screenshots 06 & 07 – Extract Columns | Pass |
| Filter Data | Existing search pattern | Pattern with no matches | Screenshot 08 – Filter Data | Pass |
| Calculate Statistics | Valid numeric column | Invalid column input / column without usable data | Screenshot 09 – Calculate Statistics | Pass |
| Merge Files | Multiple valid files | Invalid file in merge list | Screenshot 10 – Merge Files | Pass |
| Remove Duplicates | File containing duplicate lines | Invalid input file | Screenshot 11 – Deduplicate | Pass |
| Command Check | Existing command such as `awk` | Missing / fake command | Screenshot 12 – Command Exists | Pass |
| Dependency Check | All required dependencies available | Missing dependency scenario | Screenshots 13 & 17 – Dependency Check | Pass |
| Initialize Directories | Required directories created or already available | Re-running initialization safely | Screenshot 14 – Initialize Directories | Pass |
| Main Menu | Valid menu option | Invalid menu option | Screenshot 15 – Main Menu | Pass |
| Input Validation | Numeric menu input | Non-numeric input and unavailable choice | Screenshot 16 – Input Validation | Pass |
| User Interruption | Normal script execution | `Ctrl+C` interruption | Screenshot 03 – Ctrl+C Error Handling | Pass |

### Test Coverage

The testing covered the required scenarios:

- Existing files
- Valid CSV columns
- Valid search and regex patterns
- Multiple input files
- Duplicate data
- Valid menu options
- Non-existing files
- Empty files
- Invalid column numbers
- Invalid menu choices
- Missing dependencies
- Invalid user input
- User interruption using `Ctrl+C`

For recoverable errors, the script displays an appropriate error or warning message and returns the user to the interactive menu instead of crashing.

