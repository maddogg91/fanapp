import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Geeksforgeeks"),
        backgroundColor: Colors.green,
      ),
      body: ListWheelScrollView(
        itemExtent: 100,
         
        // diameterRatio: 1.6,
        // offAxisFraction: -0.4,
        // squeeze: 0.8,
       children: <Widget>[
         RaisedButton(onPressed:null ,
       child: Text("Item 1",textAlign:TextAlign.start,
            style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),) ,
       RaisedButton(onPressed:null ,
       child: Text("Item 2",textAlign:TextAlign.center,
            style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),) ,
       RaisedButton(onPressed:null ,
       child: Text("Item 3",textAlign:TextAlign.center,
            style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),) ,
       RaisedButton(onPressed:null ,
       child: Text("Item 4",textAlign:TextAlign.center,
            style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),) ,
       RaisedButton(onPressed:null ,
       child: Text("Item 5",textAlign:TextAlign.center,
            style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),) ,
       RaisedButton(onPressed:null ,
       child: Text("Item 6",textAlign:TextAlign.center,
            style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),) ,
       RaisedButton(onPressed:null ,
       child: Text("Item 7",textAlign:TextAlign.center,
            style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),) ,
       RaisedButton(onPressed:null ,
       child: Text("Item 8",textAlign:TextAlign.center,
            style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),) ,
       ],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _textFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
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
				 CollectionReference message= FirebaseFirestore.instance.collection('admin-messages');
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

String getIsAdmin(){
	final user = _auth.currentUser;
	final String email= user.email;
	print(email);
	FirebaseFirestore.instance.collection('users')
							.where('email', isEqualTo: email).get().then((QuerySnapshot documentSnapshot) {
								if(documentSnapshot.size > 0){
									print(documentSnapshot.size);
									return 't';
									
								}
							});
}

  String codeDialog;
  String valueText;

  @override
  Widget build(BuildContext context) {
	String admin= getIsAdmin();
	Timer(Duration(seconds: 3), () {
  if(admin== 't'){
	print(admin);
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
	else{
			return MaterialApp(
      title: 'ListWheelScrollView Example',
      theme: ThemeData(
         
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Wheel(),
    );
}
	

      
  });
}	
	
     
   
}