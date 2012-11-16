% script to simulate a recurrent neural network
clc; clear;

%% initialize simulation
t = 0:25;  % time
sp  = .05;  % sparsity
a = .8;   % amount by which to scale max singular value by

% dimensions
K = 5;       % input feature size
N = 30;     % number of units
L = 1;       % dimension of output

% initialize state, inputs, training example outputs
X = zeros(N, length(t))';        % state
U = zeros(K, length(t))';        % input
Ytrain = zeros(L, length(t))';   % desired output
Y = zeros(L, length(t))';        % actual output
Z = [X U];                       % extended state

X(1,:) = rand(1, N);
% U(5, :) = ones(K, 1)'; % let's give an impulse to the system
U = rand(K, length(t))';
Ytrain = 2 * rand(L, length(t))' - 1; 

Win = 2*rand(N, K) - 1;     % scale between -1 and 1 -- is this necessary?
W = 2*rand(N) - 1;          % recurrent connection weights
Wfb = randn(N, L);          % weights connecting output to units
Wout = zeros(L, N + K);     % weights translating states to output

% sparsify and condition recurrent connections
idx = rand(N);
W(idx > sp) = 0;            
W = a/(norm(W)) * W;        % rescale max singular value

%% run simulation

% training - teacher forcing
for i = 2 : length(t) - 1;
    X(i + 1, :) = sigmoid(Win * U(i, :)' + W * X(i, :)' + Wfb * Ytrain(i, :)')' - .5;
    Z(i, :) = [X(i, :), U(i, :)];
end

% solve for Wout
Wout = Z\Ytrain;

% testing
for i = 2 : length(t) - 1;
    Z(i, :) = [X(i, :), U(i, :)];
    Y(i, :) = Wout' * Z(i, :)' ;
    X(i+1, :) = sigmoid(Win * U(i, :)' + W * X(i, :)' + Wfb * Y(i, :)) - .5;
end


%% plot results
figure(1); clf;
subplot(211); plot(t, X); ylabel('state values', 'fontsize', 14);
subplot(212); plot(t, Y, 'b'); hold on;
plot(t, Ytrain, 'r');
legend('output', 'target'); ylabel('output', 'fontsize', 14); xlabel('Time', 'fontsize', 14); 