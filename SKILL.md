---
name: youtube-music-openclaw
description: Control YouTube Music with natural language - search, play, pause, skip, volume, shuffle
user-invocable: true
metadata: {"openclaw":{"emoji":"🎵","os":["darwin"],"requires":{"bins":["osascript","yt-dlp","jq"]},"install":[{"id":"yt-dlp","kind":"brew","formula":"yt-dlp","bins":["yt-dlp"],"label":"Install yt-dlp (YouTube search)"},{"id":"jq","kind":"brew","formula":"jq","bins":["jq"],"label":"Install jq (JSON processing)"}]}}
---

# Kaset Music Control

Control the Kaset YouTube Music player using AppleScript and URL schemes.

## Playback Control (AppleScript)

All playback commands use this pattern:

```bash
osascript -e 'tell application "Kaset" to <command>'
```

### Available Commands

| Command | Description |
|---------|-------------|
| `play` | Start or resume playback |
| `pause` | Pause playback |
| `playpause` | Toggle play/pause |
| `next track` | Skip to next track |
| `previous track` | Go to previous track |
| `set volume 50` | Set volume (0-100) |
| `toggle mute` | Toggle mute on/off |
| `toggle shuffle` | Toggle shuffle mode |
| `cycle repeat` | Cycle repeat mode (Off → All → One) |
| `like track` | Like current track |
| `dislike track` | Dislike current track |
| `get player info` | Get current state as JSON |

### Examples

```bash
# Play music
osascript -e 'tell application "Kaset" to play'

# Pause
osascript -e 'tell application "Kaset" to pause'

# Next track
osascript -e 'tell application "Kaset" to next track'

# Set volume to 70%
osascript -e 'tell application "Kaset" to set volume 70'

# Get current track info
osascript -e 'tell application "Kaset" to get player info'
```

## Search and Play Songs

To search for and play a song, use the youtube-search script to find videos, then open via URL scheme.

### Step 1: Search for videos

```bash
{baseDir}/bin/youtube-search "led zeppelin stairway to heaven"
```

Returns JSON array:
```json
[
  {"id": "QkF3oxziUI4", "title": "Led Zeppelin - Stairway to Heaven", "duration": "8:02", "author": "Led Zeppelin"},
  ...
]
```

### Step 2: Play a video by ID

```bash
open -g "kaset://play?v=VIDEO_ID"
```

The `-g` flag keeps Kaset in background without stealing focus.

### Complete Flow Example

When user says "play some led zeppelin":

1. Search: `{baseDir}/bin/youtube-search "led zeppelin"`
2. Pick a random result from the JSON array
3. Open URL in background: `open -g "kaset://play?v=<selected_id>"`
4. Wait 2 seconds for Kaset to load
5. Send play command: `osascript -e 'tell application "Kaset" to play'`
6. Close duplicate windows (see below)

**IMPORTANT**: The URL scheme alone may not start playback automatically. Always send a `play` command after opening the URL.

### Closing Duplicate Windows

After opening a new song, close extra Kaset windows:

```bash
osascript -e '
tell application "System Events"
    tell process "Kaset"
        repeat while (count of windows) > 1
            click button 1 of window 1
            delay 0.3
        end repeat
    end tell
end tell
'
```

## Natural Language Mapping

| User says | Action |
|-----------|--------|
| "play" / "reproduce" | `osascript -e 'tell application "Kaset" to play'` |
| "pause" / "pausa" | `osascript -e 'tell application "Kaset" to pause'` |
| "next" / "siguiente" / "skip" | `osascript -e 'tell application "Kaset" to next track'` |
| "previous" / "anterior" / "back" | `osascript -e 'tell application "Kaset" to previous track'` |
| "volume up" / "sube volumen" | Increase volume by ~10 |
| "volume down" / "baja volumen" | Decrease volume by ~10 |
| "mute" / "silencio" | `osascript -e 'tell application "Kaset" to toggle mute'` |
| "what's playing" / "qué suena" | `osascript -e 'tell application "Kaset" to get player info'` |
| "I like this" / "me gusta" | `osascript -e 'tell application "Kaset" to like track'` |
| "shuffle" / "aleatorio" | `osascript -e 'tell application "Kaset" to toggle shuffle'` |
| "play X" / "quiero escuchar X" | Search → random pick → open URL |

## Important Notes

- Kaset must be running for AppleScript commands to work
- The `get player info` command returns JSON with: state, volume, shuffle, repeat, liked status, and track metadata
- For volume changes, first get current volume with `get player info`, then set new value
- When searching, select randomly from results for variety
- Search uses YouTube Music to get audio versions (not music videos)

## Known Quirks

### URL scheme opens duplicate windows
The `kaset://play?v=ID` URL scheme opens a new Kaset window each time. Use the "Closing Duplicate Windows" script above to clean up after opening a new song. Requires System Events accessibility permissions.

### Playback doesn't start automatically from URL
After opening a URL with `open "kaset://play?v=ID"`, wait ~2 seconds then send `osascript -e 'tell application "Kaset" to play'` to start playback.

### System Events permissions
If you need to interact with Kaset windows (close duplicates, etc.), osascript needs accessibility permissions in System Preferences > Privacy & Security > Accessibility.
