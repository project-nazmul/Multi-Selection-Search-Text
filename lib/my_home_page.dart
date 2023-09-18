import 'package:flutter/material.dart';
import 'package:flutter_simple_multiselect/flutter_simple_multiselect.dart';
import 'package:multi_select/select_tag.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Color lineColor = const Color.fromRGBO(36, 37, 51, 0.04);
  List selectedItems = [];
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> testData = [
    {"uuid": 1, "name": "Alfred Johanson"},
    {"uuid": 2, "name": "Goran Borovic"},
    {"uuid": 3, "name": "Ivan Horvat"},
    {"uuid": 4, "name": "Bjorn Sigurdson"}
  ];

  Future<List<Map<String, dynamic>>> searchFunction(query) async {
    return testData.where((element) {
      return element["name"].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(bottom: 10), child: Text("Static data multiselect")),
                    _staticData(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          child: const Text("submit"),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              print(selectedItems);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _staticData() {
    return FlutterMultiselect(
        autofocus: false,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        enableBorderColor: lineColor,
        focusedBorderColor: lineColor,
        borderRadius: 5,
        borderSize: 2,
        resetTextOnSubmitted: true,
        minTextFieldWidth: 300,
        suggestionsBoxMaxHeight: 300,
        length: selectedItems.length,
        tagBuilder: (context, index) => SelectTag(
          index: index,
          label: selectedItems[index]["name"],
          onDeleted: (value) {
            selectedItems.removeAt(index);
            setState(() {});
          },
        ),
        suggestionBuilder: (context, state, data) {
          var existingIndex = selectedItems.indexWhere((element) => element["uuid"] == data["uuid"]);
          var selectedData = data;
          return Material(
            child: ListTile(
                dense: true,
                selected: existingIndex >= 0,
                trailing: existingIndex >= 0 ? const Icon(Icons.check) : null,
                selectedColor: Colors.white,
                selectedTileColor: Colors.green,
                title: Text(selectedData["name"].toString()),
                onTap: () {
                  if (existingIndex >= 0) {
                    selectedItems.removeAt(existingIndex);
                  } else {
                    selectedItems.add(data);
                  }

                  state.selectAndClose(data);
                  setState(() {});
                }),
          );
        },
        suggestionsBoxElevation: 10,
        findSuggestions: (String query) async {
          setState(() {
            isLoading = true;
          });
          var data = await searchFunction(query);
          setState(() {
            isLoading = false;
          });
          return data;
        });
  }
}