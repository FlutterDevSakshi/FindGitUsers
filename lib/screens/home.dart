import 'package:find_git_users/bloc/user_list_bloc/users_list_bloc.dart';
import 'package:find_git_users/models/users.dart';
import 'package:find_git_users/repository/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Items> userList = [];

  @override
  Widget build(BuildContext context) {
    UsersListBloc userListBloc = BlocProvider.of<UsersListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFe52165).withOpacity(0.8),
        title: const Text(
          'Find GitHub Users',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 45,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                cursorHeight: 10,
                style: const TextStyle(fontSize: 14),
                controller: searchController,
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    userListBloc.add(SearchUsers(searchQuery: value));
                  }
                },
                decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: "Search by username",
                    hintStyle: const TextStyle(fontSize: 14),
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const VerticalDivider(
                          indent: 2,
                          endIndent: 2,
                        ),
                        InkWell(
                          onTap: () {
                            searchController.clear();
                            setState(() {
                              userList.clear();
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.cancel),
                          ),
                        )
                      ],
                    ),
                    isDense: true,
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<UsersListBloc, UsersListState>(
                builder: (context, state) {
                  if (state is HomeScreenInitial) {
                    return const Center(
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  } else if (state is HomeScreenLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HomeScreenLoaded) {
                    userList = state.userList;
                    return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          String userName = state.userList[index].login ?? '';
                          String userProfileImg =
                              state.userList[index].avatarUrl ?? '';
                          return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                        radius: 30,
                                        child: ClipOval(
                                          child: Image.network(
                                            userProfileImg,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          userName,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        FutureBuilder(
                                            future: PostRepository()
                                                .fetchUserData(
                                                    searchQuery: userName),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                 return Text(snapshot.data.toString());
                                              }
                                              return const Text("");
                                            })
                                      ],
                                    ),
                                  ))
                                ],
                              ));
                        });
                  } else if (state is HomeScreenError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
