import 'package:callmatesuperadmin/data_models/organization_model.dart';
import 'package:callmatesuperadmin/firestore_service.dart';
import 'package:flutter/material.dart';

class OrganizationDetailedDialog extends StatefulWidget {
  // const OrganizationDetailedDialog({super.key});
  Organization organization;
  OrganizationDetailedDialog({required this.organization});

  @override
  State<OrganizationDetailedDialog> createState() =>
      _OrganizationDetailedDialogState();
}

class _OrganizationDetailedDialogState
    extends State<OrganizationDetailedDialog> {
  bool isEditing = false;
  String newMobileNumber = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.organization.companyName==""?"No Company Name":widget.organization.companyName?? "No Company Name"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width:900,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                "Organization ID: ${widget.organization.organizationId}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              isEditing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            maxLength: 10,
                            initialValue: widget.organization.mobileNumber,
                            decoration: InputDecoration(
                              hintText: "Enter Mobile Number",
                            ),
                            onChanged: (value) {
                              newMobileNumber = value;
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              // await FirestoreService().assignManagerToOrg(newMobileNumber, widget.organization.organizationId);
                              if (newMobileNumber.length == 10) {
                                FirestoreService()
                                    .updateOrganizationMobileNumber(
                                        widget.organization, newMobileNumber);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Invalid Mobile Number")));
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Mobile Number Updated")));
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.done)),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                              });
                            },
                            icon: Icon(Icons.close))
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mobile Number: ${widget.organization.mobileNumber}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                            icon: Icon(Icons.edit))
                      ],
                    ),
                ],
              ),
                    SizedBox(height: 20,),
              Text(
                  "Email: ${widget.organization.email == "" ? "No Email" : widget.organization.email}"),
                  SizedBox(height: 20,),
              Text(
                  "Manager Name: ${widget.organization.managerName== "" ? "No Manager Name" : widget.organization.managerName}"),
                  SizedBox(height: 20,),
              Text(
                "Custom fields: ${widget.organization.customFields == null ? "No Custom Fields" : widget.organization.customFields.toString()}",),
              SizedBox(height: 20,),
              Text("Categories: ${widget.organization.categories == null ? "No Categories" : widget.organization.categories.toString()}"),
              


            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
