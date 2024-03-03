%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init                                                                    %
%                                                                         %
% Initialize workspace                                                    %
%                                                                         %
% Created:      13.02.2024	Andreas Sitorus                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
%% Add Path
% Current dir
currentDir = fileparts(mfilename('fullpath'));

% Add the 'Util' path
addpath(fullfile(currentDir, 'Util'));

% Add the 'Ballast_Config_Input' path
addpath(fullfile(currentDir, 'Ballast_Config_Input'));

% Add the 'Thruster_Dynamic' path
addpath(fullfile(currentDir, 'Thruster_Dynamic'));

% Add the 'Forces_setpoint' path
addpath(fullfile(currentDir, 'Reference_Model'));

% Add 'Save_and_Plot' path
addpath(fullfile(currentDir, 'Save_and_Plot'));

%% Initialize Workspace
Param = BlueROV2_param();

%% Timestep
dt = 0.01;  %-----To set

%% Input Force in Body Frame
Input_F = [0; 0; 0];       % Forces in x-axis, y-axis, and z-axis (Body Frame)
F_Coord = [0; 0; 0];       % External forces exerted on the top of the sphere, in line with the center of gravity

Ex_Force = Command_Force(Input_F, F_Coord);
impulse_time = 0.001;

%% Initial Condition
% States
Pos_N = Param.IC.Pos;
Velo_B = Param.IC.Velo;

% Thruster Dynamics
upper_limit = 30;
lower_limit = -upper_limit;
thrust_rate = 5;

%% Reference Model Parameters
set_points = {[0, 0], [100, 20], [100, 40], [500, 60], [550, 80], [1000, 90], [1000, 110], [300, 120], [300, 125], [100, 130], [500, 140], [300, 145], [300, 150], [0, 160]};
step_value = dt;

[resampled_model, resampled_time, stop_time] = Reference_Model(set_points,step_value);

% Set the stop time of your Simulink model
set_param('BlueROV2_Exp_Simu', 'StopTime', num2str(stop_time));


%% Controller Model Parameters (PID)
% Kp = [75459.3345349083; 277551.73586971; 120744473.878042];
% Ki = [137.081306245593; 3163.274947400198; 335358.448218978];
% Kd = [1660451.40544401; 3920391.80535684; 1605063439.04156];

%% Extended Kalman Filter Parameters
[inv_M, B, H, R, Q, dt, inv_Tb, Gamma_o] = EKF_param(dt);

%% Ballast Force
% How to use:
% Each element in the cell indicates the hook number.
% Assign the "Ballast Code" to the cell's element to attach the ballast.
% Ballast Code [dtype=string | 0 means unassigned]:
% -"FS" - Small Floater
% -"FM" - Medium Floater
% -"FL" - Large Floater
% -"WS" - Small Weight
% -"WM" - Medium Weight
% -"WL" - Large Weight 

prompt = {0 0 0 'FS' 'FS' 0 0 0 0};

[Ballast_Config, Hook_Encoding] = Ballast_Configuration(prompt);

%Ballast_Force = zeros(6,1);
Ballast_Force = Ballast_Term(Ballast_Config);

%% Thruster Force
Thruster_Force = zeros(6,1);

%% Environment Force
Env_Force = zeros(6,1);

%% Tether Force
Tether_Force = zeros(6,1);

%% Sphere Dynamic Model [FOR CHECKING]
Acc_G = BlueROV2_acc(Ballast_Force, Thruster_Force, Tether_Force, Pos_N, Velo_B)

%% HELP READING Acceleration result
% Forces defined in NED at first, then transformed to the body coordinate
% Thus, positive sign means downwards
% Positive acceleration means Negatively Buoyant
% Negative acceleration means Positively Buoyant

%% UNUSED
% MANUAL REFERENCE MODEL
% ti = [1/100, 1/100, 1/100, 1/200, 1/200, 1/200];      %-----TUNE 
% Af = diag(ti);
% 
% omega_is = [0.2, 0.2, 0.2, 0.2, 0.2, 0.2];      %-----TUNE 
% zeta_is = [1.5, 1.5, 1.5, 1.5, 1.5, 1.5];       %-----TUNE 
% 
% Gamma = diag(omega_is);
% Omega = diag(2*omega_is.*zeta_is);
% 
% change_position_time = 800;