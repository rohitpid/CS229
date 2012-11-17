%Load the data from the web
%dataLabels = cell(1,7);
%dataLabels = csvread('data.csv',0,0,[0,0,1,6]);
rawdata = csvread('data.csv',1,2);
adjClosePrice = rawdata(:,5);
data = [];
delayby = zeros(length(adjClosePrice),6);
delayby(:,1) = adjClosePrice;
data = [adjClosePrice];
%calculating price of previous day for 5 previous days
for i=2:6
    delayby(:,i) = [delayby(2:end,i-1) ; 0];
    data = [data delayby(:,i)];
end

%calculating moving average (MA)
fiveDayMA = conv(adjClosePrice,ones(1,5))./5;
fiveDayMA = fiveDayMA(5:end-19);
tenDayMA = conv(adjClosePrice,ones(1,10))./10;
tenDayMA = tenDayMA(10:end-19);
twentyDayMA = conv(adjClosePrice,ones(1,20))./20;
twentyDayMA = twentyDayMA(20:end-19);

%remove the last 19 days of data so we don't see weird
%effects of MA filter.

data = data(1:end-19,:);

data = [data fiveDayMA tenDayMA twentyDayMA];
data = data(2:end,:);
target = adjClosePrice(1:651);

%%% data now contains 9 columns which are:
% price, price 1 day ago, price 2 days ago, price 3 days ago,
% price 4 days ago, price 5 days ago, 5 day MA, 10 day MA, 20 day MA

%%% call functions for LayeredNetwork and echo state network
%t = (1:1000)';
%data = t/10;
%target = cos(t/50);
units = [9 5 1];
learningRate = 0.05;
output = LayeredNetwork(data,target,units,learningRate);
plotResults(data,output,target);
