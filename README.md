![](images/smi-header.png)

# Introduction to Simulation Studies

#### Dr. Andy Bell & Dr. Calum Webb

**Link to slides [here](https://calumwebb.co.uk/teaching/pgrt/simulation/slides/)**

This repository contains the course materials for the one day training course *'Introduction to Simulation Studies'*, for postgraduate research students and research professionals. These materials should be downloaded prior to the start of the course. Instructions are provided for computers running Windows, Mac, or Debian/Ubuntu systems. Other devices (iPhones, iPads, Android-based devices) are not suitable for the training course.

The course is designed to be 'hands-on' with examples to ensure that you are able to apply skills you learn in a real research context. Examples are provided for both `R` and `Stata`

If you are new to `R` and `Rstudio`, you will first need to install and configure the statistical programming language and the GUI on your device. `Stata` is commercial software that requires a license, please enquire with your institution for access to Stata. Basic versions of Stata should be still appropriate for the course.

Completing all of the setting up steps for the course should take no longer than an hour.

This repository contains the following:

* `slides`
  * This folder contains the slides for the course, both in their original RMarkdown and as a compiled pdf or html file. These can be opened in any pdf viewer or web browser. Google Chrome is recommended for using the slides, as Firefox or other browsers can sometimes freeze the slides as a security feature if they are forwarded through too quickly.

* `R-exercises`
  * `demonstration-code.R` contains the code used for the first and second exercise demonstrations in R.
  * `exercise-answers.R` contains code that is one possible solution to the first and second exercises (collider examples) in R.
  * `R Demonstrations and Exercises.pdf` this is a handout which breaks all of the code in the `demonstration-code.R` down and explains what each part is doing.

* `Stata-exercises`
  * `demonstration-code.do` contains the code used for the first and second exercise demonstrations in Stata.
  * `exercise-answers.do` contains code that is one possible solution to the first and second exercises (collider examples) in Stata.
  * `Stata Demonstrations and Exercises.pdf` this is a handout which breaks all of the code in the `demonstration-code.do` down and explains what each part is doing.




## Installing `R` and `RStudio`

If you have never used R or Rstudio before, the first thing you will need to do is install both the programming language (`R`) and the GUI (graphical user interface, `Rstudio`). I recommend following [this guide from R for Data Science](https://r4ds.hadley.nz/intro#prerequisites).

In short:

1)  First, go to <https://cloud.r-project.org>, download and install the latest version of `R` for your operating system. If you do not know your computer's operating system (Windows, Mac, etc.), and if you're a Mac user and do not know whether you have an Intel-based or an Apple Silicon based Mac, I recommend speaking to your University IT Helpdesk. For students at the University of Sheffield, IT services information can be [found here](https://www.sheffield.ac.uk/it-services).

2)  Next, go to <https://posit.co/download/rstudio-desktop/>, download and install the latest version of `Rstudio` for your operating system.

3)  Try opening `Rstudio`, **not R**, and see whether the screen you are greeted with looks like the one shown in [R for Data Science](https://r4ds.hadley.nz/intro#prerequisites).

## Installing `Stata`

Visit the [Stata](https://www.stata.com) website or enquire with your institution about how to download and register a copy of Stata.

## Downloading a copy of the repository

This repository contains all of the data and code we will be using in the exercises throughout the short course. You will need to download a copy of the repository in advance.

1)  At the top of this page you should see a green button that says "Code" with a drop-down arrow. Click on the drop-down arrow, and then click "Download ZIP". You shouldn't need an account.

2)  Next, unzip the zip folder and open it in your file viewer. For Mac users, you can just click on the zip file and MacOS will automatically unzip it in your downloads folder. You can then open the unzipped folder. For Windows users, you may need to find the zip folder in your downloads folder, right click it, and then click "Extract all...", or use the unzip option on the ribbon menu. For Ubuntu/Debian, you should be able to right click the file and select "Extract here". Put the folder somewhere sensible in case you need to use it again in future.

Which folders and files you need will depend on if you are working through the R Exercises, the Stata Exercises, or both. 
