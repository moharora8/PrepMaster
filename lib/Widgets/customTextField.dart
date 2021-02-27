import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type1;
  final IconData data;
  final String hintText;
  bool isObsecure = true;
  int maxlength;
  CustomTextField(
      {Key key,
      this.type1,
      this.controller,
      this.data,
      this.hintText,
      this.isObsecure,
      this.maxlength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10),
      child: TextFormField(
        validator: (value) => value.isEmpty ? 'Field can\'t be blank' : null,
        keyboardType: type1,
        maxLength: maxlength != null ? maxlength : null,
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              data,
              color: Theme.of(context).primaryColor,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText),
      ),
    );
  }
}
