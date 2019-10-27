import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as prefix0;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(AuxHome());

class AuxHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httplink = HttpLink(uri: "http://192.168.0.17:5000/graphql");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httplink as Link,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      ),
    );
    return GraphQLProvider(
      child: MyApp(),
      client: client,
    );
  }
}

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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomButton(
                text: "Saltarse todo xd",
                callback: () {
                  Navigator.of(context).pushNamed(Chat.id);
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
  Dio jotaro = new Dio();
  Response response;
  String _username = "";
  String _email = "";
  String _password = "";

  var id_user;

  void createUserMSAuth() async {
    try {
      response = await jotaro.post(
          "http://192.168.0.17:3000/signup/" + _username + "/" + _password);
      print(response);
    } catch (err) {
      print(err);
    }
    try {
      response =
          await jotaro.post("http://192.168.0.17:4002/users/create", data: {
        "username": _username,
        "password": _password,
        "mail": _email,
        "verification": true,
        "active": true,
        "password_confirmation": _password
      });
      //saveUserId(response.data['id']);
      id_user = response.data['id'];
      print(id_user);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', _username);
      prefs.setString('id_user', id_user);
    } catch (err) {
      print(err);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(id_user: id_user),
      ),
    );
  }

  void saveUserId(user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', user_id);
    prefs.setString('test', "jejejejejejej");
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
            onChanged: (value) => _username = value,
            decoration: InputDecoration(
              hintText: "Ingrese su nombre de usuario",
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            onChanged: (value) => _email = value,
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
            onChanged: (value) => _password = value,
            decoration: InputDecoration(
              hintText: "Ingrese su contraseña",
              border: const OutlineInputBorder(),
            ),
          ),
          CustomButton(
            text: "Registro",
            callback: () async {
              await createUserMSAuth();
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
            email: email, password: password))
        .user;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          id_user: user,
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
            callback: () async {
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
  final id_user;
  const Chat({Key key, this.id_user}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  int id_user;
  
  @override

  void initState(){
    super.initState();   
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomButton(
          text: "wtf",
          callback: () {
            getUserID();
            debug();
          },
        ),
      ],
    );
  }

  void debug() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String debug = prefs.getString('username');
    int id_user = prefs.getInt('id_user');
    print(id_user);
    print(debug);
  }

  getUserID() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('id_user'));
    id_user = prefs.getInt('id_user');
    
  }

}
