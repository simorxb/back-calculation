# PID Anti-Windup: General Back-Calculation

## Summary
This project demonstrates the *general back-calculation* anti-windup technique for PID controllers, addressing the limitations of the classic anti-windup implementation - especially when the controller includes additional poles, such as the filtered derivative. The repository provides MATLAB code, Simulink models, and slides ([PID Anti-Windup - General Back-Calculation.pdf](https://github.com/user-attachments/files/23789622/PID.Anti-Windup.-.General.Back-Calculation.pdf)) illustrating theory, implementation, and simulation results.

## Project Overview
Integral windup is a common issue in feedback control systems where actuators experience amplitude or slew-rate saturation. When the controller output saturates, the integrator continues accumulating error, often leading to overshoot, sluggish recovery, and degraded transient response.  
The *classic back-calculation* technique partially mitigates this by feeding an additional term to the integrator proportional to the difference between the saturated and unsaturated control signals.

However, the classic implementation becomes **incorrect** when the controller contains poles besides the integrator - such as in the widely used *PID with filtered derivative* (implemented as $\frac{s}{\tau s + 1}$).  
To address this, the **general back-calculation** approach separates the controller transfer function into:

- **Direct feedthrough**: $C(\infty)$  
- **Dynamic component**: $\bar{C}(s)$  

so that:

$C(s) = C(\infty) + \bar{C}(s)$

This method ensures correct anti-windup behavior for a general controller structure where the dynamic part is realizable. The complete block diagram is shown in the slides at page 4 ([PID Anti-Windup - General Back-Calculation.pdf](https://github.com/user-attachments/files/23789622/PID.Anti-Windup.-.General.Back-Calculation.pdf))

---

## General Back-Calculation for PID Controllers
Given a PID controller with filtered derivative:

$C(s) = k_p + \frac{k_i}{s} + k_d \frac{s}{\tau s + 1}$

the controller can be rewritten as:

- **Direct feedthrough**
  $C(\infty) = k_p + \frac{k_d}{\tau}$
- **Dynamic part**
  $\bar{C}(s) = \frac{(k_i \tau + \frac{k_d}{\tau})s + k_i}{s^2 \tau + s}$

The slides (page 5)illustrate the correct general back-calculation block diagram used in this project [PID Anti-Windup - General Back-Calculation.pdf](https://github.com/user-attachments/files/23789622/PID.Anti-Windup.-.General.Back-Calculation.pdf).

---

## Plant Model
The plant is a mass–damper system:

$m \frac{d^2 z(t)}{dt^2} = F - k \frac{dz(t)}{dt}$

where:

- $m = 10 \text{ kg}$  
- $k = 0.5 \, \text{N·s/m}$  

This model is shown on page 6 of the slides [PID Anti-Windup - General Back-Calculation.pdf](https://github.com/user-attachments/files/23789622/PID.Anti-Windup.-.General.Back-Calculation.pdf).

The actuator force is saturated within:

- $F_{\min} = -15 \text{ N}$  
- $F_{\max} = 15 \text{ N}$  

A disturbance of **–8 N** is applied at **t = 60 s** during the simulation.

---

## Simulink Implementations
Three controller variants are provided, fully modeled in Simulink (page 7 of the slides [PID Anti-Windup - General Back-Calculation.pdf](https://github.com/user-attachments/files/23789622/PID.Anti-Windup.-.General.Back-Calculation.pdf)):

1. **PID — No Anti-Windup**  
2. **PID — Classic Back-Calculation**  
3. **PID — General Back-Calculation**

These models allow direct comparison of transient performance, control effort, and robustness to saturation and disturbances.

A -8 N disturbance at 60 s is injected.

---

## MATLAB Code
The repository includes:

### **Initialisation Script**
Defines plant parameters, PID gains, derivative filter constant, and anti-windup coefficients (page 8) [PID Anti-Windup - General Back-Calculation.pdf](https://github.com/user-attachments/files/23789622/PID.Anti-Windup.-.General.Back-Calculation.pdf)

### **Simulation Runner**
Executes all controller configurations and logs output data (page 9) [PID Anti-Windup - General Back-Calculation.pdf](https://github.com/user-attachments/files/23789622/PID.Anti-Windup.-.General.Back-Calculation.pdf)

### **Plotting Scripts**
Plots displacement, control input, and integrator behaviour for comparison (page 10) [PID Anti-Windup - General Back-Calculation.pdf](https://github.com/user-attachments/files/23789622/PID.Anti-Windup.-.General.Back-Calculation.pdf)

---

## Simulation Results
The simulation results (page 11) show:

- **PID without anti-windup** → severe windup, long recovery time  
- **Classic back-calculation** → partial improvement
- **General back-calculation** → best performance

---

## Author
This project is developed by **Simone Bertoni**.  
Learn more at: **[simonebertonilab.com](https://simonebertonilab.com/)**

## Contact
For further communication, connect on **LinkedIn**:  
https://www.linkedin.com/in/simone-bertoni-control-eng/
