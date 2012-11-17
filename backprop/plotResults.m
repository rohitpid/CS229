function plotResults(input,output,target)
    figure(1); clf;
    t = 1:size(input,1);
    subplot(212); plot(t, input, 'linewidth', 2); hold on;
    subplot(211); plot(t, target, 'r:', 'linewidth', 2); hold on; 
    plot(t, output, 'g', 'linewidth', 1);
end