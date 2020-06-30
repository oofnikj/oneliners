# Create a cryptographically secure random password of specified length

# actual one-liner: openssl rand base64 $1

# better:
# (On Mac OS use `gtr` - GNU `tr`)
mkpw() {
    type gtr >/dev/null 2>&1 && TR=gtr || TR=tr
    cat /dev/urandom | $TR -cd '\040-\177' | head -c ${1:-12}; echo
}
