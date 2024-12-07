part of 'users_list_bloc.dart';

abstract class UsersListEvent extends Equatable{}

@immutable
class SearchUsers extends UsersListEvent{
  final String searchQuery;
  SearchUsers({required this.searchQuery});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

