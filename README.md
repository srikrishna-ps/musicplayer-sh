# MusicPlayer.sh

A minimal GUI-based music player written in Bash using `zenity`, `mpv`, and system audio utilities. Designed for simplicity and visual control, it offers essential playback features like play, pause, resume, stop, volume adjustment, and track skipping — all accessible through a clean graphical interface.

---

## Features

- Simple graphical interface powered by `zenity`
- Audio playback using `mpv`
- Real-time song info: title, elapsed time, remaining time
- Interactive system volume control
- Support for basic playback actions (play, pause, resume, stop)
- Track skipping within the same directory

---

## Requirements

Before running the script, make sure the following tools are installed on your Linux system:

### Core Dependencies

| Tool                | Purpose                               |
| ------------------- | ------------------------------------- |
| `bash`              | Shell interpreter                     |
| `zenity`            | GUI dialog boxes                      |
| `mpv`               | Audio playback engine                 |
| `ffprobe`           | Get media duration (from `ffmpeg`)    |
| `pactl` or `amixer` | Volume control via PulseAudio or ALSA |

---

### Installation on Common Distributions

#### Ubuntu / Debian

```bash
sudo apt update
sudo apt install mpv zenity ffmpeg pulseaudio-utils alsa-utils
```

#### Arch / Manjaro

```bash
sudo pacman -S mpv zenity ffmpeg pulseaudio alsa-utils
```

> Ensure that `ffprobe`, `mpv`, and either `pactl` or `amixer` are available in your system’s PATH.

---

## Installation

1. **Clone the repository** or download the script:

   ```bash
   git clone https://github.com/your-username/unix-project.git
   cd unix-project
   ```

2. **Make the script executable**:

   ```bash
   chmod +x musicplayer.sh
   ```

3. **Run the script**:

   ```bash
   ./musicplayer.sh
   ```

---

## Usage

Once launched, a graphical menu appears with the following options:

| Option            | Description                                                |
| ----------------- | ---------------------------------------------------------- |
| **Play**          | Select an audio file to play via a file picker             |
| **Pause**         | Pauses the track using a background `SIGSTOP`              |
| **Resume**        | Resumes the track using `SIGCONT`                          |
| **Stop**          | Completely stops the playback with `SIGKILL`               |
| **Skip Track**    | Finds and plays the next `.mp3` file in the current folder |
| **Adjust Volume** | Adjusts system volume using a slider GUI                   |
| **Quit**          | Exits the application                                      |

During playback, a live info window appears showing:

- Song name
- Time elapsed
- Time remaining

---

## How It Works

- **Playback**: `mpv` plays the selected track in the background.
- **Tracking**: `ffprobe` determines the total duration; `date` and `sleep` calculate progress in real time.
- **Control**: `pkill` manages play/pause/stop/resume actions via signals.
- **Skipping**: The script scans for `.mp3` files in the same directory and cycles through them.
- **Volume**: Uses `pactl` (PulseAudio) or `amixer` (ALSA) depending on what's installed.

---

## Troubleshooting

- **Nothing happens after clicking 'Play'?**
  Ensure `mpv` is installed and working from the terminal.

- **No GUI appears?**
  `zenity` requires a graphical desktop session — won’t work over pure SSH.

- **Volume change doesn’t apply?**
  Check whether `pactl` or `amixer` is installed. The script checks both.

- **‘Skip Track’ fails or plays the same song?**
  The script only looks for `.mp3` files in the same folder as the currently playing one. Ensure the directory contains multiple files.

---

## Notes

- Only one `mpv` process is handled at a time.
- Script assumes all audio files are playable by `mpv`.
- Written and tested on Ubuntu 22.04 — may need minor adjustments for other distributions.
- Works with `.mp3`, `.wav`, `.flac`, or any format supported by `mpv`.

---

## License

This project is licensed under the MIT License.
See [`LICENSE`](LICENSE) for more information.

---

## Author

**SriKrishna Pejathaya P S**
Email: [srikrishna.cs22@bmsce.ac.in](mailto:srikrishna.cs22@bmsce.ac.in)
