import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagrem_flutter/models/user.dart';
import 'package:instagrem_flutter/providers/user_provider.dart';
import 'package:instagrem_flutter/resources/firestore_methods.dart';
import 'package:instagrem_flutter/utils/colors.dart';
import 'package:instagrem_flutter/utils/utils.dart';
import 'package:instagrem_flutter/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class addCommunitiesScreen extends StatefulWidget {
  const addCommunitiesScreen({Key? key}) : super(key: key);

  @override
  _addCommunitiesScreenState createState() => _addCommunitiesScreenState();
}

class _addCommunitiesScreenState extends State<addCommunitiesScreen> {
  final TextEditingController _titleEdintingController =
      TextEditingController();
  final TextEditingController _bioEditingController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleEdintingController.dispose();
    _bioEditingController.dispose();
  }

  void selectingImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void createCommunitie(
    String uid,
    String userName,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      String res = await FirestoreMethods().CreateCommunitie(
        _titleEdintingController.text,
        _bioEditingController.text,
        uid,
        userName,
        _image!,
      );
      if (res == "success") {
        showSnackBar("作成しました", context);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("コミュニティを作成"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.grey,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        onPressed: selectingImage,
                        icon: const Icon(Icons.photo_library_outlined),
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Text("コミュニティ名"),
          TextFieldInput(
              textEditingController: _titleEdintingController,
              hintText: "コミュニティ名を入力",
              textInputType: TextInputType.text),
          Text("説明"),
          TextField(
            controller: _bioEditingController,
            decoration: const InputDecoration(
              hintText: "説明を入力...",
              border: InputBorder.none,
            ),
            maxLines: 8,
          ),
          InkWell(
            onTap: () => {
              createCommunitie(
                user.uid,
                user.username,
              ),
            },
            child: Container(
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : Text("作成"),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: blueColor,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
