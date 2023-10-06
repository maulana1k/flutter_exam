import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _notesController = TextEditingController();

  Future<void> _addItem() async {
    try {
      final String name = _nameController.text.trim();
      final String quantity = _qtyController.text.trim();
      final String notes = _notesController.text.trim();

      if (name.isNotEmpty) {
        await FirebaseFirestore.instance.collection('items').add({
          'name': name,
          'quantity': quantity,
          'notes': notes,
        });

        // Reset the text fields after adding the item
        _nameController.clear();
        _qtyController.clear();
        _notesController.clear();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Item added to Firestore'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter valid item details'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding item: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(label: Text("Item name")),
            ),
            TextField(
              controller: _qtyController,
              decoration: const InputDecoration(label: Text("Quantity")),
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(label: Text("Notes")),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _addItem, child: const Text("Add item")))
          ],
        ),
      ),
    );
  }
}
