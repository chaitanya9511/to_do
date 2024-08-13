

import '../../data/data_sources/item_datasource.dart';
import '../../data/model/item_model.dart';

class ItemRepository {
  final ItemDataSource dataSource;

  ItemRepository(this.dataSource);

  Future<void> addItem(ItemModel item) => dataSource.insertItem(item);

  Future<List<ItemModel>> getItems() async => dataSource.getItems();

  Future<void> updateItem(ItemModel item) => dataSource.updateItem(item);

  Future<void> deleteItem(int id) => dataSource.deleteItem(id);
}
