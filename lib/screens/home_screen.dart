import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crud/screens/signin_screen.dart';
import 'package:crud/model/employee.dart';
import 'package:crud/services/employee_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EmployeeService _employeeService = EmployeeService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  void showAddEmployeeDialog({Employee? employee}) {
    if (employee != null) {
      nameController.text = employee.name;
      positionController.text = employee.position;
      ageController.text = employee.age.toString();
    } else {
      nameController.clear();
      positionController.clear();
      ageController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(employee == null ? "Add Employee" : "Edit Employee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: positionController, decoration: const InputDecoration(labelText: "Position")),
            TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final position = positionController.text.trim();
              final age = int.tryParse(ageController.text.trim()) ?? 0;

              if (employee == null) {
                await _employeeService.addEmployee(Employee(id: '', name: name, position: position, age: age));
              } else {
                await _employeeService.updateEmployee(Employee(id: employee.id, name: name, position: position, age: age));
              }

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Manager"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('employees').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No Employees Found"));
          }

          final employees = docs.map((doc) {
            return Employee.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (_, index) {
              final emp = employees[index];
              return ListTile(
                title: Text(emp.name),
                subtitle: Text("${emp.position} • Age: ${emp.age}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => showAddEmployeeDialog(employee: emp),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _employeeService.deleteEmployee(emp.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEmployeeDialog(),
        child: const Icon(Icons.add),
        tooltip: "Add Employee",
      ),
    );
  }
}
