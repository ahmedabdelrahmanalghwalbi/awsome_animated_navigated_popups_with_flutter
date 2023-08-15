import 'package:flutter/material.dart';
import 'package:flutter_application_1/fake_data.dart';
import 'package:flutter_application_1/models.dart';
import 'package:flutter_application_1/styles.dart';
import 'add_todo_button.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundFadedColor,
                  AppColors.backgroundColor,
                ],
                stops: [0.0, 1],
              ),
            ),
          ),
          SafeArea(
            child: _TodoListContent(
              todos: fakeData,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AddTodoButton(),
          )
        ],
      ),
    );
  }
}

class _TodoListContent extends StatelessWidget {
  final List<Todo> todos;
  const _TodoListContent({
    required this.todos,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final _todo = todos[index];
        return _TodoCard(todo: _todo);
      },
    );
  }
}

class _TodoCard extends StatelessWidget {
  final Todo todo;
  const _TodoCard({
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: _TodoPopupCard(todo: todo),
            ),
          ),
        );
      },
      child: Hero(
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        tag: todo.id,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Material(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  _TodoTitle(title: todo.description),
                  const SizedBox(
                    height: 8,
                  ),
                  if (todo.items != null) ...[
                    const Divider(),
                    _TodoItemsBox(items: todo.items!),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TodoTitle extends StatelessWidget {
  final String title;
  const _TodoTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}

class _TodoPopupCard extends StatelessWidget {
  const _TodoPopupCard({required this.todo});
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: todo.id,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.cardColor,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TodoTitle(title: todo.description),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 400,
                      height: 400,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TodoItemsBox extends StatelessWidget {
  const _TodoItemsBox({
    required this.items,
  });

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) _TodoItemTile(item: item),
      ],
    );
  }
}

class _TodoItemTile extends StatefulWidget {
  const _TodoItemTile({
    required this.item,
  });

  final Item item;

  @override
  _TodoItemTileState createState() => _TodoItemTileState();
}

class _TodoItemTileState extends State<_TodoItemTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        onChanged: (val) {
          setState(() {
            widget.item.completed = val!;
          });
        },
        value: widget.item.completed,
      ),
      title: Text(widget.item.description),
    );
  }
}
