import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditItems extends StatefulWidget {
  final String id;
  final String name;
  final String quantity;
  final String notes;

  const EditItems({
    Key? key,
    required this.name,
    required this.quantity,
    required this.notes,
    required this.id,
  }) : super(key: key);

  @override
  State<EditItems> createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _notesController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Set the initial values of the text controllers to the passed data
    _nameController.text = widget.name;
    _qtyController.text = widget.quantity.toString();
    _notesController.text = widget.notes;
  }

  Future<void> _updateItem() async {
    try {
      final String newName = _nameController.text.trim();
      final String newQuantity = _qtyController.text.trim();
      final String newNotes = _notesController.text.trim();

      if (newName.isNotEmpty) {
        await FirebaseFirestore.instance.collection('items').doc(widget.id).update({
          'name': newName,
          'quantity': newQuantity,
          'notes': newNotes,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Item updated in Firestore'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter valid item details'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating item: $e'),
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
                child: ElevatedButton(onPressed: _updateItem, child: const Text("Update item")))
          ],
        ),
      ),
    );
  }
}
