% cross-bridge activation, force generation, coupled

function dY = muscleforcefat_ode(t, y, t_stim, num_p)
global tau_c tau_2 tau_fat A_rest K_mrest tau_1rest alpha_A alpha_K_m alpha_tau_1;

SUM = 0;
R_0 = 2;

n = floor(t / t_stim) + 1; % determine n-pulse in current time, t

if n <= num_p
    n = n; % current n-pulse
else
    n = num_p; % final n-pulse
end

for i = 1:n % summation term for t_i of n-pulse
    sum = (1 + (R_0 - 1) * exp(-(t_stim) / tau_c)) * exp(-((t - t_stim * (i - 1)) / tau_c));
    SUM = SUM + sum;
end

% y(1) = C_N
% y(2) = F
% y(3) = A
% y(4) = K_m
% y(5) = tau_1

dC_N = (1 / tau_c) * SUM - (y(1) / tau_c); % dC_N/dt
dF = y(3) * (y(1) / (y(4) + y(1))) - (y(2) / (y(5) + (tau_2 * (y(1) / (y(4) + y(1)))))); % dF/dt
dA = -((y(3) - A_rest) / tau_fat) + alpha_A * y(2); % dA/dt
dK_m = -((y(4) - K_mrest) / tau_fat) + alpha_K_m * y(2); % dK_m/dt
dtau_1 = -((y(5) - tau_1rest) / tau_fat) + alpha_tau_1 * y(2); % dtau_1/dt
dY = [dC_N; dF; dA; dK_m; dtau_1]; % coupling odes