import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final Function(String) textChanged;

  SearchBox({Key key, this.textChanged}) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController controller;
  FocusNode focusNode;
  bool canCancel = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode()..addListener(focusListener);
  }

  void focusListener() => setState(() => canCancel = focusNode.hasFocus);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        searchTextField(),
        cancelButton(),
      ],
    );
  }

  Widget searchTextField() {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
        keyboardType: TextInputType.text,
        onChanged: (text) => widget.textChanged(text),
        focusNode: focusNode,
      ),
    );
  }

  Widget cancelButton() {
    return Visibility(
      visible: canCancel,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        child: GestureDetector(
          child: Icon(Icons.cancel, color: Colors.tealAccent, size: 30),
          onTap: onCancel,
        ),
      ),
    );
  }

  void onCancel() {
    if (controller.text.isEmpty) focusNode.unfocus();
    widget.textChanged('');
    controller.text = '';
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
