import 'package:callmatesuperadmin/data_models/organization_model.dart';
import 'package:callmatesuperadmin/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createOrganization() async {
    List<String> orgs =
        await _firestore.collection('organizations').get().then((value) {
      return value.docs.map((e) => e.id).toList();
    });
    String organizationId = generateOrgCode();
    while (orgs.contains(organizationId)) {
      organizationId = generateOrgCode();
    }
    try {
      await _firestore.collection('organizations').doc(organizationId).set({});
      return organizationId;
    } catch (e) {
      return "";
    }
  }

  Future<bool> assignManagerToOrg(
      String phoneNumber, String organizationId) async {
    try {
      await _firestore
          .collection('managers')
          .doc("$phoneNumber@gmail.com")
          .set({'organizationId': organizationId});
          await _firestore.collection('organizations').doc(organizationId).update({'mobileNumber': phoneNumber});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isSuperAdmin(String email) async {
    print(email);
    try {
      bool isSuperAdmin = await _firestore
          .collection('superadmin')
          .doc(email)
          .get()
          .then((value) => value.exists);
      return isSuperAdmin;
    } catch (e) {
      return false;
    }
  }

  Future<List<Organization>> getOrganizations() async {
    List<Organization> orgs;

    try {
      orgs = await _firestore.collection('organizations').get().then((value) {
        // print(value.docs);
        return value.docs
            .map((e) => Organization.fromMap(e.data(), e.id))
            .toList();
      });
      return orgs;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> managerExists(String phoneNumber) async {
    try {
      bool managerExists = await _firestore
          .collection('managers')
          .doc("$phoneNumber@gmail.com")
          .get()
          .then((value) => value.exists);
      return managerExists;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeAccess(Organization organization) async {
    if(organization.mobileNumber==""){
      return;
    }
    try {
      await _firestore
          .collection('managers')
          .doc("${organization.mobileNumber}@gmail.com")
          .delete();
          await _firestore.collection('organizations').doc(organization.organizationId).update({'mobileNumber': ""});
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOrganizationMobileNumber(Organization organization, String mobileNumber) async {
    if(organization.mobileNumber==mobileNumber){
      return;
    }

    if(organization.mobileNumber!=""){
      await _firestore.collection('managers').doc("${organization.mobileNumber}@gmail.com").delete();
    }
    try {
      await _firestore.collection('organizations').doc(organization.organizationId).update({'mobileNumber': mobileNumber});
      await _firestore.collection('managers').doc("$mobileNumber@gmail.com").set({'organizationId': organization.organizationId});
    } catch (e) {
      print(e);
    }
  }
}
