# YouTube Music for OpenClaw

Control YouTube Music with natural language using [OpenClaw](https://openclaw.ai).

> "Play some Led Zeppelin" • "Next song" • "What's playing?" • "Volume up"

Uses [Kaset](https://github.com/sozercan/kaset) as the YouTube Music player on macOS.

## Install / Update

```bash
SKILL_DIR=~/.openclaw/skills/youtube-music-openclaw && ([ -d "$SKILL_DIR" ] && git -C "$SKILL_DIR" pull || git clone https://github.com/miwgel/youtube-music-openclaw.git "$SKILL_DIR") && "$SKILL_DIR/install.sh"
```

The installer will prompt to install any missing dependencies. Run the same command to update.

## What You Can Do

| Say this | What happens |
|----------|--------------|
| "Play some Beatles" | Searches YouTube Music, plays a song |
| "Quiero escuchar salsa" | Works in Spanish too |
| "Pause" / "Pausa" | Pauses playback |
| "Next" / "Skip" | Next track |
| "Previous" / "Back" | Previous track |
| "Volume up/down" | Adjusts volume |
| "What's playing?" | Shows current track |
| "I like this song" | Likes current track |
| "Shuffle" | Toggles shuffle mode |
| "Mute" | Toggles mute |

## Requirements

- macOS
- [OpenClaw](https://openclaw.ai)
- [Homebrew](https://brew.sh)

## Dependencies

Installed automatically by `install.sh`:

| Dependency | Purpose |
|------------|---------|
| [Kaset](https://github.com/sozercan/kaset) | YouTube Music player for macOS |
| [yt-dlp](https://github.com/yt-dlp/yt-dlp) | Search YouTube Music |
| [jq](https://jqlang.github.io/jq/) | Process search results |

## Features

- Search YouTube Music and play songs by voice/text
- Audio versions preferred (not music videos)
- Runs in background (doesn't steal focus)
- Bilingual: English and Spanish

## Setup Notes

### First Run
After installing, start Kaset once to sign in to your YouTube Music account:
```bash
open -a Kaset
```

### Known Issue
Kaset may open duplicate windows when playing new songs. This is a Kaset limitation. You can close extra windows manually.

> **Note:** Future versions of Kaset may support direct search, which would eliminate the need for `yt-dlp`, `jq`, and fix the duplicate windows issue.

## Manual Installation

```bash
# Install dependencies
brew install sozercan/repo/kaset yt-dlp jq

# Clone and link
git clone https://github.com/miwgel/youtube-music-openclaw.git ~/.openclaw/skills/youtube-music-openclaw

# Make script executable
chmod +x ~/.openclaw/skills/youtube-music-openclaw/bin/youtube-search
```

## Uninstall

```bash
rm -rf ~/.openclaw/skills/youtube-music-openclaw
```

## License

MIT
