#!/bin/bash

# Define colors for highlighting
GREEN='\033[0;32m'  # Green color for success
RED='\033[0;31m'    # Red color for failure
YELLOW='\033[1;33m' # Yellow color for hints
NC='\033[0m'        # No color, reset

# Function to run a test case
run_test () {
    folder=$1
    command=$2
    expected=$3

    echo -e "${YELLOW}Starting test in $folder${NC}"
    cd "$folder"
    output=$(eval "$command"; echo -n x)
    output=${output%x}
    cd ..

    echo -e "${YELLOW}Command executed: $command${NC}"
    echo -e "${YELLOW}Expected output:${NC}\n$expected"
    echo -e "${YELLOW}Actual output:${NC}\n$output"

    # Display actual output in hex format for debugging
    echo -e "${YELLOW}Actual output in hex:${NC}"
    echo -n "$output" | xxd

    # Display expected output in hex format for debugging
    echo -e "${YELLOW}Expected output in hex:${NC}"
    echo -n "$expected" | xxd

    if [ "$output" == "$expected" ]; then
        echo -e "${GREEN}Test Passed!${NC}"
    else
        echo -e "${RED}Test Failed!${NC}"
        echo -e "${YELLOW}Diff between actual and expected:${NC}"
        diff -y --color=always --suppress-common-lines <(echo -n "$output") <(echo -n "$expected")
    fi
}

# Test 1
run_test "ex00/" "cat z" $'Z\n'

# Test 2
run_test "ex01/" "ls -l | grep testShell00" "-r--r-xr-x 1 XX XX 40 Jun 1 23:42 testShell00"

# Test 3
run_test "ex02/" "ls -l" "total XX\ndrwx--xr-x 2 XX XX XX Jun 1 20:47 test0\n-rwx--xr-- 1 XX XX 4  Jun 1 21:46 test1\ndr-x---r-- 2 XX XX XX Jun 1 22:45 test2\n-r-----r-- 2 XX XX 1  Jun 1 23:44 test3\n-rw-r----x 1 XX XX 2  Jun 1 23:43 test4\n-r-----r-- 2 XX XX 1  Jun 1 23:44 test5\nlrwxrwxrwx 1 XX XX 5  Jun 1 22:20 test6 -> test0"

# Test 4
# Assuming the test is to check if 'id_rsa_pub' contains the public key
public_key=$(cat ~/.ssh/id_rsa.pub)
run_test "ex03/" "cat id_rsa_pub" "$public_key"

# Test 5
# This test requires manual verification since it involves checking file modification dates
echo "Test 5 needs manual verification."

# Test 6
expected_commit_ids="commit_id_1\ncommit_id_2\ncommit_id_3\ncommit_id_4\ncommit_id_5"
run_test "ex05/" "bash git_commit.sh | cat -e" "$expected_commit_ids"

# Test 7
ignored_files=".DS_Store\nmywork.c~"
run_test "ex06/" "bash git_ignore.sh | cat -e" "$ignored_files"

# Test 8
# Assuming 'b' is a modified version of 'a' and 'sw.diff' is the difference
diff_result="your_diff_result_here"
run_test "ex07/" "cat sw.diff" "$diff_result"

# Test 9
# This test involves deleting files, be cautious
echo "Test 9 needs to be performed manually due to file deletion."

# Test 10
# This test involves creating a magic file, which requires manual verification
echo "Test 10 needs manual verification."

echo "Testing Complete"
