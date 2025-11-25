%% Plant

% System parameters
m = 10;
k = 0.5;

% Controller parameters
kp = 20;
ki = 3;
kd = 5;
tau = 0.1;
kbc = 1/(kp+kd/tau);
F_max = 15;
F_min = -15;


