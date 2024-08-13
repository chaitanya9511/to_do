import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_list/data/data_sources/item_datasource.dart';
import 'package:to_do_list/data/model/item_model.dart';
import 'package:to_do_list/domain/repository/item_repository.dart';
import 'package:to_do_list/presentation/blocks/item_bloc.dart';

class MockItemDataSource extends Mock implements ItemDataSource {}

void main() {
  late ItemBloc itemBloc;
  late ItemRepository itemRepository;
  late MockItemDataSource mockItemDataSource;

  setUp(() {
    mockItemDataSource = MockItemDataSource();
    itemRepository = ItemRepository(mockItemDataSource);
    itemBloc = ItemBloc(itemRepository);
  });

  tearDown(() {
    itemBloc.close();
  });




  final  itemModel = ItemModel(id: 0, name: 'raai', completed: false);
  final updatedItemModel = ItemModel(id: 0, name: 'updated1', completed: true);
  


  test('FetchItemsEvent should return a list of items', ()  async* {

    itemBloc.add(FetchItemsEvent());

   await  expectLater(
      itemBloc.stream,
      emitsInOrder([
        isA<ItemsLoadedState>().having((state) => state.items, 'items', itemModel),
      ]),
    );

  });
  test('UpdateItemEvent should return a modified list of items', ()  async* {
    itemBloc.add(UpdateItemEvent(updatedItemModel));
    await expectLater(
      itemBloc.stream,
      emitsInOrder([
        isA<ItemsLoadedState>().having((state) => state.items, 'items', updatedItemModel),
      ]),
    );
  });

  test('DeleteItemEvent should return a empty list', ()  async* {
    itemBloc.add(DeleteItemEvent(itemModel.id!.toInt()));
    await expectLater(
      itemBloc.stream,
      emitsInOrder([
        isA<ItemsLoadedState>().having((state) => state.items, 'items', []),
      ]),
    );

  });

}
