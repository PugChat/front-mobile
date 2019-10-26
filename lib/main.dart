import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      initialRoute: MyHomePage.id,
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        Registration.id: (context) => Registration(),
        Login.id: (context) => Login(),
        Chat.id: (context) => Chat()
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const String id = "home";
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
                    color: Colors.black),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                    width: 100.0, child: Image.asset("assets/images/pug.png")),
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
                callback: () {
                  Navigator.of(context).pushNamed(Login.id);
                },
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
                callback: () {
                  Navigator.of(context).pushNamed(Registration.id);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
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
                fontFamily: 'RobotoMono', fontSize: 20.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class Registration extends StatefulWidget {
  static const String id = "registration";
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password
    )) as FirebaseUser;
    
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,
        ),
      ),
    );
  }

  void createUserMS() async {
    String email;
    String password;
    Map data = {
      'email': email,
      'password': password
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pug Chat"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset("assets/images/pug.png"),
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: "Ingrese su correo electrónico",
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 30.0,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: "Ingrese su contraseña",
              border: const OutlineInputBorder(),
            ),
          ),
          CustomButton(
            text: "Registro",
            callback: () async{
              await registerUser();
            },
          )
        ],
      ),
    );
  }
}

class Login extends StatefulWidget {
  static const String id = "login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logUser() async {
    FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password
    )).user;
    
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Chat(
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pug Chat"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset("assets/images/pug.png"),
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: "Ingrese su correo electrónico",
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 30.0,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: "Ingrese su contraseña",
              border: const OutlineInputBorder(),
            ),
          ),
          CustomButton(
            text: "Iniciar sesión",
            callback: () async{
              await logUser();
            },
          )
        ],
      ),
    );
  }
}

class Chat extends StatefulWidget {
  static const String id = "chat";
  final FirebaseUser user;
  const Chat({Key key, this.user}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
