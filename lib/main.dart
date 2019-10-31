import 'package:dio/dio.dart' as prefix2;
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
    final HttpLink httplink = HttpLink(uri: "http://172.17.0.1:5000/graphql");
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
        Usuario.id: (context) => Usuario(),
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

class Usuario extends StatelessWidget {
  static const String id = "usuario";
  String _username = '';
  String _mail = '';
  String _photoUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Pug Chat"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                      width: 100.0, child: Image.asset("assets/images/pug.png")),  //"this._photoUrl"
                ),
                SizedBox(
                  height: 50.0,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  this._username,
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 40.0,
                      color: Colors.white),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  this._mail,
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 40.0,
                      color: Colors.white),
                )
              ],
            ),
          ],
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
          "http://172.17.0.1:3000/signup/" + _username + "/" + _password);
      print(response);
      response =
          await jotaro.post("http://172.17.0.1:4002/users/create", data: {
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
  Response response2;
  String _username = "";
  String _email = "";
  String _password = "";
  int id_user;
  void loginMSAuth() async {
    try {
      response = await jotaro.get(
          "http://172.17.0.1:3000/api/signin/" + _username + "/" + _password);
      response2 = await jotaro.get(
          "http://172.17.0.1:4002/users/findByUsername?username=" +
              _username);
      id_user = response2.data['id'];
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

List<Choice> choices = const <Choice>[
  const Choice(title: 'User', icon: Icons.settings),
  const Choice(title: 'Log out', icon: Icons.exit_to_app),
];

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}


class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
  }

  saveUserID(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id_user2', id);
  }

  final String query = r"""
  query{
    allUsers{
      username
      id
    }
  }
  """;
  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {

    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Usuario()));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pug Chat"),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            choice.icon,
                            color: Colors.white,
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            choice.title,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ));
                }).toList();
              },
            ),
          ],
        ),
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
              var id = all[index]['id'];
                return prefix1.GestureDetector(
                  onTap: () {
                    saveUserID(id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chatcito(),
                      ),
                    );
                  },
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
                                    crossAxisAlignment:
                                        prefix1.CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        title,
                                        style: prefix1.TextStyle(
                                            fontSize: 25,
                                            fontWeight:
                                                prefix1.FontWeight.bold),
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

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username');
    String mail = prefs.getString('mail');
    int id_user = prefs.getInt('id_user');
    return id_user;
  }
}

class Chatcito extends StatefulWidget {
  static const String id = "chatcito";
  @override
  _ChatcitoState createState() => _ChatcitoState();
}

class _ChatcitoState extends State<Chatcito> {
  final Firestore _firestore = Firestore.instance;

  prefix1.TextEditingController messagecontroller =
      prefix1.TextEditingController();
  prefix1.ScrollController scrollController = prefix1.ScrollController();

  var username1;
  var username2;

  var help;

  getUsername1() async {
    Response response;
    Dio jotaro = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id_user = prefs.getInt('id_user');
    response = await jotaro
        .get("http://172.17.0.1:4002/users/" + id_user.toString());
    setState(() {
      username1 = response.data['username'];
    });
    print("username1 chatcito ${username1}");
  }

  getUsername2() async {
    Response response;
    Dio jotaro = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id_user2 = prefs.getInt('id_user2');
    response = await jotaro
        .get("http://172.17.0.1:4002/users/" + id_user2.toString());
    prefs.setString('username2', response.data['username']);
    setState(() {
      username2 = response.data['username'];
    });
    print("username2 chatcito ${username2}");
  }

  Future<void> callback() async {
    Response response, response1;
    Dio jotaro = new Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id_user2 = prefs.getInt('id_user2');
    response = await jotaro
        .get("http://172.17.0.1:4002/users/" + id_user2.toString());
    var username2 = response.data['username'];
    var id1 = response.data['id'];
    int id_user = prefs.getInt('id_user');
    response1 = await jotaro
        .get("http://172.17.0.1:4002/users/" + id_user.toString());
    var username1 = response1.data['username'];
    var id2 = response.data['id'];
    if (messagecontroller.text.length > 0) {
      await _firestore.collection('chat').add({
        'text': messagecontroller.text,
        'from': username1,
        'to': username2,
        'date': DateTime.now().toIso8601String().toString(),
      });
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
      response =
          await jotaro.post("http://172.17.0.1:8080/messages/", data: {
        "emisor": 2,
        "receptor": 1,
        "mensaje": messagecontroller.text.toString(),
        "date": DateTime.now().toIso8601String()
      });
      messagecontroller.clear();
    }

  }

  @override
  void initState() {
    super.initState();
    getUsername2();
    getUsername1();    
  }

  Widget build(BuildContext context) {
    return prefix1.Scaffold(
      appBar: prefix1.AppBar(
        leading: prefix1.Hero(
            tag: 'logo',
            child: prefix1.Container(
              height: 40,
              child: Image.asset("assets/images/pug.png"),
            )),
        title: Text("PugChat"),
        actions: <Widget>[
          prefix1.IconButton(
              icon: prefix1.Icon(Icons.close),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                prefix1.Navigator.of(context)
                    .popUntil((route) => route.isFirst);
              })
        ],
      ),
      body: prefix1.SafeArea(
          child: prefix1.Column(
        mainAxisAlignment: prefix1.MainAxisAlignment.spaceBetween,
        children: <Widget>[
            prefix1.Expanded(
              child: prefix1.StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('chat').orderBy('date').snapshots(),//_firestore.collection('chat').snapshots(),
              builder: (context, snapshot) {
              if (!snapshot.hasData)
                return prefix1.Center(
                  child: prefix1.CircularProgressIndicator(),
                );
              List<DocumentSnapshot> docs = snapshot.data.documents;

              List<Widget> messages = docs
                  .map((doc) => Message(
                        from: doc.data['from'],
                        text: doc.data['text'],
                        me: username1 == doc.data['from'],
                        date: doc.data['date']
                      ))
                  .toList();

              return prefix1.ListView(
                controller: scrollController,
                children: <Widget>[
                  ...messages,
                ],
              );
            },
          )),
          prefix1.Container(
              child: prefix1.Row(
            children: <Widget>[
              prefix1.Expanded(
                child: TextField(
                    onSubmitted: (value) => callback(),
                    decoration: new prefix1.InputDecoration(
                      hintText: username2,
                      border: const prefix1.OutlineInputBorder(),
                    ),
                    autocorrect: true,
                    controller: messagecontroller),
              ),
              SendButton(
                text: "Enviar",
                callback: callback,
              )
            ],
          ))
        ],
      )),
    );
  }

  debug() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id_user = prefs.getInt('id_user');
    int id_user2 = prefs.getInt('id_user2');
    print("id1 = ${id_user}");
    print("id2 = ${id_user2}");
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.red,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final String date;
  final bool me;

  const Message({Key key, this.from, this.text, this.date, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: prefix1.Column(
          crossAxisAlignment: me
              ? prefix1.CrossAxisAlignment.end
              : prefix1.CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              from,
            ),
            prefix1.Material(
              color: me ? Colors.red : Colors.deepPurple,
              borderRadius: prefix1.BorderRadius.circular(10.0),
              elevation: 6.0,
              child: prefix1.Container(
                padding: prefix1.EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
              text,
            ),
          ),
        )
      ],
    ));
  }
}

