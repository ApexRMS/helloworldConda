library(rsyncrosim)      # Load SyncroSim R package

myScenario <- scenario()  # Get the SyncroSim scenario that is currently running

# Load RunControl datasheet to be able to set timesteps
runSettings <- datasheet(myScenario, name = "helloworldConda_RunControl",
                         returnInvisible = TRUE)

# Set timesteps - can set to different frequencies if desired
timesteps <- seq(runSettings$MinimumTimestep, runSettings$MaximumTimestep)

# Load scenario's input datasheet from SyncroSim library into R dataframe
myInputDataframe <- datasheet(myScenario,
                              name = "helloworldConda_IntermediateDatasheet")

# Setup empty R dataframe ready to accept output in SyncroSim datasheet format
myOutputDataframe <- datasheet(myScenario,
                               name = "helloworldConda_OutputDatasheet")

# For loop through iterations
for (iter in runSettings$MinimumIteration:runSettings$MaximumIteration) {
  
  # Only load y for this iteration
  y <- myInputDataframe$y[myInputDataframe$Iteration == iter]
  
  # Do calculations
  yCum <- cumsum(y)
  
  # Store the relevant outputs in a temporary dataframe
  tempDataframe <- data.frame(Iteration = iter,
                              Timestep = timesteps,
                              yCum = yCum)
  
  # Copy output into this R dataframe
  myOutputDataframe <- addRow(myOutputDataframe, tempDataframe)
}

# Save this R dataframe back to the SyncroSim library's output datasheet
saveDatasheet(myScenario,
              data = myOutputDataframe,
              name = "helloworldConda_OutputDatasheet")