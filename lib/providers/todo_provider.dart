import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    _todos = await _todoService.fetchTodos();
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(id: '', title: title, completed: false);
    await _todoService.addTodo(newTodo);
    await fetchTodos();
  }

  Future<void> toggleComplete(String id, bool currentStatus) async {
    await _todoService.toggleComplete(id, currentStatus);
    await fetchTodos();
  }

  Future<void> deleteTodo(String id) async {
    await _todoService.deleteTodo(id);
    await fetchTodos();
  }

  Future<void> updateTodo(String id, String newTitle) async {
    await _todoService.updateTodo(id, newTitle);
    await fetchTodos();
  }
}
