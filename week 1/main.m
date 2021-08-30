M = 16;
x = randi([0 M - 1], 100, 1);
y = qammod16(x);
scatterplot(y);
