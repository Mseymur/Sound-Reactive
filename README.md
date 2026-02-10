# Sound-Reactive Animations 🎵

![Processing](https://img.shields.io/badge/Processing-3.0%2B-006699?style=for-the-badge&logo=processing&logoColor=white)
![TouchDesigner](https://img.shields.io/badge/TouchDesigner-2022.3%2B-black?style=for-the-badge)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Mac-lightgrey?style=for-the-badge)

**Sound-Reactive Animations** is a collection of open-source audio-visual tools designed to translate live music into generative visuals. The project explores the intersection of sound and motion through two complementary implementations: a code-driven approach using **Processing** and a node-based approach using **TouchDesigner**.

> **Note:** These tools are engineered for live performance, featuring advanced signal processing to ensure smooth, latency-free responsiveness to audio input.

---

## ✨ Features

*   **Dual Platforms:** Available in both **Processing** (lightweight, code-first) and **TouchDesigner** (node-based, rapid compositing).
*   **Real-time Interaction:** Includes VJ-style parameter controls for tweaking visuals on the fly during sets.
*   **Advanced Signal Processing:** 
    *   **FFT Smoothing:** Prevents flickering for polished visuals.
    *   **Latency Control:** Keeps visuals tightly synchronized with the beat.
    *   **Normalization:** Adapts responsiveness to varying venue volume levels.
*   **Visual Grammar:** specific forms and decay patterns designed to create a cohesive aesthetic language.

## 🛠️ Tech Stack

*   **Code-Based:** Processing (Java)
*   **Node-Based:** TouchDesigner
*   **Audio Analysis:** FFT (Fast Fourier Transform), Beat Detection, Amplitude Gating

## 📂 Structure

*   **[Wavy_Circled_Music_Reactive.pde](Wavy_Circled_Music_Reactive.pde)** - The Processing sketch implementing the code-driven visualizer.
*   **[Project_dEVILNights_SoundReactive.toe](Project_dEVILNights_SoundReactive.toe)** - The TouchDesigner project file for node-based visuals.

## 🚀 Getting Started

### Prerequisites

*   Microphone or Virtual Audio Cable (for audio input)
*   [Processing 3+](https://processing.org/download)
*   [TouchDesigner](https://derivative.ca/download)

### Installation & Usage

#### Processing Version
1.  Open `Wavy_Circled_Music_Reactive.pde` in the Processing IDE.
2.  Install the **Minim** library via Sketch > Import Library... > Add Library...
3.  Run the sketch. It will default to your system's default audio input.

#### TouchDesigner Version
1.  Open `Project_dEVILNights_SoundReactive.toe` in TouchDesigner.
2.  Navigate to the `Audio Device In` CHOP and select your desired input source.
3.  Enter Performance Mode (F1) to view the full-screen visuals.

## 👥 The Team

Created as an exploration of generative audio-visual systems.

*   **Seymur Mammadov**

## 📄 License

[License](LICENSE)

---

*[Learn more about the project details here.](https://mseymur.framer.website/projects/sound-reactive)*
