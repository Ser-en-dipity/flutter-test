// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;
import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart';

typedef SumFunc = ffi.Int32 Function(ffi.Int32 a, ffi.Int32 b);
typedef Sum = int Function(int a, int b);

final class Coordinate extends ffi.Struct {
  external ffi.Pointer<Utf8> name;

  @ffi.Double()
  external double latitude;

  @ffi.Double()
  external double longitude;
}

typedef CoordinateNative = Coordinate Function(
    ffi.Pointer<Utf8> name, ffi.Double x, ffi.Double y);
typedef CoordinateFunc = Coordinate Function(
    ffi.Pointer<Utf8> name, double x, double y);
void main() {
  var libraryPath = path.join(Directory.current.path, 'ethercat', 'soem.dll');

  final dylib = ffi.DynamicLibrary.open(libraryPath);

  final StructPointer = dylib
      .lookupFunction<CoordinateNative, CoordinateFunc>('CreateCoordinate');
  var name = 'test';
  final nameCon = name.toNativeUtf8();
  final coord = StructPointer(nameCon, 3.5, 4.6);
  final n = nameCon.toDartString();
  print(
    "final res is ${nameCon} at ${coord.latitude}, ${coord.longitude}",
  );
}
