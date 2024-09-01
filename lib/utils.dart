
import 'dart:math';


String generateOrgCode() {
  String code = "";
  var random = Random();
  for (var i = 0; i < 3; i++) {
    code += String.fromCharCode(random.nextInt(26) + 65);
  }
  code += "-";
  for (var i = 0; i < 4; i++) {
    code += random.nextInt(10).toString();
  }
  code += "-";
  for (var i = 0; i < 3; i++) {
    code += random.nextInt(10).toString();
  }
  return code;
}
