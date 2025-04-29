# Real-time Gyroscope & Accelerometer Viewer

This project provides a system for real-time visualization of gyroscope and accelerometer data transmitted from an Android device to a PC. The system supports both terminal-based viewing using Python and graphical plotting using MATLAB.

---

## 📘 Project Overview

The system consists of:
- An **Android application** that captures sensor data and transmits it via **UDP**
- **PC-based applications** (Python or MATLAB) that receive and process this data

---

## ✨ Features

### 📱 Android App
- Captures real-time gyroscope and accelerometer data.
- Transmits data over UDP to a specified PC IP address and port.

### 💻 PC Applications
- **Python Viewer**: Displays raw sensor data in the terminal.
- **MATLAB Plotter**: Visualizes gyroscope data (X, Y, Z components, and magnitude) in real-time plots.

---

## 🗃️ Data Format

The Android application sends sensor data over UDP as plain text strings.  
Each line represents either **gyroscope** or **accelerometer** data.

### Format:

Where:
- `<gx>, <gy>, <gz>` are the gyroscope readings (X, Y, Z axes).
- `<ax>, <ay>, <az>` are the accelerometer readings (X, Y, Z axes).

### Example:

---

## 🖥️ PC Application Options

### 1. MATLAB Script (Real-Time Plotting)

Provides real-time graphical visualization of gyroscope data.

#### ✅ Requirements
- MATLAB **R2020b or newer**
- **UDP Receive** support (install via MATLAB Add-On Explorer)

#### 🛠️ Setup & Run
1. Open MATLAB.
2. Ensure the UDP support is installed.
3. Open and run the `gyro_plotter.m` script.
4. Enter the same UDP port number as configured in the Android app (default: **5005**).
5. View real-time plots showing:
   - Gyroscope X, Y, Z components
   - Gyroscope magnitude

#### 🧮 Gyroscope Magnitude Calculation
\[
\text{Magnitude} = \sqrt{gx^2 + gy^2 + gz^2}
\]

---

### 2. Python Script (Terminal Viewer)

Displays raw sensor data in the terminal.

#### ✅ Requirements
- Python 3.x
- `socket` library (usually included by default)

#### 🛠️ Setup & Run
1. Open your terminal.
2. Navigate to the folder containing `udp_receiver.py`.
3. Run the script:
   ```bash
   python udp_receiver.py
.
├── android_app/           # Contains Android app source code or APK
├── gyro_plotter.m         # MATLAB script for plotting
├── udp_receiver.py        # Python script for terminal viewing
└── README.md              # Project documentation (this file)

---

Let me know if you'd like to also generate a `LICENSE` file or include Android app build/run instructions.
