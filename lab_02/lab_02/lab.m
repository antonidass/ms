% Вариант 11

function lab()
    clc
    X = [-2.54,-0.79,-4.27,-3.09,-3.82,-0.61,-0.64,-1.24,-1.73,-2.91,-1.48,-1.28,-0.37,-1.88,-2.19,-1.61,-1.52,-3.17,-1.36,-3.08,-3.11,-3.07,-1.57,-1.51,-2.37,-0.58,-3.05,-2.93,-1.01,-1.40,-2.06,-3.05,-1.84,-1.24,-1.89,-2.06,-1.59,-2.83,-1.07,-2.96,-3.17,-3.08,-0.49,-3.11,-3.14,-2.30,-3.99,-1.56,-1.28,-3.46,-2.63,-0.82,-2.18,-0.89,-3.08,-1.13,-1.62,-1.06,-2.98,-1.55,-1.49,-1.65,-1.45,-2.29,-0.85,-1.44,-2.87,-2.40,-2.13,-3.52,-1.42,-3.64,-3.47,-2.05,-2.39,-2.07,-0.80,-1.52,-3.92,-2.22,-0.78,-2.60,-1.78,-1.61,-1.65,-2.06,-3.33,-3.41,-1.97,-1.74,-2.04,0.01,-1.37,-3.15,-2.35,-3.66,-1.79,-2.56,-1.87,-1.06,-0.64,-2.49,-1.85,-1.40,-0.86,-0.17,-0.62,-2.85,-2.12,-1.17,-2.48,-1.65,-3.74,-2.87,-3.15,-1.89,-1.34,-4.33,-0.96,-1.79];
      
    % Уровень доверия
    gamma = 0.9;

    % Объем выборки 
    n = length(X);

    % Оценка мат. ожидания 
    mu = sum(X) / n;
    
     % Исправленная выборочная дисперсия
    S2 = sum((X - mu).^ 2) / (n - 1);

    % Нижняя граница доверительного интервала для мат. ожидания
    muLow = findMuLow(n, mu, S2, gamma);
    % Верхняя граница доверительного интервала для мат. ожидания
    muHigh = findMuHigh(n, mu, S2, gamma);

    % Нижняя граница доверительного интервала для дисперсии
    S2Low = findS2Low(n, S2, gamma);
    % Верхняя граница доверительного интервала для дисперсии
    S2High = findS2High(n, S2, gamma);

    % Вывод полученных ранее значений
    fprintf('mu = %.4f\n', mu);
    fprintf('S2 = %.4f\n', S2);
    fprintf('muLow = %.4f\n', muLow);
    fprintf('muHigh = %.4f\n', muHigh);
    fprintf('S2Low = %.4f\n', S2Low);
    fprintf('S2High = %.4f\n', S2High);
    
    % Создание массивов точечных оценок
    muArray = zeros(1, n);
    S2Array = zeros(1, n);
    % Создание массивов границ доверительных интервалов
    muLowArray = zeros(1, n);
    muHighArray = zeros(1, n);
    S2LowArray = zeros(1, n);
    S2HighArray = zeros(1, n);
    
    for i = 1 : n
        mu = sum(X(1:i)) / i;
        S2 = sum((X(1:i) - mu).^ 2) / (i - 1);

        muArray(i) = mu;
        S2Array(i) = S2;
        
        muLowArray(i) = findMuLow(i, mu, S2, gamma);
        muHighArray(i) = findMuHigh(i, mu, S2, gamma);        
        S2LowArray(i) = findS2Low(i, S2, gamma);        
        S2HighArray(i) = findS2High(i, S2, gamma);
    end
    
    % Построение графиков
    muArrayN = zeros(1, n) + mu;

    plot(15 : n, [muArrayN(15:n)', muArray(15 : n)', muLowArray(15 : n)', muHighArray(15 : n)']);
    xlabel('n');
    ylabel('y');
    legend('$\hat \mu(\vec x_N)$', '$\hat \mu(\vec x_n)$', ...
        '$\underline{\mu}(\vec x_n)$', '$\overline{\mu}(\vec x_n)$', ...
        'Interpreter', 'latex', 'FontSize', 18);
    figure;

    S2ArrayN = zeros(1, n) + S2;
    plot(15 : n, [S2ArrayN(15:n)', S2Array(15:n)', S2LowArray(15:n)', S2HighArray(15:n)']);
    xlabel('n');
    ylabel('z');
    legend('$\hat S^2(\vec x_N)$', '$\hat S^2(\vec x_n)$', ...
        '$\underline{\sigma}^2(\vec x_n)$', '$\overline{\sigma}^2(\vec x_n)$', ...
        'Interpreter', 'latex', 'FontSize', 18);
end

% Функция поиска нижней границы доверительного интервала для матожидания
function muLow = findMuLow(n, mu, S2, gamma)
    muLow = mu - sqrt(S2) * tinv((1 + gamma) / 2, n - 1) / sqrt(n);
end

% Функция поиска верхней границы доверительного интервала для матожидания
function muHigh = findMuHigh(n, mu, S2, gamma)
    muHigh = mu + sqrt(S2) * tinv((1 + gamma) / 2, n - 1) / sqrt(n);
end

% Функция поиска нижней границы доверительного интервала для дисперсии
function S2Low = findS2Low(n, S2, gamma)
    S2Low = ((n - 1) * S2) / chi2inv((1 + gamma) / 2, n - 1);
end

% Функция поиска верхней границы доверительного интервала для дисперсии
function S2High = findS2High(n, S2, gamma)
    S2High = ((n - 1) * S2) / chi2inv((1 - gamma) / 2, n - 1);
end
