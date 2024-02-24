import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _textController = TextEditingController();
  void _submit() async {
    final inputMessage = _textController.text;
    if (inputMessage.trim().isEmpty) {
      return;
    }
    _textController.clear();
    FocusScope.of(context).unfocus();

    // send to firebase
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': inputMessage,
        'createdAt': Timestamp.now(),
        'userId': currentUser.uid,
        'userName': userData.data()!['username'],
        'userImage': userData.data()!['imageURL'],
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              autocorrect: true,
              decoration: const InputDecoration(labelText: 'Send message...'),
              controller: _textController,
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submit,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
