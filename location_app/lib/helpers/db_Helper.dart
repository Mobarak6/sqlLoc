import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> database() async {
    final dataBasepath = await getDatabasesPath();
    return openDatabase(
      join(dataBasepath, 'placeHolders.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, image TEXT)');
      },
    );
  }

  static Future<void> insert(String tableName, Map<String, Object> data) async {
    final getDatabase = await DatabaseHelper.database();
    getDatabase.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fatchData(String tableName) async {
    final getDatabase = await DatabaseHelper.database();

    return getDatabase.query(tableName);
  }
}
