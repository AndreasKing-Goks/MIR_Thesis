function Obj_Val = Objective_Function(Est_Var, opt_mode, Est_Scales, simuArgs)
global Param
%% Get the measured data
% Velo mea should span over all the time steps.
% Thus extract the data directly
temp_Velo_Mea = squeeze(Param.NIF_nu_b);
Velo_Mea = temp_Velo_Mea(:, opt_mode);

%% Get the estimation data
% Scales back Estimation_Var_Scaled to Estimation_Var
Est_Var = Est_Var .* Est_Scales;

%% Run Simulink Model
% Extract Simulink arguments
simuModelName = simuArgs{1};
simuModelFileName = simuArgs{2};
dt = simuArgs{3};
stop_time = simuArgs{4};

% Build the simulink parameter block
NIF_AM = zeros(1,6);
NIF_K_l = zeros(1,6);
NIF_K_nl = zeros(1,6);
NIF_Ballast_Force = zeros(6,1);

% Load estimation variable to the simulink block parameter
NIF_AM(1, opt_mode) = Est_Var(1);
NIF_K_l(1, opt_mode) = Est_Var(2);
NIF_K_nl(1, opt_mode) = Est_Var(3);
NIF_Ballast_Force(opt_mode, 1) = Est_Var(4);

% Open System NIF Simulink
open_system(simuModelFileName);

% Set time
set_param(simuModelName, 'StopTime', num2str(stop_time));

% Set block value inside the model
set_param([simuModelName '/Added_Mass'], 'Value', mat2str(NIF_AM))
set_param([simuModelName '/Linear_Damping'], 'Value', mat2str(NIF_K_l))
set_param([simuModelName '/Nonlinear_Damping'], 'Value', mat2str(NIF_K_nl))
set_param([simuModelName '/Ballast_Force'], 'Value', mat2str(NIF_Ballast_Force))

% Full path to the "Ballast" block within the subsystems
ballastBlockPath = [simuModelName '/For Estimation/BlueROV2/Ballast Force in Body Frame/Ballast'];

% Setting the 'Before' and 'After' parameters of the "Ballast" Step block
set_param(ballastBlockPath, 'Before', mat2str(NIF_Ballast_Force));
set_param(ballastBlockPath, 'After', mat2str(NIF_Ballast_Force));

% Run the Simulink model
simOutNIF = sim(simuModelName, 'ReturnWorkspaceOutputs', 'on');

% Get the Velocity
temp_Velo_Est = squeeze(simOutNIF.Est_Velo_B_S)';
Velo_Est = temp_Velo_Est(:, opt_mode);

%% Convergence coefficient
G_delta = 100;

%% Estimation-Measurement Error
Delta = Velo_Est - Velo_Mea;

%% Compute cost value
% Compute the sum-weighted nominator
sum_weight_nominator = Delta' * Delta;
sum_denuminator = Velo_Mea' * Velo_Mea;

% Compute the objective value
Obj_Val = (sum_weight_nominator / sum_denuminator) * G_delta;

%% Handle exploding objective value
if Obj_Val > 100000
    Obj_Val = 100000;
end

end