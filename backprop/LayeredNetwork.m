%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LayeredNetwork: This function simulates a layered Neural network.
% Arguments in order
% 1) data
% 2) target: this is the target value that the NN tries to predict.
% 3) units: A vector whose length specifies the number of leayers. The 
%    numbers in each element represent the number of units in that layer.
%    e.g. [1 5 1] in Layer 1 the input, there is 1 unit. Layer 2 has 5
%    units and layer 3 has 1 output unit.
% 4) learningRate: this is the learning rate.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output] = LayeredNetwork(data,target,units,learningRate)

% initialize the network
%units = [1 5 1];           % units in each layer (includes input/output)
nlayers = length(units);    % number of layers
t = 1:size(data,1);         % "time" index
%input = t/10;              % input
% input = cos(t/50);
%target = cos(t/50);% target output
alpha = learningRate;                 % learning rate

Weights = cell(nlayers-1, 1);
for i = 1 : nlayers-1
    Weights{i} = randn(units(i + 1), units(i) + 1);
end
oldWeights = Weights;

state = cell(nlayers, 1);
state_derivative = cell(nlayers, 1);
error = cell(nlayers, 1);
output = zeros(size(target));
output_prev = zeros(size(target));

% Train network
while(true)    
    for i = 1 : length(t)
        % Forward Propagation
        state{1} = data(i,:)';            % first layer is just the input
        for layer = 2 : nlayers         % forward propagate through network
            layer_input = Weights{layer - 1} * ([state{layer - 1} ; 1]);
            if layer < nlayers
                state{layer} = sigmoid(layer_input);
                state_derivative{layer} = sigmoid(layer_input) .* (1 - sigmoid(layer_input));
            else
                state{layer} = sum(layer_input);
                state_derivative{layer} = [1];
            end
        end
        output(i) = state{nlayers}; % save output state for plotting
        
        % Back Propagation
        % Compute errors
        error{nlayers} = state_derivative{nlayers} .* (state{nlayers} - target(i)); % error at output
        for layer = nlayers - 1 : -1 : 2
            error{layer} = state_derivative{layer} .* Weights{layer}(:, 1 : end-1)' * error{layer + 1};
        end
        % Update Weights
        for layer = 1 : nlayers - 1
            Weights{layer} = Weights{layer} - alpha * error{layer + 1} * [state{layer}; 1]';
        end
    end
    
    % Check stopping condition
    norm_delta = 0;
    for edge = 1 : nlayers - 1
        norm_delta = norm_delta + sum((oldWeights{edge}(:) - Weights{edge}(:)).^2);
    end
    
    disp(['norm of weight change is ' num2str(norm_delta)]);
    if sqrt(norm_delta) < 1E-2
        break;
    end
    disp(['norm of error is ' num2str(norm(output - target)) 10]);

    oldWeights = Weights; 
end

end