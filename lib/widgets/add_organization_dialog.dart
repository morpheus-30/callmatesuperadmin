import 'package:callmatesuperadmin/firestore_service.dart';
import 'package:flutter/material.dart';

class AddOrganizationDialog extends StatelessWidget {
  AddOrganizationDialog({super.key});

  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Organization'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Enter the phone number of the manager'),
          TextField(
            maxLength: 10,
            onChanged: (value) => phoneNumber = value,
            decoration: const InputDecoration(hintText: 'Phone number'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async{
            if(await FirestoreService().managerExists(phoneNumber)){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Manager already exists")));
              return;
            }

            // Add organization
            String organizationId = await FirestoreService().createOrganization();
            // Assign manager to organization
            await FirestoreService().assignManagerToOrg(phoneNumber, organizationId);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}


