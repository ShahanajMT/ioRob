import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/personModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Box _personDetailsBox = Hive.box("personBox");

  List personDetailsList = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? dropdownValue = "Male";

  @override
  Widget build(BuildContext context) {
    personDetailsList = _personDetailsBox.values.toList();
    return Scaffold(
      body: personDetailsList.isEmpty
          ? const Center(
              child: Text("Person Details Empty"),
            )
          : ListView.separated(
              itemCount: personDetailsList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                child: ListTile(
                  leading: personDetailsList[index].gender == 'Male'
                      ? const Icon(
                          Icons.boy_outlined,
                          size: 40,
                          color: Colors.blue,
                        )
                      : const Icon(
                          Icons.girl_outlined,
                          size: 40,
                          color: Colors.pink,
                        ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(personDetailsList[index].name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(
                        "Age: ${personDetailsList[index].age}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        _personDetailsBox.deleteAt(index);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ), separatorBuilder: (BuildContext context, int index) => const Divider(thickness: 2, color: Colors.black),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
                        Column(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))))),
                            const SizedBox(height: 10),
                            TextField(
                                keyboardType: TextInputType.number,
                                controller: ageController,
                                decoration: const InputDecoration(
                                    hintText: "Age",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))))),
                            const SizedBox(height: 10),
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  hintText: "Gender",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              value: dropdownValue,
                              items: ["Male", "Female", "Transgedor", "Other"]
                                  .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                              )))
                                  .toList(),
                              onSaved: (value) {
                                dropdownValue = value;
                              },
                              onChanged: (value) {
                                dropdownValue = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  _personDetailsBox.add(PersonModel(
                                      name: nameController.value.text,
                                      age: int.parse(
                                          ageController.value.text),
                                      gender: dropdownValue ?? ''));
                                });
                                // clear input field values
                                nameController.clear();
                                ageController.clear();
                                print(_personDetailsBox.values);
                                if (!context.mounted) return;
                                Navigator.pop(context);
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
