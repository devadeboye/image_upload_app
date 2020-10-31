import 'dart:typed_data';

import 'package:gcloud/service_scope.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';

class CloudApi {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient _client;

  CloudApi(String json)
      : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<ObjectInfo> save(String name, Uint8List imgBytes) async {
    // create a client
    if (_client == null) {
      _client = await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    }

    // instantiate object to cloud storage
    var storage = Storage(_client, "Image Upload Google Storage"); // replace with a project name
    var bucket = storage.bucket("my_bucket"); // replace with a bucket name

    // save to bucket
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookup(name);
    return await bucket.writeBytes(name, imgBytes, metadata: ObjectMetadata(
      contentType: type,
      custom: {
        'timestamp': '$timestamp',
      }
    ));
  }
}