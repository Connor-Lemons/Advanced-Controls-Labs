function out = runModel(t)

    simIn = Simulink.SimulationInput("satmodel");
    simIn = setModelParameter(simIn, "StopTime", t);
    out = sim(simIn);

end