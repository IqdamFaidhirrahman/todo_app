import 'package:firebase_database/firebase_database.dart';
import '../models/todo_model.dart';

class TodoService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('todos');

  Future<List<Todo>> fetchTodos() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map).entries.map((entry) {
        return Todo.fromMap(entry.key, Map<String, dynamic>.from(entry.value));
      }).toList();
    }
    return [];
  }

  Future<void> addTodo(Todo todo) async {
    await _dbRef.push().set(todo.toMap());
  }

  Future<void> toggleComplete(String id, bool currentStatus) async {
    await _dbRef.child(id).update({'completed': !currentStatus});
  }

  Future<void> deleteTodo(String id) async {
    await _dbRef.child(id).remove();
  }

  Future<void> updateTodo(String id, String newTitle) async {
    await _dbRef.child(id).update({'title': newTitle});
  }
}
