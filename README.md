# Oxford Dictionary API Code Test

This small web app allows users to type in a word and receive the definition of that word according to the Oxford Dictionary.

The last five words defined are displayed on the bottom.

Any errors that occur are shown at the top of the page and are kept in a log file.

To run:
```
bundle install
rails server
```

![Screenshot](reference_images/1.PNG)

![Screenshot](reference_images/2.PNG)

Displays last five words defined
![Screenshot](reference_images/3.PNG)

Displays error message based on user input
![Screenshot](reference_images/4.PNG)

![Screenshot](reference_images/5.PNG)

![Screenshot](reference_images/6.PNG)

This was a fun little project to get reacquainted with Ruby and Rails. Since all of the data was coming from an external source and it did not need to persist beyond a session, I opted to use session variables to store the words instead of creating an entire model and database table. Also to keep it simple, I used one controller and only one view that gets updated as words are searched and defined. I would loved to have used a frontend framework to make it look nice too, but that wasn't part of the requirements and I did not want to overextend myself for a simple code test. Thank you so much for the opportunity. I look forward to discussing my decisions further in an interview. 