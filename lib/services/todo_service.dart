import 'package:firebase_database/firebase_database.dart';
import '../models/todo_model.dart';

class TodoService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Fetch todos for a specific user
  Future<List<Todo>> fetchTodosByUser(String uid) async {
    final snapshot = await _dbRef.child('todos/$uid').get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries
          .map((entry) => Todo.fromMap(entry.key, Map<String, dynamic>.from(entry.value)))
          .toList();
    }
    return [];
  }

  // Add a new todo for a specific user
  Future<void> addTodoForUser(String uid, Todo todo) async {
    final newRef = _dbRef.child('todos/$uid').push();
    await newRef.set(todo.toMap());
  }

  // Toggle the completion status of a todo
  Future<void> toggleCompleteForUser(String uid, String id, bool currentStatus) async {
    await _dbRef.child('todos/$uid/$id').update({'completed': !currentStatus});
  }

  // Update the title of a todo
  Future<void> updateTodoForUser(String uid, String id, String newTitle) async {
    await _dbRef.child('todos/$uid/$id').update({'title': newTitle});
  }

  // Delete a todo
  Future<void> deleteTodoForUser(String uid, String id) async {
    await _dbRef.child('todos/$uid/$id').remove();
  }
}
