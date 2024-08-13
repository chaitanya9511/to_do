part of 'item_bloc.dart';



abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemInitial extends ItemState {}

class ItemsLoadedState extends ItemState {
  final List<ItemModel> items;

  const ItemsLoadedState(this.items);

  @override
  List<Object> get props => [items];
}

class ItemErrorState extends ItemState {
  final String errorMessage;

  const ItemErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

