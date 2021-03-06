%%%% M CIRCLE, N REFERENCE POINT %%%%

clear all;
close all;

% Initial Situation

% Guess Points
A = [1 7];
B = [8 9];

% Reference Points
Ps = generatePoints(8);

% Centers
C = [5, 6.3];
C2 = [5, 3.7];
C3 = [5, 8];
C4 = [5, 9];
C5 = [5, 10];
C6 = [5, 2];
C7 = [5, 1];
C8 = [5, 0];
Crect = [C, C2, C3, C4, C5, C6, C7, C8];
Cg = generatePoints(3);

Cs = [Crect, Cg];
radius = 0.7;

% Plot Grid
figure(1);
xlim([0, 10]);
ylim([0, 10]);
grid on
axis square;

% Plot Guess Points
hold on
plot(A(1), A(2), 'x', 'Color', 'b');
plot(B(1), B(2), 'x', 'Color', 'b');

% Plot Walls
rectangle('Position',[4 0 2 4], 'EdgeColor', 'r', 'LineWidth', 2, 'FaceColor',[0.9 0.9 0.9]);
rectangle('Position',[4 6 2 4], 'EdgeColor', 'r', 'LineWidth', 2, 'FaceColor',[0.9 0.9 0.9]);

% Plot Circles
for iter=1:2:length(Cg)
    circle = [Cg(iter), Cg(iter+1)];
    viscircles(circle, radius, 'Color', 'r', 'LineWidth', 1);
end

% Plot Reference Points
for iter=1:2:length(Ps)
    % Create temporary variable due to arrays not beinge reindexable
    tempPs = [Ps(iter), Ps(iter+1)];
    plot(tempPs(1), tempPs(2), 'o', 'Color', 'r');
end

lines = [A, Ps, B];

for iter=1:2:(length(lines)-2)
    tempA = [lines(iter), lines(iter+1)];
    tempB = [lines(iter+2), lines(iter+3)];
    plot([tempA(1), tempB(1)], [tempA(2), tempB(2)], '--', 'Color', 'r', 'LineWidth', 1.5);
end

% Optimisation Process
Lb = [];
Ub = [];

for index=1:2:(length(Ps))
    if (index/length(Ps) < 0.33)
        Lb = [Lb, 0, 0];
        Ub = [Ub, 4, 10];
    elseif (index/length(Ps) > 0.66)
        Lb = [Lb, 6, 0];
        Ub = [Ub, 10, 10];    
    else
        Lb = [Lb, 4, 4];
        Ub = [Ub, 6, 6]; 
    end      
end

x0 = Ps;

obj = @(x)objective(x, A, B);
cons = @(x)constraints(x, A, B, Cs, radius);


options = optimset('Display', 'iter', 'TolX', 1*exp(-6), 'TolFun', 1*exp(-6), 'MaxIter', 200, 'MaxFunEvals', 1000);
x = fmincon(obj, x0, [], [], [], [], Lb, Ub, cons, options);

% Plot adjusted reference points X
for iter=1:2:length(x)
    % Create temporary variable due to arrays not beinge reindexable
    tempX = [x(iter), x(iter+1)];
    plot(tempX(1), tempX(2), 'o', 'Color', 'b');
end

% Plot lines
lines = [A, x, B];
for iter=1:2:length(lines)-2
    plot([lines(iter), lines(iter+2)], [lines(iter+1), lines(iter+3)], 'b', 'LineWidth', 2);
end

function p = randomPoint()
    rdn_x = 10*rand;
    rdn_y = 10*rand;
    while((rdn_y <= 4 && rdn_x <= 6 && rdn_x >= 4) || (rdn_y >= 6 && rdn_x <= 6 && rdn_x >= 4))
        rdn_x = 10*rand;
        rdn_y = 10*rand;
    end
    p = [rdn_x, rdn_y];
end

function pts = generatePoints(n)
    pts = [];
    for i=1:n
        pt = randomPoint();
        res = ismember(pt, pts);
        i = 0;
        while res == true
            pt = randomPoint();
            res = ismember(pt, pts);
            i = i + 1;
            if i > 50
                break;
            end
        end
        pts = [pts pt];
    end
end
                



