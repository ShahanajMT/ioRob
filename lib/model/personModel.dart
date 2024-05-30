import 'package:hive/hive.dart';

part 'personModel.g.dart';

@HiveType(typeId: 1)
class PersonModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int age;
  @HiveField(2)
  final String gender;
  PersonModel({
    required this.name,
    required this.age,
    required this.gender,
  });
}
