import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' as prefix1;
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
        Chat.id: (context) => Chat(),
        Chatcito.id: (context) => Chatcito(),
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

  int id_user = 0;

  void createUserMSAuth() async {
    try {
      response = await jotaro.post(
          "http://192.168.0.17:3000/signup/" + _username + "/" + _password);
      print(response);
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
      prefs.setInt('id_user', id_user);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(),
        ),
      );
    } catch (err) {
      print(err);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Registration(),
        ),
      );
    }
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
  Dio jotaro = new Dio();
  Response response;
  String _username = "";
  String _email = "";
  String _password = "";
  var id_user;
  void loginMSAuth() async {
    try {
      response = await jotaro.get(
          "http://192.168.0.17:3000/api/signin/" + _username + "/" + _password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('username');
      prefs.remove('id_user');
      prefs.setString('username', _username);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(),
        ),
      );
    } catch (err) {
      print(err);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Registration(),
        ),
      );
    }
    try {
      response = await jotaro.post("", data: {
        "username": _username,
        "password": _password,
        "mail": _email,
        "verification": true,
        "active": true,
        "password_confirmation": _password
      });
    } catch (err) {
      print(err);
    }
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
              hintText: "Ingrese su usuario",
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
            text: "Iniciar sesión",
            callback: () async {
              await loginMSAuth();
            },
          )
        ],
      ),
    );
  }
}

class Chat extends StatefulWidget {
  static const String id = "chat";
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
  }

  final String query = r"""
  query{
    allUsers{
      username
    }
  }
  """;

  Widget build(BuildContext context) {
    return Scaffold(
        body: prefix0.Query(
      options: QueryOptions(document: query),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.errors != null) {
          return Text(result.errors.toString());
        }
        if (result.loading) {
          return Text("Cargando...");
        }
        final List<LazyCacheMap> all =
            (result.data['allUsers'] as List<dynamic>).cast<LazyCacheMap>();
        var aux = new List(all.length);

        for (var i = 1; i < all.length; i++) {
          aux[i] = all[i]['username'];
          print(aux[i]);
        }
        return prefix1.Container(
          child: prefix1.ListView.builder(
            itemCount: all.length,
            itemBuilder: (context, index) {
              var title = all[index]['username'];
              return prefix1.GestureDetector(
                  onTap: () {},
                  child: prefix1.Container(
                      width: double.maxFinite,
                      height: 77,
                      child: prefix1.Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: prefix1.Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  prefix1.Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Image(
                                          width: 45,
                                          height: 45,
                                          image: AssetImage(
                                              "assets/images/pug.png"))),
                                  prefix1.Column(
                                    crossAxisAlignment: prefix1.CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        title,
                                        style: prefix1.TextStyle(
                                          fontSize: 25,
                                          fontWeight: prefix1.FontWeight.bold
                                        ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              )
                            ],
                          ))));
            },
          ),
        );
      },
    ));
  }

  void debug() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String debug = prefs.getString('username');
    int id_user = prefs.getInt('id_user');
    print(id_user);
    print(debug);
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    int id_user = prefs.getInt('id_user');
    return username;
  }
}

class Chatcito extends StatefulWidget {
  static const String id = "chatcito";
  @override
  _ChatState createState() => _ChatState();
}


class _Chatcito extends State<Chatcito> {

  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  } 
}