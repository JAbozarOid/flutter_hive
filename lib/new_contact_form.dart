import 'package:flutter/material.dart';
import 'package:flutter_hive/models/contact.dart';
import 'package:hive/hive.dart';

class NewContactForm extends StatefulWidget {
  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _age;

  void addContact(Contact contact) {
    print('Name: ${contact.name}, Age: ${contact.age}');

    // two basic option for adding data into database
    // 1-
    //Hive.box('contacts').put(1, contact);

    // 2- in this case there is a problem, contact is not a type that save into Hive -> so we need to create type adapter
    // so we need to use hive generator in the model Contact
    // command line for generate ContactAdapter ->  flutter packages pub run build_runner build
    final contactsBox = Hive.box('contacts');
    contactsBox.add(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value,
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _age = value,
                ),
              )
            ],
          ),
          RaisedButton(
              child: Text('Add New Contact'),
              onPressed: () {
                _formKey.currentState.save();
                final newContact = Contact(_name, int.parse(_age));
                addContact(newContact);
              })
        ],
      ),
    );
  }
}
