%% trace
domains
  	data=date(integer,integer,integer,hour)
  	hour = h(integer,integer)
  	lista=string*
  	eventDisplay=eDisplay(string,string,data)
database
	person(string,string,string,string)
  	agenda(string,string)
  	event(string,data,string)
predicates
	writeAndWaitForInput(string)
	loadDataBase
	mainMenu
	mainMenuOptionPicker(char)

	createAgenda()
	openAgenda()
	deleteAgenda()

	personalAgendaMainMenu(string)
	personalAgendaOptionPicker(char,string)
	updateUserInformation(string)
	addNewContact(string)
	deleteContact(string)
	editContact(string)
	displayContacts(string)

	addNewEvent(string)
	deleteEvent(string)
	editEvent(string)
	dispalyEvents(string)

	displayList(lista,string)
	readDate(data)
	exitApp()
clauses
	writeAndWaitForInput(Message):-
    	write(Message),
    	readchar(_).

    loadDataBase():-
    	existfile("AGENDA.DAT"),
    	consult("AGENDA.DAT").
	
	loadDataBase():-
		writeAndWaitForInput("Database could not be loaded."),
		exit(1).

	mainMenu:-
		clearwindow(),
	 	makewindow(1,6,7,"Menu",6,15,15,50),
    	write("1. Create agenda"),nl,
    	write("2. Open agenda"),nl,
   	 	write("3. Delete agenda"),nl,
    	write("4. Exit"),nl,
	  	readchar(Option),
	  	mainMenuOptionPicker(Option).

	mainMenuOptionPicker('1'):-
		createAgenda().
	mainMenuOptionPicker('2'):-
		openAgenda().
	mainMenuOptionPicker('3'):-
		deleteAgenda().
	mainMenuOptionPicker('4'):-
		exitApp().
	mainMenuOptionPicker(_):-
		writeAndWaitForInput("Invalid item selection. Please select a valid option!"),
		mainMenu().

	%% Create agenda (ask for full name and phone number)
	createAgenda():-
    	clearwindow(),
	  	makewindow(1,6,7,"Create agenda",6,15,15,50),
		write("Full name:"),
		readln(Name),nl,
		write("Phone number:"),
		readln(Phone),nl,
		not(agenda(Name,_)),
		assert(agenda(Name,Phone)),
		mainMenu().
	
	%% Create agenda failsafe function in case person already exists
	createAgenda():-
		writeAndWaitForInput("Person already exists!"),
		mainMenu().

	%% Open agenda for user (ask for full name)
	openAgenda():- 
		clearwindow(),
	  	makewindow(1,6,7,"Open agenda",6,15,15,50),
		write("Full name:"),
		readln(Name),nl,
		agenda(Name,_),
	  	personalAgendaMainMenu(Name).
	
	%% Open agenda failsafe method in case person does not have an agenda
	openAgenda():-
		writeAndWaitForInput("The person does not have an agenda"),
		mainMenu().

	%% Delete an agenda (ask for full name)
	deleteAgenda():-
		clearwindow(),
		makewindow(1,6,7,"Delete agenda for",6,15,15,50),
		write("Full name:"),
		readln(Name),nl,
		retract(agenda(Name,_)),
		writeAndWaitForInput("Agenda deleted, exiting to main menu."),
		mainMenu().

	%% Delete agenda failsafe method in case the person does not have an agenda
	deleteAgenda():-
		writeAndWaitForInput("The person does not have an agenda"),
		mainMenu().

	%% Menu displayed after opening the agenda
	personalAgendaMainMenu(FullName):-
		clearwindow(),
		concat("Agenda for ",FullName,PersonalAgendaWindowTitle),
		makewindow(1,6,7,PersonalAgendaWindowTitle,6,15,15,50),
		write("0.Update user information"),nl,
		write("-----CONTACTS-----"),nl,
		write("1.Insert contact"),nl,
		write("2.Delete contact"),nl,
		write("3.Edit contact"),nl,
		write("4.Display contacts"),nl,
		write("-----EVENTS-----"),nl,
		write("5.Insert event"),nl,
		write("6.Delete event"),nl,
		write("7.Edit event"),nl,
		write("8.Display events"),nl,
		write("9.Back to main menu"),nl,
		readchar(Option),
		personalAgendaOptionPicker(Option,FullName).

	%% Personal agenda picker function
	%% Update user information (asks for a new name and a new phone number)
	personalAgendaOptionPicker('0',FullName):-
		updateUserInformation(FullName).
		

	%% Personal agenda picker function
	%% Add a new contact to user's agenda
	personalAgendaOptionPicker('1',FullName):-
		addNewContact(FullName).

	%% Personal agenda picker function
	%% Delete a contact from user's agenda
	personalAgendaOptionPicker('2',FullName):-
		deleteContact(FullName).

	%% Personal agenda picker function
	%% Edits a contact from user's agenda
	personalAgendaOptionPicker('3',FullName):-
		editContact(FullName).

	%% Personal agenda picker function
	%% Displays all contacts for a user.
	personalAgendaOptionPicker('4',FullName):-
		displayContacts(FullName).

	%% Personal agenda picker function
	%% Inserts a new event
	personalAgendaOptionPicker('5',FullName):-
		addNewEvent(FullName).

	%% Personal agenda picker function
	%% Deletes an event
	personalAgendaOptionPicker('6',FullName):-
		deleteEvent(FullName).

	%% Personal agenda picker function
	%% Edits an event
	personalAgendaOptionPicker('7',FullName):-
		editEvent(FullName).

	%% Personal agenda picker function
	%% Display all events
	personalAgendaOptionPicker('8',FullName):-
		dispalyEvents(FullName).

	%% Personal agenda picker function
	%% Back to main menu
	personalAgendaOptionPicker(_,_):-
		mainMenu().


	%% Update user information function implementation
	updateUserInformation(FullName):-
		clearwindow(),
		concat("Updating information for ",FullName,UpdateInformationWindowTitle),
		makewindow(1,6,7,UpdateInformationWindowTitle,6,19,19,50),
		write("New name:"),
		readln(NewName),nl,
		retract(agenda(FullName,_)),
		write("New phone number:"),
		readln(Phone),nl,
		not(agenda(NewName,_)),
		assert(agenda(NewName,Phone)),
		personalAgendaMainMenu(NewName).

	%% Update user information failsafe function in case the new name already exists
	updateUserInformation(FullName):-
		writeAndWaitForInput("The name you picked already has an agenda."),
		personalAgendaMainMenu(FullName).

	%% Add a new contact function implementation
	addNewContact(FullName):-
		clearwindow(),
		makewindow(1,6,7,"Add contact",6,15,15,50),
		write("Full name:"),
		readln(Name),nl,
		write("Phone:"),
		readln(Phone),nl,
		write("Email:"),
		readln(Email),nl,
		not(person(Name,_,_,FullName)),
		assert(person(Name,Phone,Email,FullName)),
		writeAndWaitForInput("Contact added"),
		personalAgendaMainMenu(FullName).

	%% Add a new contact failsafe function in case the contact already exists
	addNewContact(FullName):-
		writeAndWaitForInput("The contact already exists"),
		personalAgendaMainMenu(FullName).

	%% Deletes a contact from user's agenda
	deleteContact(FullName):-
		clearwindow(),
		makewindow(1,6,7,"Delete contact",6,15,15,50),
		write("Full name:"),
		readln(Name),nl,
		person(Name,_,_,FullName),
		retract(person(Name,_,_,FullName)),
		writeAndWaitForInput("Contact deleted"),
		personalAgendaMainMenu(FullName).

	%% Delete contact failsafe function in case user does not exist.
	deleteContact(FullName):-
		writeAndWaitForInput("The contact does not exist"),
		personalAgendaMainMenu(FullName).

	%% Updates a contact information
	editContact(FullName):-
		clearwindow(),
		makewindow(1,6,7,"Update contact",6,15,15,50),
		write("Full name:"),
		readln(Name),nl,
		person(Name,_,_,FullName),
		write("New name:"),
		readln(NewName),nl,
		not(person(NewName,_,_,FullName)),			
		write("New phone number: "),
		readln(Phone),nl,
		write("New email: "),
		readln(Email),nl,
		retract(person(Name,_,_,FullName)),
		assert(person(NewName,Phone,Email,FullName)),
		writeAndWaitForInput("User edited! Bringing you back to main menu..."),
		personalAgendaMainMenu(FullName).

	%% Update contact failsafe function in case the person does not exist or the new name is taken.
	editContact(FullName):-
		writeAndWaitForInput("Something went wrong!Exiting to main menu..."),
		personalAgendaMainMenu(FullName).

	%% Display a list of contacts for user
	displayContacts(FullName):-
		clearwindow(),
		concat(FullName,"'s contacts",DisplayContactsWindowTitle),
		makewindow(1,6,7,DisplayContactsWindowTitle,3,10,19,53),
		findall(Contact,person(Contact,_,_,FullName),Contacts),
		cursor(1,6),
		displayList(Contacts,FullName).

	%% Add new event for a user function implementation
	addNewEvent(FullName):-
		clearwindow(),
		concat("Add event for",FullName,AddEventWindowTitle),
		makewindow(1,6,7,AddEventWindowTitle,6,15,15,50),
		write("Event description:"),
		readln(Description),nl,
		write("Event date:"),nl,
		readDate(Date),
		not(event(_,Date,FullName)),
		assert(event(Description,Date,FullName)),
		writeAndWaitForInput("Event added"),
		personalAgendaMainMenu(FullName).

	%% Add new event failsafe function in case the date is already booked.
	addNewEvent(FullName):-
		writeAndWaitForInput("You already have something planned for that date."),
		personalAgendaMainMenu(FullName).

	%% Delete event function implementation
	deleteEvent(FullName):-
		clearwindow(),
		makewindow(1,6,7,"Delete event",6,15,15,50),
		write("Event date:"),nl,
		readDate(Date),
		retract(event(_,Date,FullName)),
		writeAndWaitForInput("Event deleted"),
		personalAgendaMainMenu(FullName).

	%% Delete event failsafe function in case the event does not exists.
	deleteEvent(FullName):-
		writeAndWaitForInput("There's no event coresponding to that date."),
		personalAgendaMainMenu(FullName).

	% Edit event function implementation
	editEvent(FullName):-
		clearwindow(),
		makewindow(1,6,7,"Edit event",6,15,15,50),
		write("Event date:"),nl,
		readDate(Date),
		write("New description"),nl,
		readln(Description),nl,
		write("New event date:"),nl,
		readDate(NewDate),
		not(event(_,NewDate,FullName)),
		retract(event(_,Date,FullName)),
		assert(event(Description,NewDate,FullName)),
		writeAndWaitForInput("Event edited"),
		personalAgendaMainMenu(FullName).

	%Edit event failsafe function in case the date is already booked
	editEvent(FullName):-
		writeAndWaitForInput("You already have something planned for that day."),
		personalAgendaMainMenu(FullName).

	% Display events function implementation
	dispalyEvents(FullName):-
		clearwindow(),
		concat(FullName,"'s events",DisplayEventsWindowTitle),
		makewindow(1,6,7,DisplayEventsWindowTitle,3,10,19,53),
		findall(Description,event(Description,_,FullName),Events),
		cursor(1,6),
		displayList(Events,FullName).

	%% Helper function to read a date from keyboard.
	readDate(Date):-
		write("Hour:"),
		readInt(Hour),
		Hour>0,
		Hour<25,
		write("Minute:"),
		readInt(Minute),
		Minute>0,
		Minute<61,
		write("Day:"),
		readInt(Day),
		Day>0,
		Day<32,    
		write("Month:"),
		readInt(Month),
		Month>0,
		Month<13,
		write("Year:"),
		readInt(Year),
		Year>0,
		Year<10000,
		Date=date(Day,Month,Year,h(Hour,Minute)).
	
	%% Failsafe method for reading a date in case the input is invalid
	readDate(Date):-
    	writeAndWaitForInput("Invalid date(year[1,9999],month[1,12],day[1,31]"),nl,
		readDate(Date).

	%% Helper function to display a list of items on the screen.
	displayList ([],FullName):-
        cursor(15,10),
        writeAndWaitForInput("End of list..."),
        removewindow,
		personalAgendaMainMenu(FullName).
        
    displayList([Sir|RL],FullName):-
        cursor(LC,_),
        LC<14,
        cursor(LC,6),
        write(Sir),nl,
        displayList(RL,FullName).
        
    displayList([Sir|RL], FullName):-
        cursor(15,6),
        writeAndWaitForInput("Press any key to continue..."),
        clearwindow,
        cursor(1,6),
        write(Sir),nl,
        displayList (RL,FullName).

	exitApp():-
		save("AGENDA.DAT"),
	    retractall(person(_,_,_,_)),
	    retractall(event(_,date(_,_,_,_),_)),
	    retractall(agenda(_,_)),
	    exit(0).

goal
  loadDataBase(),
  mainMenu().


