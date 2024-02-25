function [g0] = Ballast_Term(Ballast_Config)
% Create storage for the ballast term
g0 = zeros(6,1);

% Compute the ballast term
for i = 1:numel(Ballast_Config)
    % Check if Ballast_Config{i} is a non-empty cell and if its content is not equal to 0
    % if iscell(Ballast_Config{i}) && ~isempty(Ballast_Config{i}) && Ballast_Config{i}{1} ~= 0
    if ~isempty(Ballast_Config{i})
        % Unpack
        rho = Ballast_Config{i}{4};
        Vol = Ballast_Config{i}{3};
        x = Ballast_Config{i}{1}{1}(1);
        y = Ballast_Config{i}{1}{1}(2);
        z = Ballast_Config{i}{1}{1}(3);
        g = 9.81;

        % Compute
        Z_Ballast = rho * g * Vol;
        K_Ballast = rho * g * y * Vol;
        M_Ballast = rho * g * x * Vol;

        % Store
        g0(3) = g0(3) - Z_Ballast;
        g0(4) = g0(4) - K_Ballast;
        g0(5) = g0(5) - M_Ballast;
    else
        % Skip if Ballast_Config{i} is empty or its content is 0
        continue;
    end
end

