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

import 'package:cryptography/cryptography.dart';
import 'package:test/test.dart';

void main() {
  group('ecdhP256:', () {
    test('key exchange', () async {
      await _testKeyExchange(ecdhP256);
    });
  }, testOn: 'chrome');

  group('ecdhP384:', () {
    test('key exchange', () async {
      await _testKeyExchange(ecdhP384);
    });
  }, testOn: 'chrome');

  group('ecdhP521:', () {
    test('key exchange', () async {
      await _testKeyExchange(ecdhP521);
    });
  }, testOn: 'chrome');

  group('ecdsaP256Sha256:', () {
    test('signature', () async {
      await _testSignature(ecdsaP256Sha256);
    });
  }, testOn: 'chrome');

  group('ecdsaP384Sha256:', () {
    test('signature', () async {
      await _testSignature(ecdsaP384Sha256);
    });
  }, testOn: 'chrome');

  group('ecdsaP521Sha256:', () {
    test('signature', () async {
      await _testSignature(ecdsaP521Sha256);
    });
  }, testOn: 'chrome');
}

Future<void> _testKeyExchange(KeyExchangeAlgorithm algorithm) async {
  final keypair0 = await algorithm.keyPairGenerator.generate();
  final keypair1 = await algorithm.keyPairGenerator.generate();
  expect(
    keypair0.privateKey,
    isNot(keypair1.privateKey),
  );
  expect(
    keypair0.publicKey,
    isNot(keypair1.publicKey),
  );
  final sharedKey0 = await algorithm.sharedSecret(
    localPrivateKey: keypair0.privateKey,
    remotePublicKey: keypair1.publicKey,
  );
  final sharedKey1 = await algorithm.sharedSecret(
    localPrivateKey: keypair1.privateKey,
    remotePublicKey: keypair0.publicKey,
  );
  expect(
    sharedKey0,
    sharedKey1,
  );
}

Future<void> _testSignature(SignatureAlgorithm algorithm) async {
  final keypair = await algorithm.keyPairGenerator.generate();
  final otherKeyPair = await algorithm.keyPairGenerator.generate();
  expect(
    keypair.privateKey,
    isNot(otherKeyPair.privateKey),
  );
  expect(
    keypair.publicKey,
    isNot(otherKeyPair.publicKey),
  );
  final input = const <int>[9, 8, 9];
  final signature = await algorithm.sign(
    input,
    keypair,
  );
  expect(
    await algorithm.verify(input, signature),
    isTrue,
  );
  expect(
    await algorithm.verify(const [], signature),
    isFalse,
  );
  expect(
    await algorithm.verify(
      input,
      Signature(signature.bytes, publicKey: otherKeyPair.publicKey),
    ),
    isFalse,
  );
}
