import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ionob_task/view/home_page.dart';
import 'package:ionob_task/model/personModel.dart';
import 'package:ionob_task/view/homewithmdl.dart';

 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //! ----- InitializeHive ------!//
  await Hive.initFlutter();

  Hive.registerAdapter(PersonModelAdapter());

  //! ------- OpenHiveBox -------!//
  await Hive.openBox('personBox');
  //await Hive.openBox('note');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive CRUD',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home()
    );
  }
}


