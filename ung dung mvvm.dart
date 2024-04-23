import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Assuming you choose Provider for state management

// Model class (unchanged)
class Item {
  final String id;
  final String name;

  Item({required this.id, required this.name});
}

// ItemViewModel using Provider (or Bloc if preferred)
class ItemViewModel extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => _items;

  void addItem(String id, String name) {
    if (id.isNotEmpty && name.isNotEmpty) {
      _items.add(Item(id: id, name: name));
      notifyListeners();
    } else {
      // Handle empty ID or name (display error message)
    }
  }
}

// Reusable ItemInputWidget
class ItemInputWidget extends StatelessWidget {
  final TextEditingController idController;
  final TextEditingController nameController;
  final Function(String, String) onAddItem;

  const ItemInputWidget({
    Key? key,
    required this.idController,
    required this.nameController,
    required this.onAddItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: idController,
          decoration: InputDecoration(labelText: 'ID'),
        ),
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final String id = idController.text;
            final String name = nameController.text;
            onAddItem(id, name);
            idController.clear();
            nameController.clear();
          },
          child: Text('Add Item'),
        ),
      ],
    );
  }
}

// MyApp (using Provider)
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple MVVM Example',
      home: ChangeNotifierProvider<ItemViewModel>(
        create: (context) => ItemViewModel(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemViewModel = Provider.of<ItemViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Simple MVVM Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ItemListView(),
            ),
            ItemInputWidget(
              idController: idController,
              nameController: nameController,
              onAddItem: (id, name) => itemViewModel.addItem(id, name),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemViewModel = Provider.of<ItemViewModel>(
