# PhasePortrait
A simple phase portrait plotter for 2x2 linear homogenous 1st order systems.  It is written in the [Processing programming language](https://processing.org/).

Edit the file to configure the system matrix, the plot limits, and other parameters.

Click on the window to start a path at that point.  The path will end when it reaches the maximum number of iterations or goes outside the plot window.

Integration uses simple Forward Euler, which introduces some inaccuracy.  It's suggested to use this only for qualitative purposes.

Examples:

![Image 1](https://raw.github.com/kevinsa5/PhasePortrait/master/images/portrait_1.png)
![Image 2](https://raw.github.com/kevinsa5/PhasePortrait/master/images/portrait_2.png)
![Image 3](https://raw.github.com/kevinsa5/PhasePortrait/master/images/portrait_3.png)
