import 'package:callmatesuperadmin/Screens/home_screen.dart';
import 'package:callmatesuperadmin/firebase_auth_service.dart';
import 'package:callmatesuperadmin/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return LoginWidget();
        });
  }
}


class LoginWidget extends StatefulWidget {
  String email = "";
  String password = "";

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Admin",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        initialValue: widget.email,
                        onChanged: (value){
                          widget.email = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        initialValue: widget.password,
                        onChanged: (value){
                          widget.password = value;
                        },
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ()async {
                          // Your login logic here
                          if(widget.email.isEmpty || widget.password.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email and password cannot be empty")));
                            return;
                          }
                          bool isSuperAdmin = await FirestoreService().isSuperAdmin(widget.email);
                          if(!isSuperAdmin){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You are not a super admin")));
                            return;
                          }
                          User? user = await FirebaseAuthService().signInWithEmailAndPassword(widget.email, widget.password);
                          if(user == null){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid email or password")));
                            return;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}