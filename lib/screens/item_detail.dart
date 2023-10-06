import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/edit_items.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail(
      {super.key, required this.id, required this.item, required this.qty, required this.notes});

  final String id;
  final String item;
  final String qty;
  final String notes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Item"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Quantity: $qty",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Text(
                notes,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  print("Edit item");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditItems(id: id, name: item, quantity: qty, notes: notes)));
                },
                child: const Text("Edit item"))
          ],
        ),
      )),
    );
  }
}
