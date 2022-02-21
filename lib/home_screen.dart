import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User loggedinUser;
FirebaseFirestore firestore = FirebaseFirestore.instance;
String admin;
String email;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

 class Wheel extends StatefulWidget {
  @override
  _WheelState createState() => _WheelState();
}
class _WheelState extends State<Wheel> {
  @override
  Widget build(BuildContext context) {
	   final _auth = FirebaseAuth.instance;
	 return StreamBuilder<QuerySnapshot>(
    stream: firestore.collection('admin-messages').snapshots(),
		builder: (context, snap){
			if(!snap.hasData){
				return Scaffold(
				);
    
   
			}
			else if(snap.hasData){
			final List<DocumentSnapshot> documents= snap.data.docs;
			return Scaffold(
				
				appBar: AppBar(
					title: Text("Messages from Maddogg"),
					backgroundColor: Colors.red,
					actions: <Widget>[
							IconButton(
								icon: Icon(Icons.close),
								onPressed: () {
									return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to logout?'),
          
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('CANCEL'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('LOGOUT'),
              onPressed: () {
                setState(() {
                 _auth.signOut();
                });
              },
            ),

          ],
        );
      });
									
									//Implement logout functionality
								}),
							],
					),
					
					body: ListView.builder(
  padding: const EdgeInsets.all(8),
  itemCount: documents.length,
  itemBuilder: (BuildContext context, int index) {
    return Container(
      height: 50,
      color: Colors.amber[index*100],
      child: Center(child: Text('Entry #$index: ${documents[index].get("message")}')),
    );
  }
)
);

			} 
}
  );
  }
}

class _HomeScreenState extends State<HomeScreen> {
	AnimationController controller;
  TextEditingController _textFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String test;
  
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  
  
   Future<void> addMessage(String valueText) {
				 CollectionReference message= firestore.collection('admin-messages');
				// Call the admin-messages CollectionReference to add a new message
				return message
					.add({
						'message': valueText,
						'date': DateTime.now()
          })
          .then((value) => print("Message added"))
		  
          .catchError((error) => print("Failed to add message: $error"));
		  }
  
  Future<void> _displayTextInputDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Show the Dogg Pound some love'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Create Message"),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('CANCEL'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('SEND'),
              onPressed: () {
				addMessage(valueText);
                setState(() {
                  codeDialog = valueText;
                  Navigator.pop(context);
                });
              },
            ),

          ],
        );
      });
}

  String codeDialog;
  String valueText;
  @override
  
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
		final user = _auth.currentUser;
		final String email= user.email;
	   return StreamBuilder<QuerySnapshot>(
		stream: firestore.collection('users').where('email', isEqualTo: email).snapshots(),
		builder: (context, snapshot){
			if(!snapshot.hasData){
				return Scaffold(
    
    );
			}
			else if(snapshot.hasData){
			final List<DocumentSnapshot> documents= snapshot.data.docs;
			for(var i = 0; i < documents.length; i++){
				String checkEmail= documents[i].get("email");
				if(checkEmail==email){
					return Scaffold(
						appBar: AppBar(
							leading: null,
							actions: <Widget>[
							IconButton(
								icon: Icon(Icons.close),
								onPressed: () {
									_auth.signOut();
									Navigator.pop(context);
									//Implement logout functionality
								}),
							],
							title: Text('Home Page'),
							backgroundColor: Colors.black,
						),
						body: Center(
							child: Text(
								"Welcome Admin $email",
								style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
							),
						),
						floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
						floatingActionButton: FloatingActionButton.extended(
						onPressed:(){
							_displayTextInputDialog(context);
						},
						label: Text('+'),
						backgroundColor: Colors.red,
					),
				);
				}
			}
				print(email);
				return MaterialApp(
					title: 'Maddoggs Fan Page',
					theme: ThemeData(
					primarySwatch: Colors.blue,
					),
				debugShowCheckedModeBanner: false,
				home: Wheel(),
				);
			
			}
		 else if (snapshot.hasError){
			return Text('Its an Error');
		}
		});
  }
}
         