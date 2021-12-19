clc
clear all
close all

x = [0.1:1/22:1];
y = (1 + 0.6*sin(2*pi*x/0.7) + 0.3*sin(2*pi*x))./2;
figure(); plot(x,y,'b*'), grid on

n = 0.05;

% Paslėptojo sluoksnio ryšių svoriai

w11_1 = randn(1)*0.1;
w21_1 = randn(1)*0.1;
w31_1 = randn(1)*0.1;
w41_1 = randn(1)*0.1;

b1_1 = randn(1)*0.1;
b2_1 = randn(1)*0.1;
b3_1 = randn(1)*0.1;
b4_1 = randn(1)*0.1;

% Išėjimo sluoksnio ryšių svoriai

w11_2 = randn(1)*0.1;
w12_2 = randn(1)*0.1;
w13_2 = randn(1)*0.1;
w14_2 = randn(1)*0.1;

b1_2 = randn(1)*0.1;

% Tinklo atsako skaičiavimas
for j = 1:1000000
    for i = 1:length(x)
        % Paslėptojo sluoksnio neuronams
        v1_1 = x(i)*w11_1+b1_1;
        v2_1 = x(i)*w21_1+b2_1;
        v3_1 = x(i)*w31_1+b3_1;
        v4_1 = x(i)*w41_1+b4_1;
    
        y1_1 = 1/(1+exp(-v1_1));
        y2_1 = 1/(1+exp(-v2_1));
        y3_1 = 1/(1+exp(-v3_1));
        y4_1 = 1/(1+exp(-v4_1));
        
        % Išėjimo sluoksnio neuronui
        v1_2 = y1_1*w11_2 + y2_1*w12_2 + y3_1*w13_2 + y4_1*w14_2 + b1_2;
        % Pritaikoma aktyvavimo funkcija
        y1_2 = v1_2;
    
        % Klaidos skaičiavimas
        e = y(i) - y1_2;
    
        % Ryšių svorių atnaujinimas
        % Klaidos gradientas išėjimo sluoksniui
        delta1_2 = e;
        % Klaidos gradientas paslėptajam sluoksniui
        delta1_1 = y1_1*(1-y1_1)*delta1_2*w11_2;
        delta2_1 = y2_1*(1-y2_1)*delta1_2*w12_2;
        delta3_1 = y3_1*(1-y3_1)*delta1_2*w13_2;
        delta4_1 = y4_1*(1-y4_1)*delta1_2*w14_2;
        % Išėjimo sluoksnio svorių atnaujinimas 
        w11_2 = w11_2 + n*delta1_2*y1_1;
        w12_2 = w12_2 + n*delta1_2*y2_1;
        w13_2 = w13_2 + n*delta1_2*y3_1;
        w14_2 = w14_2 + n*delta1_2*y4_1;
        b1_2 = b1_2 + n*delta1_2;
        % Paslėptojo sluoksnio svorių atnaujinimas 
        w11_1 = w11_1 + n*delta1_1*x(i);
        w21_1 = w21_1 + n*delta2_1*x(i);
        w31_1 = w31_1 + n*delta3_1*x(i);
        w41_1 = w41_1 + n*delta4_1*x(i);
        
        b1_1 = b1_1 + n*delta1_1;
        b2_1 = b2_1 + n*delta2_1;
        b3_1 = b3_1 + n*delta3_1;
        b4_1 = b4_1 + n*delta4_1;
    end
end

Y = zeros(1, length(y));
X = [0.1:1/220:1];

for i = 1:length(X)
    % Pirmojo sluoksnio neuronams
    v1_1 = X(i)*w11_1+b1_1;
    v2_1 = X(i)*w21_1+b2_1;
    v3_1 = X(i)*w31_1+b3_1;
    v4_1 = X(i)*w41_1+b4_1;

    y1_1 = 1/(1+exp(-v1_1));
    y2_1 = 1/(1+exp(-v2_1));
    y3_1 = 1/(1+exp(-v3_1));
    y4_1 = 1/(1+exp(-v4_1));
    
    % Išėjimo sluoksnio neuronui
    v1_2 = y1_1*w11_2 + y2_1*w12_2 + y3_1*w13_2 + y4_1*w14_2 + b1_2;
    
    % Pritaikoma aktyvavimo funkcija
    y1_2 = v1_2;
    % Klaidos skaičiavimas
    Y(i) = y1_2;
end

hold on
plot(X, Y, 'g+')