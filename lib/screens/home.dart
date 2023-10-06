import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/add_item.dart';
import 'package:flutter_firebase/screens/item_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddItem()));
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Container(padding: const EdgeInsets.all(10), child: const ItemList()),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched.
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "Item Empty",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        }
        final items = snapshot.data!.docs;

        // Map the fetched documents to ItemCard widgets
        final itemCards = items.map((item) {
          final data = item.data() as Map<String, dynamic>;
          final id = item.id;
          final itemName = data['name'] ?? ''; // Replace 'name' with the actual field name
          final itemNotes = data['notes'] ?? ''; // Replace 'description' with the actual field name
          final quantity = data['quantity'] ?? ''; // Replace 'price' with the actual field name

          return ItemsCard(
            id: id,
            item: itemName,
            qty: quantity,
            notes: itemNotes,
          );
        }).toList();

        return Column(
          children: itemCards,
        );
      },
    );
  }
}

class ItemsCard extends StatelessWidget {
  const ItemsCard({
    super.key,
    required this.item,
    required this.notes,
    required this.qty,
    required this.id,
  });
  final String id;
  final String item;
  final String notes;
  final String qty;
  void deleteItem(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('items').doc(id).delete();
      Navigator.of(context).pop(); // Close the confirmation dialog
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetail(id: id, item: item, qty: qty, notes: notes)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Anda yakin ingin menghapus item ini?"),
                        actions: [
                          TextButton(onPressed: () => deleteItem(context), child: const Text("OK"))
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete_outline_rounded))
          ],
        ),
      ),
    );
  }
}
