import 'package:bloc/bloc.dart';

import '../../data/model/item_model.dart';

import 'package:equatable/equatable.dart';

import '../../domain/repository/item_repository.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository repository;

  ItemBloc(this.repository) : super(ItemInitial()) {
    on<FetchItemsEvent>((event, emit) async {
      try {
        final items = await repository.getItems();
        if (event is FetchItemsEvent) {
          print('Items fetched: $items'); // Debugging output
        }
        emit(ItemsLoadedState(items));
      } catch (e) {
        emit(ItemErrorState(e.toString()));
      }
    });

    on<AddItemEvent>((event, emit) async {
      await repository.addItem(event.item);
      add(FetchItemsEvent());
    });

    on<UpdateItemEvent>((event, emit) async {
      await repository.updateItem(event.item);
      add(FetchItemsEvent());
    });

    on<DeleteItemEvent>((event, emit) async {
      await repository.deleteItem(event.id);
      add(FetchItemsEvent());
    });

    on<FilterItemsEvent>((event, emit) async {
      try {
        final items = await repository.getItems();
        if (event.filter == ItemFilter.all) {
          emit(ItemsLoadedState(items));
        } else if (event.filter == ItemFilter.pending) {
          emit(ItemsLoadedState(items.where((item) => !item.completed).toList()));
        } else if (event.filter == ItemFilter.completed) {
          emit(ItemsLoadedState(items.where((item) => item.completed).toList()));
        }
      } catch (e) {
        emit(ItemErrorState(e.toString()));
      }
    });
  }
}

