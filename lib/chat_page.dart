import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';  // Import the LoginPage to navigate back to the login screen.

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isSendButtonEnabled = false;

  List<Map<String, String>> _messages = [
    {'sender': 'bot', 'time': '02:10 PM', 'message': 'Hello Nice\nWelcome to LiveChat.\nI was made with COMPLIT.'},
    {'sender': 'user', 'time': '02:12 PM', 'message': 'Welcome'}
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onMessageChanged() {
    setState(() {
      _isSendButtonEnabled = _messageController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    super.dispose();
  }

  // Show a logout dialog or action when tapped
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                 // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action here
                try {
                  FirebaseAuth.instance.signOut();  // Sign out from Firebase

                  // Show the SnackBar before navigating
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged out successfully')),
                  );

                  // Delay the navigation to the login page after SnackBar is shown
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout failed: $e')),
                  );
                }
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out successfully')),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );


              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text('Chatbot ALISHA', style: TextStyle(fontSize: 16, color: Colors.black)),
        backgroundColor: Color(0xFFF5F6FA),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.thumb_up),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.thumb_down),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(); // Show logout dialog
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
            icon: Icon(Icons.more_vert), // The 3-dot menu icon
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                bool isBot = message['sender'] == 'bot';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Align(
                    alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                    child: IntrinsicWidth(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isBot ? Colors.white : Color(0xFF006EFF),
                          border: isBot ? Border.all(color: Color(0xFFE0E0E0)) : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: isBot
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Text(
                                  isBot ? 'LiveChat' : 'Me',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                                ),
                                SizedBox(width: 15),
                                Text(
                                  message['time']!,
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              message['message']!,
                              style: TextStyle(fontSize: 14, color: isBot ? Colors.black : Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Write a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isSendButtonEnabled
                      ? () {
                    setState(() {
                      _messages.add({
                        'sender': 'user',
                        'time': 'Visitor ${TimeOfDay.now().format(context)}',
                        'message': _messageController.text,
                      });
                    });
                    _messageController.clear();
                    _scrollToBottom();
                  }
                      : null,
                  color: _isSendButtonEnabled ? Color(0xFF006EFF) : Colors.grey,
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFFF9F9F9),
        padding: EdgeInsets.all(5),
        child: Text(
          'Powered by COMPLIT',
          style: TextStyle(fontSize: 12, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
