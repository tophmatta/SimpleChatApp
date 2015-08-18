# SimpleChatApp

This project consists of a basic chat app with 1 single, tableview and a animated text field used to 
update the view with messages input by the user.

Skills used:
- Using Parse as backend
  - Creating PFObject
  - Saving Data (saveInBackgroundWithBlock method)
  - Creating Query (PFQuery)
  - Retrieving Data (findObjectsInBackgroundWithBlock)
  - Bringing items retrieved asynchronously to main thread to prevent UI from outputting error using
    dispatch_async func.
- Animating views once action occurs
- Tableview and associated delegation methods
