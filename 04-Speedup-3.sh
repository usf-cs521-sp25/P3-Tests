source "${TEST_LIB}/funcs.bash"

test_start "Correct Nonces" \
    "Verifies program solutions against known-correct nonces"

serial=$(./miner 1 20 'Speed Test' \
    | grep -o '[0-9]* hashes in [0-9]*\.[0-9]*s' \
    | sed 's:.* \([0-9]*\.[0-9]*\)s:\1:g')

echo "Serial run: ${serial}"

speed=$(./miner 2 20 'Speed Test' \
    | grep -o '[0-9]* hashes in [0-9]*\.[0-9]*s' \
    | sed 's:.* \([0-9]*\.[0-9]*\)s:\1:g')

echo "Speed run: ${speed}"

# Ensure speedup is at least 1.6:
echo "${serial} ${speed}" \
    | awk '
{
    speedup=( $1 / $2 )
    printf "Speedup is: %f\n", speedup
    if (speedup > 1.6) {
        exit 0
    } else { 
        exit 1
    }
}'

test_end
