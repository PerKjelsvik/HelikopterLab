%% Init
clear all
clc
close all

figNum = 1;
addpath('Data-files')
%

%% TASK 5.1.b ---- Without disturbance
load('omega_1.mat')
load('omega_2.mat')

H_1 = omega_1;
H_2 = omega_2;
t = length(H_1);

w_1 = 0.005;
w_2 = 0.05; 

figure(figNum)
figNum = figNum + 1;
subplot(2,1,1)
plot(H_1(:,1),H_1(:,2))
xlabel('t')
ylabel('H_1(jw)')
title('Sinus with \omega_1 = 0.005 without noise')

subplot(2,1,2)
plot(H_2(:,1),H_2(:,2),'r')
xlabel('t')
ylabel('H_2(jw)')
title('Sinus with \omega_2 = 0.05 without noise')

A_11 = max(H_1(3500:t,2));
A_12 = min(H_1(3500:t,2));
A_21 = max(H_2(3500:t,2));
A_22 = min(H_2(3500:t,2));

A_1 = (A_11-A_12)/2;
A_2 = (A_21-A_22)/2;

K = sqrt((A_1^2*w_1^2- ((A_1^2*A_2^2*w_1^4*w_2^2)/(w_2^4*A_2^2)))/(1-(A_1^2*w_1^4)/(w_2^4*A_2^2)));
T = (sqrt(K^2 - A_2^2*w_2^2))/(w_2^2*A_2);
%

%% TASK 5.1.c ---- with disturbance
load('omega_1_E.mat')
load('omega_2_E.mat')

H_1_E = omega_1_E;
H_2_E = omega_2_E;
t_E = length(H_1_E);

figure(figNum)
figNum = figNum + 1;
subplot(2,1,1)
plot(H_1_E(:,1),H_1_E(:,2))
xlabel('t')
ylabel('H_1(jw)')
title('Sinus with \omega_1 = 0.005 with waves and noise')

subplot(2,1,2)
plot(H_2_E(:,1),H_2_E(:,2),'r')
xlabel('t')
ylabel('H_2(jw)')
title('Sinus with \omega_2 = 0.05 with waves and noise')

A_11_E = max(H_1_E(3500:t_E,2));
A_12_E = min(H_1_E(3500:t_E,2));
A_21_E = max(H_2_E(3500:t_E,2));
A_22_E = min(H_2_E(3500:t_E,2));

A_1_E = (A_11_E - A_12_E)/2;

s_w_2 = 0;

for i=4000:8000
    A_max = max(H_2_E(i-100:i+100,2));
    A_min = min(H_2_E(i-100:i+100,2));
    s_w_2 = s_w_2 + (A_max-A_min)/2;
end

A_2_E = s_w_2/4000;

K_E = sqrt((A_1_E^2*w_1^2- ((A_1_E^2*A_2_E^2*w_1^4*w_2^2)/(w_2^4*A_2_E^2)))/(1-(A_1_E^2*w_1^4)/(w_2^4*A_2_E^2)));
T_E = (sqrt(K_E^2 - A_2_E^2*w_2^2))/(w_2^2*A_2_E);
%

%% TASK 5.1.d ---- Step response
load('step_simulink.mat')

H_tf = tf(K, [T 1 0]);

figure(figNum)
figNum = figNum + 1;
subplot(2,1,1)
H_tf_sim = step_simulink;
plot(H_tf_sim(:,1),H_tf_sim(:,2),'r')
title('Step Response of the ship')
ylabel('Amplitude')
xlabel('Time (seconds)')

subplot(2,1,2)
step(H_tf,length(H_tf_sim)/2)
title('Step response of the model')
%