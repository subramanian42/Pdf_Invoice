import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:testproject/model/Weight.dart';

class WeightDatabase {
  static final WeightDatabase instance = WeightDatabase._init();

  static Database? _database;

  WeightDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('weights.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final databasepath = await getDatabasesPath();
    final gpath = join(databasepath, filepath);

    return await openDatabase(gpath, version: 1, onCreate: _createdatabase);
  }

  Future _createdatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableWeights (
      ${WeightFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${WeightFields.value} DOUBLE
    )
    ''');
  }

  Future<Weight> create(Weight weight) async {
    final db = await instance.database;
    final id = await db.insert(tableWeights, weight.toJson());
    return weight.copy(id: id);
  }

  Future<List<Weight>> readallWeights() async {
    final db = await instance.database;

    final result = await db.query(tableWeights);

    return result.map((json) => Weight.fromJson(json)).toList();
  }

  Future<List> calculateTotal() async {
    final db = await instance.database;
    final sum = await db.rawQuery(
        "SELECT SUM( ${WeightFields.value} ) as Total FROM $tableWeights ");
    return sum.toList();
  }

  void close() async {
    final db = await instance.database;
    db.close();
  }
}
