
import 'package:assingmet_test/components/error_handler.dart';
import 'package:assingmet_test/screens/detail_screen.dart';
import 'package:assingmet_test/screens/list_screen/list_view_loading.dart';
import 'package:assingmet_test/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; 
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:assingmet_test/screens/list_screen/user_model.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
  setState(() {
    _isLoading = true;
    _isError = false;
  });

  Dio dio = Dio(); // Dio instance

  try {
    final response = await dio.get('https://jsonplaceholder.typicode.com/users');

    if (response.statusCode == 200) {
      final List<dynamic> userData = response.data;
      setState(() {
        _users = userData.map((data) => User.fromJson(data)).toList();
        _filteredUsers = _users;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  } catch (error) {
    setState(() {
      _isLoading = false;
      _isError = true;
    });
    ErrorHandler.showError(context, 'Failed to load users');
  }
}

// Using for fuzzy search
  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _users.where((user) {
        final userNameLower = user.name.toLowerCase();
        final searchLower = query.toLowerCase();
        return userNameLower.contains(searchLower);
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(color: AppPallete.whiteColor,fontSize: 23), // Set app bar title color
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppPallete.backgroundColor),
              decoration: InputDecoration(
                hintText: 'Search by name',
                hintStyle: const TextStyle(color: AppPallete.backgroundColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppPallete.whiteColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (value) {
                _filterUsers(value);
              },
            ),
          ),
        ),
      ),
     
          body: _isLoading
    ? ShimmerLoading()//using shimmer loading 
    : _isError
        ? ErrorHandler.buildErrorState(
            context: context,
            message: 'Failed to load users',
            onRetry: _fetchUsers,
          )
              : SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () async {
                    await _fetchUsers();
                    _refreshController.refreshCompleted();
                  },
                  child: ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Dismissible(
                        key: Key(user.id.toString()),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: AppPallete.errorColor,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            _users.removeWhere((u) => u.id == user.id);
                            _filteredUsers.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${user.name} removed'),
                          ));
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserDetailsScreen(user: user),
                            ));
                          },
                          child: Card(
  color: AppPallete.greyColor, 
  child: ListTile(
    leading: const Icon(Icons.person, color: AppPallete.whiteColor), 
    title: Text(
      user.name,
      style: const TextStyle(color: AppPallete.whiteColor), 
    ),
    subtitle: Row(
      children: [
        const Icon(Icons.email, color: AppPallete.backgroundColor), 
        const SizedBox(width: 8), 
        Text(
          user.email,
          style: const TextStyle(color: AppPallete.backgroundColor), 
        ),
      ],
    ),
  ),
)

                        ),
                      );
                    },
                  ),
                ),
    );
  }

}
