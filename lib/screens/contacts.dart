import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:call_number/call_number.dart';

import '../permission_services.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Iterable<Contact> _contacts;
  int _selectedIndex = 0;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  _initCall(String number) async {
    await new CallNumber().callNumber(number);
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts(
        withThumbnails: false, photoHighResolution: false);
    setState(() {
      _contacts = contacts;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    PermissionsService().requestContactsPermission();
    return Center(
      child: _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx < -1) {
                  //Left Swipe
                  _onItemTapped(1);
                }
              },
              child: ListView.builder(
                itemCount: _contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = _contacts?.elementAt(index);
                  return ListTile(
                    onTap: () {
                      _initCall(contact.phones.first.value.toString());
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                    leading:
                        (contact.avatar != null && contact.avatar.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar),
                              )
                            : CircleAvatar(
                                child: Text(contact.initials()),
                                backgroundColor: Theme.of(context).accentColor,
                              ),
                    title: Text(
                      contact.displayName ?? '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    //This can be further expanded to showing contacts detail
                    // onPressed().
                  );
                },
              ),
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}
