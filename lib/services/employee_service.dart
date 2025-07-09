import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/model/employee.dart';


class EmployeeService {
  final CollectionReference employeeCollection =
  FirebaseFirestore.instance.collection('employees');

  /// Add a new employee
  Future<void> addEmployee(Employee employee) async {
    await employeeCollection.add(employee.toMap());
  }

  /// Get all employees (for non-realtime use)
  Future<List<Employee>> getEmployees() async {
    QuerySnapshot snapshot = await employeeCollection.get();
    return snapshot.docs.map((doc) {
      return Employee.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  }

  /// Listen to real-time employee changes
  Stream<List<Employee>> getEmployeeStream() {
    return employeeCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Employee.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  /// Update an existing employee
  Future<void> updateEmployee(Employee employee) async {
    await employeeCollection.doc(employee.id).update(employee.toMap());
  }

  /// Delete an employee
  Future<void> deleteEmployee(String id) async {
    await employeeCollection.doc(id).delete();
  }
}
