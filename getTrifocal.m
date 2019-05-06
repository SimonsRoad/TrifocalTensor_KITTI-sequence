function [Tri] = getTrifocal( m1, m2, m3, m4, m5, m6 )
%m1, m2, m3, m4, m5, m6 are the 6 matches(structs) input
%   mi.a1 mi.a2 mi.a3 are the 3 image points
    
    lambda1 = inv([m1.a1, m2.a1, m3.a1])*m4.a1;
    B1 = inv([lambda1(1)*m1.a1, lambda1(2)*m2.a1, lambda1(3)*m3.a1]);
    %{
    fprintf('\n***** 1 ****\n\n');
    lambda1
    m1.a1
    m2.a1
    
    m3.a1
    m4.a1
    B1
    %}
    lambda2 = inv([m1.a2, m2.a2, m3.a2])*m4.a2;
    B2 = inv([lambda2(1)*m1.a2, lambda2(2)*m2.a2, lambda2(3)*m3.a2]);
    %{
    fprintf('\n***** 2 ****\n\n');
    lambda2
    m1.a2
    m2.a2
    m3.a2
    m4.a2
    B2
    %}
    lambda3 = inv([m1.a3, m2.a3, m3.a3])*m4.a3;
    B3 = inv([lambda3(1)*m1.a3, lambda3(2)*m2.a3, lambda3(3)*m3.a3]);
    %{
    fprintf('\n***** 3 ****\n\n');
    lambda3
    m1.a3
    m2.a3
    m3.a3
    m4.a2
    B3
    %}
    X5 = struct;
    X5.a1 = B1*m5.a1;
    X5.a2 = B2*m5.a2;
    X5.a3 = B3*m5.a3;
    
    X6 = struct;
    X6.a1 = B1*m6.a1;
    X6.a2 = B2*m6.a2;
    X6.a3 = B3*m6.a3;
    
    Matrix = zeros(3, 5); 
    x5 = X5.a1(1);
    y5 = X5.a1(2);
    w5 = X5.a1(3);
    
    x6 = X6.a1(1);
    y6 = X6.a1(2);
    w6 = X6.a1(3);
    
    Matrix(1,:) = [-x5*y6 + x5*w6, x6*y5 - y5*w6, -x6*w5 + y6*w5, ...
                    -x5*w6 + y5*w6, x5*y6 - y6*w5 ];
                
    x5 = X5.a2(1);
    y5 = X5.a2(2);
    w5 = X5.a2(3);
    
    x6 = X6.a2(1);
    y6 = X6.a2(2);
    w6 = X6.a2(3);
    
    Matrix(2,:) = [-x5*y6 + x5*w6, x6*y5 - y5*w6, -x6*w5 + y6*w5, ...
                    -x5*w6 + y5*w6, x5*y6 - y6*w5 ];
    x5 = X5.a3(1);
    y5 = X5.a3(2);
    w5 = X5.a3(3);
    
    x6 = X6.a3(1);
    y6 = X6.a3(2);
    w6 = X6.a3(3);
    
    Matrix(3,:) = [-x5*y6 + x5*w6, x6*y5 - y5*w6, -x6*w5 + y6*w5, ...
                    -x5*w6 + y5*w6, x5*y6 - y6*w5 ];
                    
    [~, ~, V] = svd(Matrix);
    
    T1 = V(:, end-1);
    T2 = V(:, end);
    
    a1 = T1(1);
    a2 = T1(2);
    a3 = T1(3);
    a4 = T1(4);
    a5 = T1(5);
    
    b1 = T2(1);
    b2 = T2(2);
    b3 = T2(3);
    b4 = T2(4);
    b5 = T2(5);
    
    polynomial = Fun(a1,b1,a2,b2,a5,b5)-Fun(a2,b2,a3,b3,a5,b5) ...
                -Fun(a2,b2,a4,b4,a5,b5)-Fun(a1,b1,a3,b3,a4,b4) ...
                +Fun(a2,b2,a3,b3,a4,b4)+Fun(a3,b3,a4,b4,a5,b5);
    
    alphas = roots(polynomial);
    alphas = alphas(imag(alphas) == 0);
    
    if isempty(alphas)
        
    end
    T = T1 + alphas(1)*T2;
   
    XbyW = (T(4)-T(5))/(T(2)-T(3));
    YbyW = T(4)/(T(1)-T(3));
    ZbyW = T(5)/(T(1)-T(2));
    
    Matrix1 = zeros(4,4);
    
    x5 = X5.a1(1);
    y5 = X5.a1(2);
    w5 = X5.a1(3);
    
    x6 = X6.a1(1);
    y6 = X6.a1(2);
    w6 = X6.a1(3);
    
    Matrix1(1,:) = [w5, 0, -x5, w5-x5];
    Matrix1(2,:) = [0, w5, -y5, w5-y5];
    Matrix1(3,:) = [w6*XbyW, 0, -x6*ZbyW, w6-x6];
    Matrix1(4,:) = [0, w6*YbyW, -y6*ZbyW, w6-y6];
    
    %{
    fprintf('\n***** Matrix1 *****\n\n');
    Matrix1
    %}
    Matrix2 = zeros(4,4);
    
    x5 = X5.a2(1);
    y5 = X5.a2(2);
    w5 = X5.a2(3);
   
    x6 = X6.a2(1);
    y6 = X6.a2(2);
    w6 = X6.a2(3);
    
    Matrix2(1,:) = [w5, 0, -x5, w5-x5];
    Matrix2(2,:) = [0, w5, -y5, w5-y5];
    Matrix2(3,:) = [w6*XbyW, 0, -x6*ZbyW, w6-x6];
    Matrix2(4,:) = [0, w6*YbyW, -y6*ZbyW, w6-y6];
    
    %{
    fprintf('\n***** Matrix2 *****\n\n');
    Matrix2
    %}
    Matrix3 = zeros(4,4);
    
    x5 = X5.a3(1);
    y5 = X5.a3(2);
    w5 = X5.a3(3);
    
    x6 = X6.a3(1);
    y6 = X6.a3(2);
    w6 = X6.a3(3);
    
    Matrix3(1,:) = [w5, 0, -x5, w5-x5];
    Matrix3(2,:) = [0, w5, -y5, w5-y5];
    Matrix3(3,:) = [w6*XbyW, 0, -x6*ZbyW, w6-x6];
    Matrix3(4,:) = [0, w6*YbyW, -y6*ZbyW, w6-y6];

    %{
    fprintf('\n***** Matrix3 *****\n\n');
    Matrix3
    %}
    
    [~, ~, V] = svd(Matrix1);
    abgd1 = V(:,end);
    
    [~, ~, V] = svd(Matrix2);
    abgd2 = V(:,end);
    
    [~, ~, V] = svd(Matrix3);
    abgd3 = V(:,end);
    
    P1 = zeros(3, 4);
    
    P1(1,:) = [abgd1(1), 0, 0, abgd1(4)];
    P1(2,:) = [0, abgd1(2), 0, abgd1(4)];
    P1(3,:) = [0, 0, abgd1(3), abgd1(4)];
    
    P2 = zeros(3, 4);
    
    P2(1,:) = [abgd2(1), 0, 0, abgd2(4)];
    P2(2,:) = [0, abgd2(2), 0, abgd2(4)];
    P2(3,:) = [0, 0, abgd2(3), abgd2(4)];
    
    P3 = zeros(3, 4);
    
    P3(1,:) = [abgd3(1), 0, 0, abgd3(4)];
    P3(2,:) = [0, abgd3(2), 0, abgd3(4)];
    P3(3,:) = [0, 0, abgd3(3), abgd3(4)];
    
    %% camera matrix
    P1 = B1\P1;
    P2 = B2\P2;
    P3 = B3\P3;
    
    %%
    H = zeros(4, 4);
    H(1:3,:) = P1;
    H(4,:) = cross4(H(1,:)', H(2,:)', H(3,:)');
    
    H = inv(H);
    
    P2 = P2*H;
    P3 = P3*H;
    P1 = P1*H;
    
    Tri = zeros(3, 3, 3);
    for i=1:3,
        for j=1:3,
            for k=1:3,
                Tri(i,j,k) = P2(j,i)*P3(k,4) - P2(j,4)*P3(k,i);
            end;
        end;
    end;
    
end

