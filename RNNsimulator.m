% script to simulate a recurrent neural network
clc; clear;

%% initialize simulation
t = 0:20;   % time
sp = .05;   % sparsity
a = .8;     % amount by which to scale max singular value by

% dimensions
K = 5;      % input feature size
N = 10;     % number of units
L = 1;      % dimension of output

% allocate memory
X = zeros(length(t), N);        % state
U = zeros(length(t), K);        % input
Ytrain = zeros(length(t), L);   % desired output
Y = zeros(length(t), L);        % actual output
Z = zeros(length(t), N + K);    % extended state
Win = zeros(N, K);              % input weights
W = zeros(N, N);                % recurrent weights
% Wout = zeros(L, N + K);          % output weights
Wout = zeros(L, N);          % output weights

% Initialize states and set inputs
X(1,:) = 2*rand(1, N) - 1;
% U(5, :) = ones(K, 1)'; % impulse input to the system
U = rand(length(t), K); % random network
Ytrain = 2 * rand(length(t), L) - 1; 

Win = 2*rand(N, K) - 1;     % scale between -1 and 1 -- is this necessary?
W = 2*rand(N) - 1;          % recurrent connection weights
Wfb = randn(N, L);          % weights connecting output to units

% sparsify and condition recurrent connections
idx = rand(N);
W(idx > sp) = 0;            
W = a/(norm(W)) * W;        % rescale max singular value

%% run simulation

% training - teacher forcing
for i = 1 : length(t) - 1;
    X(i + 1, :) = sigmoid(Win * U(i, :)' + W * X(i, :)' + Wfb * Ytrain(i, :)')' - .5;
end
Z = [X, U];         % extended state matrix
Wout = Z\Ytrain;    % solve for Wout

% Can the network produce the training data?

for i = 1 : length(t);
    Z(i, :) = [X(i, :), U(i, :)];
    Y(i, :) = Wout' * Z(i, :)' ;
    if i < length(t)
        X(i+1, :) = sigmoid(Win * U(i, :)' + W * X(i, :)' + Wfb * Y(i, :)) - .5;
    end
end


%% plot results
figure(1); clf;
subplot(211); plot(t, X); ylabel('state values', 'fontsize', 14);
subplot(212); plot(t, Y, 'b'); hold on;
plot(t, Ytrain, 'r');
legend('output', 'target'); ylabel('output', 'fontsize', 14); xlabel('Time', 'fontsize', 14); 