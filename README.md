# TruecallerTask

I took alot of shortcuts, no tests, minor error handling, no dependencies. The network was done in an extension of the one ViewController available in the app. The simultaneous task are done when the button is pressed using DispatchGroup. All the logic is in a String extension, I love extensions, I use them alot to prevent Massive ViewControllers. Regarding the word counter task 3, the dictionary that is declared in the line 40 of the ViewController.swift file is available for the ViewController but I store the logic in an String extension in the String+Charachter.swift file. If the data would be something else then a String I would probably create some data source using POP and dependency injection and inject the datasource to the ViewController.. 