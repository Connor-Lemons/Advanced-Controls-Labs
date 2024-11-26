function pd = pdot(P)

    global A C W Q

    pd = A*P + P*A' - P*C'*W*C*P + Q;

end