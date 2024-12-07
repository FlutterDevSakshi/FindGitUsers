import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_git_users/models/users.dart';
import 'package:find_git_users/repository/post_repository.dart';
import 'package:flutter/material.dart';

part 'users_list_event.dart';
part 'users_list_state.dart';

class UsersListBloc extends Bloc<UsersListEvent, UsersListState> {
  UsersListBloc() : super(HomeScreenInitial()) {
    on<SearchUsers>((event, emit) async {
      if (event.searchQuery.isNotEmpty) {
        try {
                emit(HomeScreenLoading());
                User? data =
                    await PostRepository().searchUsers(searchQuery: event.searchQuery);
                if (data != null && data.items != null && data.items!.isNotEmpty) {
                  emit(HomeScreenLoaded(userList: data.items ?? []));
                } else {
                  emit(HomeScreenError(message: "No data found"));
                }
              } catch (e) {
                //print(e);
                emit(HomeScreenError(message: "Something Went Wrong..."));
              }
      }
    });
  }
}
