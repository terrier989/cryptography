// Copyright 2019 Gohilla Ltd (https://gohilla.com).
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:cryptography/utils.dart';

/// A secret sequence of bytes.
///
/// ```
/// // Generates a random 256-bit key.
/// final secretKey = SecretKey.randomBytes(32);
/// ```
class SecretKey {
  static final _random = Random.secure();

  /// Bytes of the key. May be null.
  final List<int> bytes;

  /// Constructs a secret key on the heap.
  SecretKey(this.bytes) {
    ArgumentError.checkNotNull(bytes, 'bytes');
  }

  /// Generates N random bytes.
  ///
  /// You can optionally give a random number generator that's used.
  factory SecretKey.randomBytes(int length, {Random random}) {
    random ??= _random;
    final data = Uint8List(length);
    for (var i = 0; i < data.length; i++) {
      data[i] = random.nextInt(256);
    }
    return SecretKey(data);
  }

  @override
  int get hashCode {
    /// Exposes maximum 16 bits of the key.
    var h = 0;
    final bytes = this.bytes;
    for (var i = 0; i < bytes.length; i++) {
      final b = bytes[i];
      h ^= (b << (i % 16)) ^ (b >> (16 - (i % 16)));
    }
    return h;
  }

  @override
  bool operator ==(other) {
    return other is SecretKey &&
        const ConstantTimeBytesEquality().equals(bytes, other.bytes);
  }

  @override
  String toString() => 'SecretKey(...)';
}
