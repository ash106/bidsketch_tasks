## 1. Questions

***What do you do when you don't know the next step?***

I've realized that usually when I don't know the next step, it's because I haven't broken the feature or task down to its most basic requirements or steps, respectively. Once I really break something down, I can usually figure out those small pieces pretty well. The times that I can't figure out one of those small pieces, it's straight to Google or Stackoverflow! (and let's be honest, most of the Googling leads you to Stackoverflow anyway...) The Rails community is so large and diverse that I've come to the conclusion that **someone** has done what you want to do, and when you get stuck you just have to know how to Google it!

***How do you know when something you build works?***

When I'm building things the right way, it's when the tests pass. When I'm building in a spike (totally stole that from you btw), it's sort of just test as many inputs as possible and try to think of all the edge cases. We did a LOT of manual testing when I was trying to get a CS degree, so I'm actually pretty well-versed in coming up with test cases and manually entering them. Needless to say, I 110% **absolutely** understand the benefits of automated testing. It's just a matter of breaking bad habits and really getting comfortable writing tests instead of doing it manually.

***What do you wish you could have asked me?***

Lol, I think I actually did ask you a few questions. Just realized that might have been illegal! I think the main thing I didn't know was whether I should actually interact with the API or just simulate requests. Because I only had an hour to implement this sucker, I went with simulate requests. Still not sure which one was ideal, but I know it let me finish my actual solution instead of messing with API calls the entire hour.

***What pissed you off?***

YOUR FACE. Umm, honestly I don't get too pissed at programming anymore. I've been programming in some aspect for a while now, so I'm very aware that it's usually user error (`=` vs `==` when learning equality, anyone?) that is causing the problems. The one thing I could not figure out was my `curl` request though. I kept copy pasting the request into the terminal, and for some reason whenever I hit `Enter` I would get that request pasted twice in a row, ready to be run again. Obviously, hitting `Enter` on that double request would just fail. I still have NO idea why it did this.  If this explanation didn't make sense, maybe I can make a little video or GIF and show you. That was truly frustrating because I knew I was on the clock and this was a pretty simple part of the problem. That lead me to just say "Ok, no time to debug this thing. Go find a different way to make the request." I'm still not stoked on the fact that `curl` defeated me. After writing all this, I'm pretty sure I'm going to go back and get it to work. I'm all riled up now!


## 2. Problem Solving!

***After looking through the bounced emails, one pattern starts to show it's face. Our customers are trying to email their proposals to potential clients, but they are just mistyping the email address. How would you solve this, knowing what you already found with Postmark?***

This is an interesting problem. My first instinct was to somehow correct basic misspellings, but I quickly realized that email addresses are often spelled in strange ways and have crazy numbers or symbols in them so this is not a solution at all. Then I had one of those "oh it's so simple! how did you not think of that you moron!" moments. So when you send an email with Postmark, you get a response that contains a `MessageID` and `To` (the to: email address) strings. We can save these attributes in an `Email` or `SentEmail` model (since I already have an `Email` model which should actually probably be named `BouncedEmail`), which belongs to a `User` through a `has_many` relationship. When you get the bounced email, it also contains a `MessageID`. What are the chances?! So you take that `MessageID` from the bounced email, do a query for any `SentEmails` containing that `MessageID` and if you get a match (there should only be one as the `MessageID` is unique), create a `Notification` to the associated `User` that their email has failed to send. As I finish writing this, I realize I've given myself quite a project to build in an hour. I think I'm going to go with simulating requests again as I would love to build the basic functionality instead of spending 20-30 minutes on the API calls.

## 3. Work on it a bit more

***Trying not to spend more than an hour, start to build a solution to this problem. Again, I'd like you to:***

* Come up with a list of requirements
* Work on building something to meet those requirements
* Write up a summary of your work after an hour


Requirements list:

* It should save sent emails (at least `MessageID` and `To`)
* It should associate sent emails with the `User` that sent them
* It should notify `Users` that their email has bounced
* It should allow `Users` to to resend the same email to a new address (no way I'm getting this one done in the hour but it seems like a great idea!)


