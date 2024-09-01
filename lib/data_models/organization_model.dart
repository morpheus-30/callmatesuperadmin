class Organization {
  final String organizationId;
  final String? companyName;
  final String? email;
  final String? mobileNumber;
  final String? managerName;
  final String? salesCode;
  final List? customFields;
  final List? categories;

  Organization({
    required this.organizationId,
    this.companyName,
    required this.email,
    this.mobileNumber,
    this.managerName,
    this.salesCode,
    this.customFields,
    this.categories,
  });

  factory Organization.fromMap(Map<String, dynamic> data, String organizationId) {
    return Organization(
      organizationId: organizationId,
      companyName: data['companyName']??"",
      email: data['email']?? "",
      mobileNumber: data['mobileNumber']?? "",
      managerName: data['name']?? "",
      salesCode: data['salesCode']?? "",
      customFields: data['Custom Fields']?? [],
      categories: data['categories']?? [],
    );
  }


}