import 'package:callmatesuperadmin/data_models/organization_model.dart';
import 'package:callmatesuperadmin/firestore_service.dart';
import 'package:callmatesuperadmin/widgets/add_organization_dialog.dart';
import 'package:callmatesuperadmin/widgets/organization_detailed_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Organization> organizations = [];

  void updateOrgs() async {
    organizations = await FirestoreService().getOrganizations();
    setState(() {});
  }

  @override
  void initState() {
    updateOrgs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${FirebaseAuth.instance.currentUser!.email!}"),
        actions: [
          IconButton(
            onPressed: () async{
              // print(organizations);
              await showDialog(context: context, builder: (context) => AddOrganizationDialog());
              updateOrgs();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              iconColor: MaterialStateProperty.all(Colors.white),
            ),
            icon: Icon(Icons.add),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                FirebaseAuth.instance.signOut();
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: organizations.isEmpty
            ? Center(
                child: Text("No organizations found"),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: organizations.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      onTap: ()async{
                        await showDialog(context: context, builder: (context) => OrganizationDetailedDialog(organization: organizations[index],));
                        updateOrgs();
                      },
                      title: Text(
                          organizations[index].companyName==""?"No Company Name":organizations[index].companyName!),
                      subtitle: Text(organizations[index].organizationId),
                      trailing: organizations[index].mobileNumber==""?null:IconButton(
                        onPressed: () async{
                          await FirestoreService().removeAccess(organizations[index]);
                          updateOrgs();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Removed access to ${organizations[index].organizationId}"),
                          ));
                        },
                        icon: Icon(Icons.person_remove_alt_1_sharp),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
