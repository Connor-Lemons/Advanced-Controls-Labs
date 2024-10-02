function out = runModel(A, B, C, K, L, mode)

    assignin("base", "A", A);
    assignin("base", "B", B);
    assignin("base", "C", C);
    assignin("base", "K", K);
    assignin("base", "L", L);

    if (mode == "FSF")
        simIn = Simulink.SimulationInput("Lab1_FSF");
        out = sim(simIn);
    elseif (mode == "OBS")
        simIn = Simulink.SimulationInput("Lab1_OBS");
        out = sim(simIn);
    else
        fprintf("Invalid mode");
        return
    end

end