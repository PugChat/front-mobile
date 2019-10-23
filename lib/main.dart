import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "PugChat",
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 40.0,
                  color: Colors.black
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  width: 100.0,
                  child: Image.asset("assets/images/pug.png")
                ),
              ),
              SizedBox(
                height: 50.0,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomButton(
                text: "Iniciar Sesión",
                callback: (){},
              ),
              SizedBox(
                height: 60.0,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomButton(
                text: "Registrarse",
                callback: (){},
              )
            ],
          )
        ],
      ),
    );
  }
}


class CustomButton extends StatelessWidget{
  final VoidCallback callback;
  final String text;

  const CustomButton({Key key, this.callback, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.grey,
        elevation: 6.0,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: callback,
          minWidth: 100.0,
          height: 40.0,          
          child: Text(
            text,
            style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 20.0,
                  color: Colors.black
                ),
          ),
        ),
      ),
    );
  }
}

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}