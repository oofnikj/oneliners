# Create a random password of reasonable length (trade-off between randomness and easy to remember)

openssl rand -base64 15

# Create a more cryptographically secure password of unreasonable length
# (On Mac OS use `gtr` - GNU `tr`)

cat /dev/urandom | tr -cd '\040-\177' | head -c30; echo
