// Copyright 2015 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@TestOn('browser')
library w_flux.test.batched_redraws_test;

import 'dart:async';
import 'dart:html';

import 'package:react/react.dart' as react;

import 'package:w_flux/w_flux.dart';
import 'package:test/test.dart';

class _TestComponent extends react.Component with BatchedRedraws {
  int renderCount = 0;

  dynamic render() => '';

  void setState(_) {
    renderCount++;
  }
}

void main() {
  Future nextTick() async {
    await window.animationFrame;
    await window.animationFrame;
  }

  group('ScheduledRedraws', () {
    _TestComponent component;

    setUp(() {
      component = new _TestComponent();
    });

    test('should redraw the component when redraw() is called', () async {
      component.redraw();
      await nextTick();
      expect(component.renderCount, equals(1));
    });

    test('should not redraw the component more than once per animation frame',
        () async {
      component.redraw();
      component.redraw();
      await nextTick();
      expect(component.renderCount, equals(1));
    });
  });
}
