# reduce Mac OS screencast size by ~10x
scrconv() {
    latest="$(ls -t ~/Desktop/*.mov | head -n1)"
    video="${1:-$latest}"
    ffmpeg -i "${video}" -an -vf scale=1920:-2 -c:v libx264 -preset veryfast "${video%.mov}.mp4"
}
