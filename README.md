# PID Anti-Windup: General Back-Calculation

[Open in MATLAB Online](https://matlab.mathworks.com/open/github/v1?repo=simorxb/back-calculation)

## Summary

This project presents a comprehensive comparison of **three PID anti-windup techniques** for saturated control systems:

- Classic Back-Calculation  
- General Back-Calculation  
- Integral Clamping

The repository demonstrates why the classic back-calculation approach becomes mathematically inconsistent when the controller includes additional poles (such as the filtered derivative in a practical PID implementation).  

To address this limitation, the **general back-calculation** method is derived and implemented correctly for a PID controller with filtered derivative, including its discrete-time realisation.  

In addition, **integral clamping** is introduced as a simple and effective anti-windup strategy that prevents integrator windup by conditionally freezing the integral action during actuator saturation.

The project includes:

- Theoretical derivations  
- Continuous-time and discrete-time implementations  
- MATLAB scripts  
- Simulink models  
- Comparative simulation results under actuator saturation and disturbance conditions

This repository provides a practical and rigorous reference for implementing robust **PID anti-windup strategies** in real-world control applications.

## Project Overview

Integral windup is a well-known issue in feedback control systems where actuators are subject to amplitude or slew-rate saturation. When the controller output saturates, the integrator continues accumulating error, often leading to:

- Large overshoot  
- Slow recovery  
- Undesirable transients  
- Performance degradation after the actuator exits saturation

This project provides a rigorous and practical comparison of **three PID anti-windup strategies** implemented on the same plant and tuning:

1. **Classic Back-Calculation**
2. **General Back-Calculation**
3. **Integral Clamping**

---

### Classic Back-Calculation

The classic back-calculation technique feeds an additional signal to the integrator proportional to the difference between the saturated and unsaturated control signals:

$u_{aw} = K_{bc}(u_{sat} - u)$

While widely used, this approach becomes **structurally incorrect** when the controller contains additional poles besides the integrator — such as in the very common **PID with filtered derivative**:

$C(s) = k_p + \frac{k_i}{s} + k_d \frac{s}{\tau s + 1}$

This limitation motivates a more general formulation.

---

### General Back-Calculation

The **general back-calculation** method resolves this issue by separating the controller into:

- A **direct feedthrough term** $C(\infty)$  
- A **dynamic component** $\bar{C}(s)$

so that:

$C(s) = C(\infty) + \bar{C}(s)$

This decomposition ensures that anti-windup compensation is applied consistently to the realizable dynamic part of the controller.

The method is derived for a PID with filtered derivative and implemented in both:

- Continuous time  
- Discrete time (Tustin for the filtered derivative, forward Euler for the integral)

This guarantees mathematical correctness and practical implementability.

---

### Integral Clamping

In addition to back-calculation approaches, the repository introduces **Integral Clamping**, a simple yet highly effective anti-windup strategy.

The integrator is frozen when saturation and error would cause further windup:

- $e > 0$ AND $(u - u_{sat}) > 0$
- $e < 0$ AND $(u - u_{sat}) < 0$

This conditional integration mechanism prevents unnecessary growth of the integral term and significantly improves recovery after saturation.

Unlike back-calculation, clamping does not require additional tuning gains and is straightforward to implement in embedded and discrete-time control systems.

---

### Comparative Perspective

All three techniques are evaluated under identical conditions using:

- A mass–damper plant model  
- Force saturation limits  
- External disturbance injection  
- MATLAB scripts  
- Simulink models

The results clearly show:

- Severe windup without anti-windup  
- Partial improvement with classic back-calculation  
- Excellent and comparable performance from general back-calculation and integral clamping

This repository therefore serves as a complete technical reference for understanding, deriving, discretising, and comparing **PID anti-windup strategies for saturated control systems**.

---

## General Back-Calculation for PID Controllers

Given a PID controller with filtered derivative:

$C(s) = k_p + \frac{k_i}{s} + k_d \frac{s}{\tau s + 1}$

the controller can be rewritten as:

- **Direct feedthrough**
$C(\infty) = k_p + \frac{k_d}{\tau}$
- **Dynamic part**
$\bar{C}(s) = \frac{(k_i \tau + \frac{k_d}{\tau})s + k_i}{s^2 \tau + s}$

The slides (page 5)illustrate the correct general back-calculation block diagram used in this project [PID Anti-Windup - General Back-Calculation - Discretisation.pdf](https://github.com/user-attachments/files/24534980/PID.Anti-Windup.-.General.Back-Calculation.-.Discretisation.pdf).

## General Back-Calculation for PID Controllers - Discretisation

For convenience, we define:

$K = k_i \tau + \frac{k_d}{\tau}$

Now we have:

$\bar{C}(s) = \frac{K s + k_i}{s (\tau s + 1)}$

$\bar{C}(s) = \bar{C_1}(s) \bar{C_2}(s)$, with $\bar{C_1}(s) = \frac{K s + k_i}{\tau s + 1}$ and $\bar{C_2}(s) = \frac{1}{s}$

Using Tustin transformation ($s \leftarrow \frac{2}{T} \frac{z-1}{z+1}$) we have:

$C_1(z) = \frac{(\frac{2 K}{T} + k_i) z + (k_i-\frac{2 K}{T})}{(\frac{2 \tau}{T} + 1) z + (1-\frac{2 \tau}{T})}$

while for $C_2(s)$ we use forward Euler to avoid algebraic loops:

$C_2(z) = \frac{T}{z-1}$.

And we are ready for the discretised general implementation for the PID (slide 7 in [PID Anti-Windup - General Back-Calculation - Discretisation.pdf](https://github.com/user-attachments/files/24534980/PID.Anti-Windup.-.General.Back-Calculation.-.Discretisation.pdf)).

---

## Plant Model

The plant is a mass–damper system:

$m \frac{d^2 z(t)}{dt^2} = F - k \frac{dz(t)}{dt}$

where:

- $m = 10 \text{ kg}$  
- $k = 0.5  \text{Ns/m}$

This model is shown on page 8 of the slides [PID Anti-Windup - General Back-Calculation - Discretisation.pdf](https://github.com/user-attachments/files/24534980/PID.Anti-Windup.-.General.Back-Calculation.-.Discretisation.pdf).

The actuator force is saturated within:

- $F_{\min} = -15 \text{ N}$  
- $F_{\max} = 15 \text{ N}$

A disturbance of **–8 N** is applied at **t = 60 s** during the simulation.

---

## Simulink Implementations

Four controller variants are provided, fully modeled in Simulink (page 9 of the slides [PID Anti-Windup - General Back-Calculation - Discretisation.pdf](https://github.com/user-attachments/files/24534980/PID.Anti-Windup.-.General.Back-Calculation.-.Discretisation.pdf)):

1. **PID - No Anti-Windup**
2. **PID - Classic Back-Calculation**
3. **PID - General Back-Calculation**
4. **PID - General Back-Calculation - Discretised**

These models allow direct comparison of transient performance, control effort, and robustness to saturation and disturbances.

A -8 N disturbance at 60 s is injected.

---

## MATLAB Code

The repository includes:

### **Initialisation Script**

Defines plant parameters, PID gains, derivative filter constant, and anti-windup coefficients (page 10) [PID Anti-Windup - General Back-Calculation - Discretisation.pdf](https://github.com/user-attachments/files/24534980/PID.Anti-Windup.-.General.Back-Calculation.-.Discretisation.pdf)

### **Simulation Runner**

Executes all controller configurations and logs output data (page 11) [PID Anti-Windup - General Back-Calculation - Discretisation.pdf](https://github.com/user-attachments/files/24534980/PID.Anti-Windup.-.General.Back-Calculation.-.Discretisation.pdf)

### **Plotting Scripts**

Plots speed, control input, and integrator behaviour for comparison (page 12) [PID Anti-Windup - General Back-Calculation - Discretisation.pdf](https://github.com/user-attachments/files/24534980/PID.Anti-Windup.-.General.Back-Calculation.-.Discretisation.pdf)

---

## Simulation Results

The simulation results (page 13) show:

- **PID without anti-windup** → severe windup, long recovery time  
- **Classic back-calculation** → partial improvement
- **General back-calculation** → best performance (for both the continuous and discrete time implementation)

---

## Integral Clamping and Anti-Windup Comparison

In addition to the classic and general back-calculation techniques, this project also implements and compares a third anti-windup strategy: **Integral Clamping**.

### What is Integral Clamping?

Integral clamping is a simple and effective anti-windup technique that **freezes the integrator state** when actuator saturation would cause further windup.

The integration is stopped if one of the following conditions is satisfied:

- $e > 0$ AND $(u - u_{sat}) > 0$  
- $e < 0$ AND $(u - u_{sat}) < 0$

where:

- $e$ is the control error  
- $u$ is the unsaturated controller output  
- $u_{sat}$ is the saturated control signal

In other words, when the actuator is saturated and the error would push the integrator further in the *wrong direction*, the integral action is temporarily disabled.

This prevents excessive accumulation of the integral term and significantly reduces recovery time once the actuator exits saturation.

---

### Discrete-Time Implementation

The discrete-time PID controller uses:

- **Tustin transformation** for the filtered derivative  
- **Forward Euler** for the integral term (to avoid algebraic loops)

This ensures consistency with the discretised general back-calculation implementation already presented in the repository.

---

### Simulation Setup

The comparison includes four controller configurations:

1. **PID – No Anti-Windup**
2. **PID – Classic Back-Calculation**
3. **PID – General Back-Calculation**
4. **PID – Integral Clamping**

The plant is a mass–damper system:

$m \frac{d^2 z(t)}{dt^2} = F - k \frac{dz(t)}{dt}$

with:

- $m = 10  \text{kg}$
- $k = 0.5  \text{Ns/m}$

The actuator force is saturated between:

- $F_{\min} = -15  \text{N}$
- $F_{\max} = 15  \text{N}$

A disturbance of **–8 N** is applied at **t = 120 s**.

---

### Results and Discussion

The simulations show that:

- **No anti-windup** leads to severe integrator windup and long recovery times.
- **Classic back-calculation** improves the response but does not fully address structural issues when additional controller poles are present.
- **General back-calculation** and **Integral Clamping** exhibit excellent and comparable performance in this case.

While this result is specific to the considered plant and tuning, the analysis highlights two important conclusions:

1. The **classic back-calculation implementation is mathematically inconsistent** when applied to controllers with additional poles (e.g., PID with filtered derivative).
2. Both **general back-calculation** and **integral clamping** provide robust and practical anti-windup solutions for saturated PID control systems.

This comparison offers a clear and practical perspective on PID anti-windup strategies in both continuous-time and discrete-time implementations using MATLAB and Simulink.

---

# Part 2 – Model Predictive Control vs PID Anti-Windup

## Summary

This part extends the discrete-time speed-control study by adding a **linear Model Predictive Controller (MPC)** on the same mass–damper plant with force saturation and unmeasured disturbance. Using MATLAB, Simulink, and the Model Predictive Control Toolbox, MPC is benchmarked against the two best-performing PID anti-windup strategies from Part 1: **integral clamping** and **general back-calculation**.

## Project Overview

While PID anti-windup methods address integrator windup after saturation, MPC handles actuator limits **directly in the optimization problem** by constraining the manipulated variable over a prediction horizon. The controller is configured on a first-order velocity model derived from the mass–damper dynamics, with an unmeasured-disturbance model to improve rejection of the step load applied during simulation.

The Simulink model `speed_control_disc_mpc.slx` reuses the same plant, reference, and disturbance profile as the discrete PID comparison, switching between integral clamping, general back-calculation, and MPC via a controller-type selector. This keeps the comparison fair and highlights how predictive control behaves relative to tuned PID strategies under identical saturation and disturbance conditions.

### Key Features

- **Linear MPC design** with explicit force bounds and output limits on vehicle speed.
- **Unmeasured disturbance model** for robust rejection of the applied load step.
- **Side-by-side Simulink comparison** of MPC, integral clamping, and general back-calculation.
- **MATLAB automation** to run all configurations and plot speed and saturated control effort.

## MPC Design

The MPC plant is the velocity form of the mass–damper system:

$$
\frac{dv}{dt} = -\frac{k}{m} v + \frac{1}{m} F + \frac{1}{m} F_d
$$

Where:

- $v$: vehicle speed (m/s)
- $F$: control force (N), the manipulated variable
- $F_d$: external disturbance (N), modeled as an unmeasured input
- $m = 10$ kg, $k = 0.5$ Ns/m (from `init.m`)

The state-space realization uses $x = v$, with force and disturbance as inputs and speed as the measured output.

### Controller Parameters

- **Sample time**: 0.1 s
- **Prediction horizon**: 20 steps
- **Control horizon**: 15 steps
- **Force limits**: $F_{\min} = -15$ N, $F_{\max} = 15$ N
- **Output limits**: 0–30 m/s
- **Weights**: output tracking 1, MV rate 0.1, MV absolute 0
- **Disturbance model**: unmeasured input with high observer gain ($C = 10^6$) for load rejection

## Simulation Setup

Three controller configurations are evaluated in `run_simulation_disc_mpc.m`:

1. **PID – Integral Clamping** (`ctrl_type = 1`)
2. **PID – General Back-Calculation** (`ctrl_type = 3`)
3. **MPC** (`ctrl_type = 4`)

Each run uses the same saturated actuator, reference trajectory, and disturbance injection as the discrete PID models in Part 1.

## Files

- `**init_mpc.m`**: builds the linear plant model, MPC object, and disturbance estimator settings.
- `**speed_control_disc_mpc.slx**`: Simulink model with selectable PID anti-windup or MPC controller blocks.
- `**run_simulation_disc_mpc.m**`: runs all three configurations and logs speed, force, and reference signals.
- `**plot_results_2.m**`: plots speed tracking and saturated force for the MPC comparison run.

### Typical run

1. Run `init`
2. Run `init_mpc`
3. Run `run_simulation_disc_mpc`
4. Run `plot_results_2`

## Key Takeaways

- **MPC enforces saturation proactively** through optimization constraints rather than compensating integrator windup after the fact.
- **Predictive disturbance handling** via the unmeasured-input model improves load rejection.
- **Direct comparison on one plant** shows how MPC stacks up against the strongest PID anti-windup options under the same limits and disturbance.

## Author

This project is developed by Simone Bertoni. Learn more about my work on my personal website - [Simone Bertoni - Control Lab](https://simonebertonilab.com/).

## Contact

For further communication, connect with me on [LinkedIn](https://www.linkedin.com/in/simone-bertoni-control-eng/).