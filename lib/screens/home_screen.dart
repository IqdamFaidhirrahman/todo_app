import 'package:flutter/material.dart';
import 'package:projek_multiplatform/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: todoProvider.fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (todoProvider.todos.isEmpty) {
            return const Center(child: Text("No tasks available"));
          }
          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Wrap(
                    spacing: 12,
                    children: [
                      Checkbox(
                        value: todo.completed,
                        onChanged: (value) {
                          todoProvider.toggleComplete(todo.id, todo.completed);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showTodoDialog(
                            context,
                            todoProvider,
                            todoId: todo.id,
                            currentTitle: todo.title,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          todoProvider.deleteTodo(todo.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showTodoDialog(context, todoProvider);
        },
      ),
    );
  }

  void _showTodoDialog(BuildContext context, TodoProvider todoProvider,
      {String? todoId, String? currentTitle}) {
    final titleController = TextEditingController(text: currentTitle);
    final isEditing = todoId != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? "Edit To-Do" : "Add To-Do"),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: "Task Title"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Title cannot be empty")),
                );
                return;
              }
              if (isEditing) {
                todoProvider.updateTodo(todoId, title);
              } else {
                todoProvider.addTodo(title);
              }
              Navigator.of(context).pop();
            },
            child: Text(isEditing ? "Update" : "Add"),
          ),
        ],
      ),
    );
  }
}
