%% Plant
% dv/dt = -k/m * v + 1/m * F + 1/m * Fd
%
% State: x = v (velocity)

% State space model
A = -k/m;
B = [1/m 1/m];
C = 1;
D = [0 0];

% Create state-space model object
object_sys = ss(A, B, C, D);
object_sys = setmpcsignals(object_sys,'MV', 1,'UD', 2, 'MO', 1);

%% Create MPC object
MV = struct('Min', F_min, 'Max', F_max, 'ScaleFactor', F_max);
OV = struct('Min', 0, 'Max', 30, 'ScaleFactor', 30);
Weights = struct('MV', 0, 'MVRate', 0.1, 'OV', 1);
Ts = 0.1;
mpcobj = mpc(object_sys, Ts, 20, 15, Weights, MV, OV);

indist = getindist(mpcobj);
indist.C = 1e6;
setindist(mpcobj, "model", indist);