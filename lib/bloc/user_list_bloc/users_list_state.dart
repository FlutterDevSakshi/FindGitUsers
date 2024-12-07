part of 'users_list_bloc.dart';

class UsersListState {}

class HomeScreenInitial extends UsersListState {}

class HomeScreenLoading extends UsersListState {}

class HomeScreenLoaded extends UsersListState {
  final List<Items> userList;

  HomeScreenLoaded({
    required this.userList,
  });
}

class HomeScreenError extends UsersListState {
  final String message;
  HomeScreenError({
    required this.message,
  });
}
