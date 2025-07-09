class Employee {
  String id;
  String name;
  String position;
  int age;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.age,
  });

  /// Convert object to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'age': age,
    };
  }

  /// Create object from Firestore document
  factory Employee.fromMap(String id, Map<String, dynamic> map) {
    return Employee(
      id: id,
      name: map['name'] ?? '',
      position: map['position'] ?? '',
      age: map['age'] ?? 0,
    );
  }
}
