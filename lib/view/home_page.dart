import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();

    String dropdownValue = "Male";

    List<Map<String, dynamic>> items = [];

//!---- Refe -----!//
    final note = Hive.box('note');

//! ---- Refresh----!''
    void refreshItems() {
      final data = note.keys.map((key) {
        final item = note.get(key);
        return {
          "Key": key,
          "name": item['name'],
          "age": item['age'],
        };
      }).toList();

      setState(() {
        items = data.reversed.toList();
        print(items.length);
      });
    }

//! ---- //
    Future<void> createItem(Map<String, dynamic> map) async {
      await note.add(map);
      //log(note.length.toString());
      print('Data is ${note.length}');
    }

//! ----------------------------------------------------------!//

    void showForm(BuildContext context, int itemKey) async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -40,
                top: -40,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close),
                  ),
                ),
              ),
              Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        decoration: const InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))))),
                    const SizedBox(height: 10),
                    TextField(
                        keyboardType: TextInputType.number,
                        controller: ageController,
                        decoration: const InputDecoration(
                            hintText: "Age",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))))),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                          hintText: "Gender",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      //value: gender,
                      items: ["Male", "Female"]
                          .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  )))
                          .toList(),
                      onSaved: (value) {
                        dropdownValue = value!;
                      },
                      onChanged: (value) {
                        dropdownValue = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    //!-----------
                    InkWell(
                      onTap: () {
                        //! createItem
                        createItem({
                          'name': nameController.text,
                          'age': ageController,
                        });

                        //!----clear textFeild
                        nameController.text = '';
                        ageController.text = '';

                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ))
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.indigo),
                        //color: Colors.red,
                        child: const Center(
                          child: Text(
                            'Done',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm(context, 2);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
