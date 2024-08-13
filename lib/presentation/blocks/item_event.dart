part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class AddItemEvent extends ItemEvent {
  final ItemModel item;

  const AddItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

class FetchItemsEvent extends ItemEvent {


}

class UpdateItemEvent extends ItemEvent {
  final ItemModel item;

  const UpdateItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

class DeleteItemEvent extends ItemEvent {
  final int id;

  const DeleteItemEvent(this.id);

  @override
  List<Object> get props => [id];
}

enum ItemFilter { all, pending, completed }

class FilterItemsEvent extends ItemEvent {
  final ItemFilter filter;

  const FilterItemsEvent(this.filter);

  @override
  List<Object> get props => [filter];
}