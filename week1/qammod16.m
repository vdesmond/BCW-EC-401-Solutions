function y = qammod16(x)
    len = length(x);
    y = zeros(len, 1);
    for i = 1:len
        switch x(i)
            case 0
                y(i) = -3.0 + 1.0i;
            case 1
                y(i) = -3.0 - 3.0i;
            case 2
                y(i) = -3.0 - 1.0i;
            case 3
                y(i) = -1.0 + 3.0i;
            case 4
                y(i) = -3.0 + 3.0i;
            case 5
                y(i) = -1.0 + 1.0i;
            case 6
                y(i) = -1.0 - 3.0i;
            case 7
                y(i) = -1.0 - 1.0i;
            case 8
                y(i) = 3.0 + 3.0i;
            case 9
                y(i) = 3.0 + 1.0i;
            case 10
                y(i) = 3.0 - 3.0i;
            case 11
                y(i) = 3.0 - 1.0i;
            case 12
                y(i) = 1.0 + 3.0i;
            case 13
                y(i) = 1.0 + 1.0i;
            case 14
                y(i) = 1.0 - 3.0i;
            case 15
                y(i) = 1.0 - 1.0i;
        end
    end
end
