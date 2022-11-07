import 'package:realm_dart/realm.dart';
import 'package:test/expect.dart';

part 'backlinks_test.g.dart';

// :snippet-start: backlink-models
@RealmModel()
class _User {
  @PrimaryKey()
  late int id;

  late String username;
  // One-to-many relationship that the backlink is created for below.
  late List<_Task> tasks;
}

@RealmModel()
class _Task {
  @PrimaryKey()
  late int id;

  late String description;
  late bool isComplete;

  // Backlink field. Links back to the `tasks` property in the `_User` model.
  @Backlink(#tasks)
  late Iterable<_User> linkedUser;
}
// :snippet-end:
