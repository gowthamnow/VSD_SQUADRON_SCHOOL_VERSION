# VSD Squadron School Version - Micromouse Maze Solver

This repository contains the complete hardware and software design for a maze-solving robot powered by the **VSD Squadron FM FPGA**. This project demonstrates a full-stack engineering approach, from custom PCB design to RTL logic implementation.

---

## 📸 Media Gallery

### Fabricated Robot
| Front View | Back View |
| :---: | :---: |
| ![Front](media/fab_front.jpeg) | ![Back](media/fab_abck.jpeg) |

### Demonstration Videos
| First Run | Final Maze Run |
| :---: | :---: |
| [Watch Video 1](media/mazefirst.mp4) | [Watch Video 2](media/maze2.mp4) |

*(Note: Videos are hosted in the `media/` folder. For the best experience, view them on GitHub.)*

---

## 🛠️ Hardware Design: Step-by-Step

### 1. Conceptual Schematic
The heart of the robot is the **VSD Squadron FM FPGA**. The schematic integrates:
- **Power Management**: Regulated 5V and 3.3V rails.
- **Sensor Interface**: Connectivity for 3 HC-SR04 Ultrasonic sensors.
- **Motor Driving**: Interface to the L298N/DRV8833 motor driver.
- **Telemetry**: UART pins for debugging.

![Schematics](media/schematics.png)

### 2. Custom VSD Squadron FM Footprint
One of the core challenges was designing a precise **footprint for the VSD Squadron FM**. 
- **Specifications**: 36-pin header layout with standardized pitch.
- **Design Process**: Created in Altium/EasyEDA using exact physical dimensions to ensure the FPGA board sits flush on the robot's motherboard.
- **Mapping**: All FPGA I/Os (Pins 2, 3, 4, 6, 9, 10, 12, 13, 14, 15, 18, 19, 21, 27, 28, 31, 32, 34) are correctly routed.

![Footprint](media/footprint.png)

### 3. PCB Layout & 3D Visualization
The PCB is a two-layer design optimized for signal integrity and weight distribution.
- **Front Layer**: Signal routing and sensor mounting.
- **Back Layer**: Ground plane and power traces.

| Top Layout | 3D Visualization |
| :---: | :---: |
| ![Layout](media/Layout.png) | ![3D View](media/Layout_3D.png) |

---

## 💻 RTL Logic: Code Walkthrough

The logic is divided into modular Verilog components for scalability.

### 1. Ultrasonic Sensor Controller (`ultra_sonic_sensor.v`)
This module handles the real-time distance measurement using the HC-SR04.
- **Step 1: Trigger Generation**: Sends a 10µs pulse to the `trig` pin to start the measurement.
- **Step 2: Echo Timing**: Uses a high-speed counter to measure how long the `echo` pin stays high.
- **Step 3: Distance Calculation**: 
  - Formula: `Distance (cm) = (Time * Speed of Sound) / 2`
  - Verilog Implementation: `distance_cm <= (distanceRAW * 34300) / (2 * 12000000);` (Assuming 12MHz clock).
- **Step 4: Refresher Pulse**: Re-triggers the measurement every 50ms to ensure the robot has fresh data for navigation.

### 2. UART Telemetry (`uart_trx.v`)
A robust 8N1 UART transmitter for sending sensor data back to a PC.
- **State Machine**:
  - `IDLE`: Waits for `senddata` signal.
  - `STARTTX`: Pulls TX low for 1 bit-period.
  - `TXING`: Shifts out 8 bits of data (LSB first).
  - `TXDONE`: Pulls TX high (Stop bit) and signals completion.
- **Baud Rate**: Designed for 9600 baud when clocked correctly.

### 3. Physical Constraints (`VSDSquadronFM.pcf`)
Maps the internal signals to physical FPGA pins:
- **Motors**: Pins 19, 21, 27, 28 (Direction); Pins 31, 32 (PWM).
- **Sensors**: 
  - Front: Pins 2 (Echo), 3 (Trig).
  - Left: Pins 9 (Echo), 6 (Trig).
  - Right: Pins 13 (Echo), 12 (Trig).

---

## 🚀 Getting Started

1. **Clone the Repo**: `git clone https://github.com/gowthamnow/VSD_SQUADRON_SCHOOL_VERSION.git`
2. **Setup Tools**: Install `OSS CAD Suite` or `iCEcube2`.
3. **Compile**: Use `yosys` and `nextpnr` with the provided `.pcf` file.
4. **Flash**: Load the bitstream onto the VSD Squadron FM.

---

## 👨‍🏫 About the Project
This project was developed for school to showcase the power of FPGA-based robotics. It combines electronics, embedded programming, and mechanical design into a single functional unit.
