import 'package:flutter/material.dart';
import 'package:flutter_hive/models/contact.dart';
import 'package:flutter_hive/new_contact_form.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildListView()),
          NewContactForm(),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('contacts').listenable(),
      builder: (context, box, _) {
        if (box.values.isEmpty) {
          return Text('data is empty');
        } else {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              var contact = box.getAt(index);
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.age.toString()),
              );
            },
          );
        }
      },
    );
  }
}
