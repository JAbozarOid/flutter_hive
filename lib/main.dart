import 'package:flutter/material.dart';
import 'package:flutter_hive/contact_page.dart';
import 'package:flutter_hive/models/contact.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  // we should register each box for it's box, but for now we register it globally
  Hive.registerAdapter(ContactAdapter());
  runApp(MyApp());

  // open the box only once -> open boxes per page that you want to use
  //final contactBox = await Hive.openBox('contacts');

  // access the box using Hive.box
  //final contactBox = Hive.box('contacts');
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Tutorail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          // we can open the box in each page that we want to use
          // in this case because we have just one page we define here
          // because openBox return a future we should use FutureBuilder
          FutureBuilder(
        future: Hive.openBox('contacts'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // this if means Hive.openBox('contacts') is completed
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return ContactPage();
          } else
            return Scaffold();
        },
      ),
    );
  }

  @override
  void dispose() {
    // close the specific box
    //Hive.box('contacts').close();

    // close all the boxes
    Hive.close();

    super.dispose();
  }
}
