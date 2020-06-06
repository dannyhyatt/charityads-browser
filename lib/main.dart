import 'package:charityadsbrowser/notifiers.dart';

import 'tabs_view.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Database database;

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => Tabs(),
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TabPreviewNotifier>(
      create: (context) => TabPreviewNotifier(Tabs()),
      child: MaterialApp(
        title: 'Charity Ads Browser',
        theme: ThemeData(
          primaryColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoadingPage(),
      ),
    );
  }
}

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  BuildContext ctx;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {

    database = await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'tabs.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        debugPrint('yuh');
        return db.execute(
          "CREATE TABLE tabs(tab_index TIMESTAMP PRIMARY KEY, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP, url TEXT, title TEXT);",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) => TabsView()));
  }

  @override
  Widget build(BuildContext context) {

    Provider.of<TabPreviewNotifier>(context, listen: false).tabs.addTab(BrowserTab()..addTabInstance(TabInstance(
        url: 'https://google.com'
    )));

    ctx = context; // damn this felt wrong
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
