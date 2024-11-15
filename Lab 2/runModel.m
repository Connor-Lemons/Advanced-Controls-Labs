function out = runModel(mode, t)

    if (mode == "base")
        simIn = Simulink.SimulationInput("Lab2_model");
    elseif (mode == "LQR")
        simIn = Simulink.SimulationInput("Lab2_lqr");
    elseif (mode == "LQC")
        simIn = Simulink.SimulationInput("Lab2_lqc");
    else
        fprintf("Invalid mode");
        return
    end

    simIn = setModelParameter(simIn, "StopTime", t);
    out = sim(simIn);

end