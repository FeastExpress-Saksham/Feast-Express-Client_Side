import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:munchmate/common/colors.dart';
import 'package:munchmate/features/home/screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController aadhar = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController image = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  String otherpage = '0';
  bool _passwordVisible = false;
  @override
  initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffF5F9FF),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 150,
                    width: 150,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Getting Started.!',
                  style: TextStyle(
                      fontFamily: "Jost",
                      color: Color(0xff202244),
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: Color(0xff505050)),
                    controller: aadhar,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the username";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      prefixIconColor: Color(0xff545454),
                      // filled: true,
                      // fillColor: Color(0xffffffff),
                      enabledBorder: InputFormfieldBorder,
                      focusedBorder: InputFormfieldBorder,
                      errorBorder: InputFormfieldBorder,
                      focusedErrorBorder: InputFormfieldBorder,
                      border: InputFormfieldBorder,
                      hintText: "Username",
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff505050)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    style: TextStyle(color: Color(0xff505050)),
                    controller: pass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter address";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.place),
                      prefixIconColor: Color(0xff545454),
                      // filled: true,
                      // fillColor: Color(0xffffffff),
                      enabledBorder: InputFormfieldBorder,
                      focusedBorder: InputFormfieldBorder,
                      errorBorder: InputFormfieldBorder,
                      focusedErrorBorder: InputFormfieldBorder,
                      border: InputFormfieldBorder,
                      hintText: "Address",

                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff505050),
                      ),

                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Color(0xff505050)),
                    controller: email,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@') ||
                          !value.contains('.')) {
                        return 'Invalid Email';
                      } else if (value == null || value.isEmpty) {
                        return "Please enter the email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline),
                      prefixIconColor: Color(0xff545454),
                      // filled: true,
                      // fillColor: Color(0xffffffff),
                      enabledBorder: InputFormfieldBorder,
                      focusedBorder: InputFormfieldBorder,
                      errorBorder: InputFormfieldBorder,
                      focusedErrorBorder: InputFormfieldBorder,
                      border: InputFormfieldBorder,
                      hintText: "Email",
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff505050)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Color(0xff505050)),
                    controller: phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the number";
                      } else if (phone.text.length < 10) {
                        return "Please enter 10 digit number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      prefixIconColor: Color(0xff545454),
                      // filled: true,
                      // fillColor: Color(0xffffffff),
                      enabledBorder: InputFormfieldBorder,
                      focusedBorder: InputFormfieldBorder,
                      errorBorder: InputFormfieldBorder,
                      focusedErrorBorder: InputFormfieldBorder,
                      border: InputFormfieldBorder,
                      hintText: "Phone Number",
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff505050)),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: width * 0.8,
                  height: height * 0.07,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(primaryColor)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String res = await login(
                            aadhar.text, email.text, pass.text, phone.text);
                        if (res == "Success") {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        }
                      }
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.2,
                        ),
                        Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: width * 0.155,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                              color: primaryColor,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String res = await login(
                                    aadhar.text,
                                    email.text,
                                    pass.text,
                                    phone.text,
                                  );
                                  print(res);
                                  if (res == "Success") {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()));
                                  }
                                }
                              },
                              icon: Icon(Icons.arrow_forward)),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputBorder InputFormfieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  );
  Future<String> login(
      String aadharno, String email, String password, String phone) async {
    try {
      Response response = await post(
        Uri.parse(
            "https://e-commerce-marketplace-pfdj.onrender.com/api/auth/register"),
        headers: {
          'Content-Type': "application/json",
        },
        body: jsonEncode(
          {
            "username": aadharno,
            "email": email,
            "password": "harsh12345",
            "phoneNumber": phone,
            "address": password,
            "type": "buyer"
          },
        ),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        print('Login successfully');
        return "Success";
      } else {
        print('failed');
        print(response.statusCode);
        return "Fail";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
