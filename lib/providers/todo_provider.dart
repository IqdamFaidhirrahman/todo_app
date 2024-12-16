import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  bool isLoading = false;

  List<Todo> get todos => _todos;
  
  Future<void> fetchTodos() async {
    isLoading = true;
    notifyListeners();
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception("User is not logged in.");
      }
      _todos = await _todoService.fetchTodosByUser(uid);
    } catch (e) {
      print("Error fetching todos: $e");
      _todos = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(String title) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("User is not logged in.");
    }
    final newTodo = Todo(id: '', title: title, completed: false);
    await _todoService.addTodoForUser(uid, newTodo);
    await fetchTodos();
    notifyListeners();
  }

  Future<void> toggleComplete(String id, bool currentStatus) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("User is not logged in.");
    }
    await _todoService.toggleCompleteForUser(uid, id, currentStatus);
    await fetchTodos();
  }

  Future<void> deleteTodo(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("User is not logged in.");
    }
    await _todoService.deleteTodoForUser(uid, id);
    await fetchTodos();
  }

  Future<void> updateTodo(String id, String newTitle) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("User is not logged in.");
    }
    await _todoService.updateTodoForUser(uid, id, newTitle);
    await fetchTodos(); // Refresh data
  }
}
