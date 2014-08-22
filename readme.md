## 1. Respond to a Ticket

***Respond to this angry customer. You don't need to fix the problem, yet. Just let them know that you're sorry and working on it.***

> HELP!  
> In fees, anywhere there should be a € symbol there is this code: `&#x20AC;`
>
> This is embarassing. How could you ship something so broken?
> 
> -Eric

Hi Eric! Thanks for getting in touch with us! I'm so sorry to hear that you are having problems. We do our best to catch every single bug we can, but occasionally one slips through into the production site. I'm going to get on this immediately and I'll let you know as soon as I've found a solution.  Until then, I hope you have a great day!

Alex Howington

Badass Junior Developer at Bidsketch (ok, this part can go if it must...)

## 2. Diagnose the Ticket

***At a glance, what do you think is wrong in that ticket?***
  
I believe the problem has something to do with the HTML encoding of the text. The user is probably using the Euro symbol in a rich text editor (total guess) and somewhere that text is being displayed as straight HTML instead of encoded into the symbols it represents (this part I'm pretty sure of).

## 3. Code Review

***In less than a blog post, analyze the portal_controller.rb below. Try to answer these questions:*** 

* What does it do?
* What do you like about it?
* What don't you like about it?

The ole portal controller, eh? Well it's obviously a way to control the opening and closing of portals to the 5th dimension. I think anyone can see that. In all seriousness though, it looks to be a controller for a user (Client in this case) dashboard. Sort of a catch-all for the actions performed from the portal/dashboard page. I see the page loaded when the user logs in (`index`), which presumably loads a list of all their proposals. The `info` and `show` actions which load information about a specific proposal. `canvas` looks like the way users can create their own proposal templates. `optional_fees`, `set_status`, `accept_proposal`, `destroy_comment`, all those seem pretty self-explanatory. `accept` looks like the actual action to go through accepting a proposal, which would mean `accept_proposal` is used for something else. It looks like `accept_proposal` sets data for the sender of the proposal, whereas `accept` is used by the receiver of the proposal. We've got some nice little `protected` methods down here that save information on when certain actions happened (such as a pdf export or when a user's last visit was). Finally, there are a couple `private` methods which look like they send some emails after a proposal has been approved or a support email after the accepting process has failed. And that last little guy just checks to make sure that the onboarding params hash isn't blank. If it is, you aren't onboarding, ya dingus!

The thing I like most about this code is pretty superficial, but `notify_honeybadger(e)` is a great line of code. Well done. All the names (besides `accept` and `accept_proposal`) are very self-explanatory, and I feel like I can almost understand the code without having to dive into the actual methods. The use of `protected` and `private` methods lets me quickly know the scope and use of those methods. Everything seems pretty well named, I can tell what almost every variable does just from reading the name. I don't have to use those context clues of what it's actually doing in the code.

The biggest problem I found was just the actual formatting of some of the code. Sometimes there are two empty lines right after the name of the method. Sometimes there are empty lines between nested `end` statements. The `protected` and `private` declarations didn't even register at first glance because they are indented at the same level as the method definitions. Just little things like that make the code a bit harder to parse and read through it quickly. Another small thing that I noticed was that two of the before filters actually use the `skip_before_filter` syntax used in conjuction with the `only` option. I would prefer to write that as `before_filter` used in conjuction with the `except` option. It just reads a lot nicer and is one less step of logic to translate in your brain. Also, some more comments would be helpful. Maybe something to just explain the difference between `accept` and `accept_proposal`, because they sound like they should do similar things based on their method names. This one is total personal preference but I love me some Ruby 1.9 hash syntax! Are you guys using 1.9 yet? Come on, get with the times, man! ;) 

*Fun fact: those 3000+ characters I just wrote are equivalent to 22+ tweets! **themoreyouknow.gif!***


## 4. Make Something

***We use a service called Postmark to send emails. Sometimes these emails get bounced for any number of reasons and can't be sent. Postmark offers a bounce webhook that can notify us when one of our emails bounce. We need to build something that parses these notifications, and attempts to reactivate a bounce.***

### 4.1 Plan it

***Before you start building something, spend about an hour planning what this feature should or shouldn't do. Use the API docs as a guideline for what's possible. Keep security and the API limitations in mind. Use whatever other resources you can find to make your life easier. You should end up with a should/shouldn't list that looks something like this, but for a feature and not a cat:*** 

* It should catch mice
* It should use a litter box
* It should let me know when it's hungry
* It should be fat, but not lazy
* It should not try to send other cats to Abu Dabi

My should/shouldn't list:

* It should accept a POST request to a certain URL
* It should authenticate the request (ex: http://username:password@example.com/bouncehook)
* The request should contain at least a few basic params ("ID", "MessageID", "Email")
* It should parse the request body
* It should try to resend the bounced email
* It should not try to resend the bounced email more than once

### 4.2 Build it

***Give yourself an hour to build something that matches up with your requirements from 4.1.***

Curl request I used to test POST:

	curl -X POST "http://alex:password@localhost:3000/bouncehook" -H "Accept: application/json" -H "Content-Type: application/json" -v -d "{ 'ID' : 'id goes here', 'Type' : 'HardBounce', 'Tag' : 'Invitation', 'MessageID' : 'd12c2f1c-60f3-4258-b163-d17052546ae4', 'TypeCode' : 1, 'Email' : 'jim@test.com', 'BouncedAt' : '2010-04-01', 'Details' : 'test bounce', 'DumpAvailable' : true, 'Inactive' : true, 'CanActivate' : true, 'Subject' : 'Hello from our app!'}"

Nothing to show here but I can assure you I worked for an hour (and maybe like two extra minutes...)

### 4.3 Write about it

***When that hour is up, bundle up the code and the requirements along with a short write-up of summarizing your work. I'm looking for introspection and honesty as much as code quality, so be sure to include things that got in your way and why.***

Ok, so the hour of implementation is up and here I am, still in one piece. Oh boy. I'm a little embarrassed that I wasn't able to solve this in a... nicer way, but I have spent the last couple months basically only writing Javascript and Google Maps API code, so I'm not exactly at the top of my Rails game. So basically I was able to solve every problem except the authentication of the request. I tried sending some POST requests using `http://alex:password@localhost:3000/bouncehook` but I just couldn't find where the username and password were in the request! 

The whole solution is really pretty simple. There is one route: `post 'bouncehook', to: 'emails#bounce'`. I tried using curl to send the POST requests but it was getting really buggy on me, so I ended up downloading a Chrome extension called Postman that is basically curl with a GUI. It's actually pretty nice! So I send a POST request, the bounce action in the emails controller gets the request, if the request contains keys with the names `ID`, `MessageID`, and `Email`, the params are parsed and stored in an `Email` object (whose attributes basically mirror those of the actual request data). I then attempt to save the `Email` object based on a uniqueness validation for the `message_id`. If the save works, we know it's a new bounced email and it should then be delivered to the user. If the `Email` object doesn't save, we know that we've already tried to send that email once and I assumed you wouldn't want to send the same bounced email over and over and over. I didn't actually do the delivering of the email, just print out a message with the basic info that would be used to send the email. If the request doesn't contain the correct keys (`ID`, `MessageID`, `Email`), the action responds with `Not a valid email object.` to let you know the JSON didn't contain the correct keys.

Like I said, not the most elegant solution and more of a proof of concept, but then again I was supposed to get it all done in an hour so it was more of a strategic decision to just simulate a POST request and log the email details instead of actually interacting with the Postmark API. I hope this is what you were looking for! I really think I would enjoy working with you! 



