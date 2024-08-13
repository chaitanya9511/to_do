import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/item_model.dart';


class ItemDataSource {
  static final ItemDataSource _instance = ItemDataSource._internal();
  Database? _database;

  factory ItemDataSource() => _instance;

  ItemDataSource._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'item_database.db');
    return await openDatabase(
      path,
      version: 2, // Updated version
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, completed INTEGER)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE items ADD COLUMN completed INTEGER DEFAULT 0');
        }
      },
    );
  }

  Future<void> insertItem(ItemModel item) async {
    final db = await database;
    await db.insert('items', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ItemModel>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return ItemModel(
        id: maps[i]['id'] as int?,
        name: maps[i]['name'] as String,
        completed: maps[i]['completed'] == 1, // Convert from int to bool
      );
    });
  }

  Future<void> updateItem(ItemModel item) async {
    final db = await database;
    await db.update(
      'items',
      item.toJson(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}
