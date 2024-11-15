function matd = matdot(t, mat)

    global A B Q R

    matd = -mat*A - A'*mat + mat*B*inv(R)*B'*mat - Q;

end