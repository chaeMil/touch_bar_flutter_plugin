// Copyright (c) 2020 Eduardo Vital Alencar Cunha
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

/// The base type touch bar item that can be shown in a touch bar.
abstract class AbstractTouchBarItem {
  /// Constructor
  ///
  /// [methods] should be nil only if the TouchBarItem has no methods
  /// that will be called in the native platform.
  ///
  /// All the concrete implementation of this that contains actioons that
  /// will be called in the native platform must be implemented following the
  /// example below:
  /// ```dart
  /// class ConcreteTouchBarItem extends AbstractTouchBarItem {
  ///   // [onAction] and [onAnotherAction] store just the hash code of the
  ///   // implementation.
  ///   final String onAction();
  ///   final String onAnotherAction();
  ///
  ///   // [methods] will be used as single source of truth to the
  ///   // implementation and [onAction] and [onAnotherAction] will be
  ///   // used in the [toMap()].
  ///   ConcreteTouchBarItem(Function onAction) :
  ///     this.onAction = onAction.hashCode.toString(),
  ///     this.onAnotherAction = onAction.hashCode.toString(),
  ///     super(methods: {
  ///       '${onAction.hashCode}': onAction,
  ///       '${onAnotherAction.hashCode}': onAnotherAction,
  ///     });
  /// }
  /// ```
  const AbstractTouchBarItem({this.methods = const {}});

  /// Searches the method named [name] in this and execute it.
  ///
  /// It returns true if a method of the given [name] was found and executed.
  ///
  /// The [name] has the value of [Function.hashCode].
  /// It is not a humand readable name nor the name of the property that it
  /// holds.
  ///
  /// **This method should not be called manually.**
  bool callMethod(String name) {
    for (String functionName in methods.keys) {
      if (functionName == name) {
        methods[name]();
        return true;
      }
    }

    return false;
  }

  /// Convert all the TouchBarItem data to a Map that will be used
  /// in the platform channel communication.
  Map<String, dynamic> toMap();

  /// Name of the concrete implementation of the AbstractTouchBarItem
  /// that will be used to inform the specific platform implementation
  /// which TouchBarItem must be rendered.
  /// This is important because the platform channel communication
  /// is performed through subset of the primitive types.
  /// See https://flutter.dev/docs/development/platform-integration/platform-channels#codec.
  String get type;

  /// Stores all the methods of this.
  ///
  /// The [Map.keys] stores the hash code of the methods
  /// and [Map.values] stores the method implementation.
  ///
  /// **This should not be included in the [toMap] implementation.**
  final Map<String, Function> methods;
}

/// The base type for touch bar items that do not contain others touchbars.
///
/// Note: the [children] property is forbidden in [this]
/// Use [TouchBarWrapper] to be able to use the [children] property.
abstract class TouchBarItem extends AbstractTouchBarItem {
  /// The [children] property is forbbiden in [this].
  final List<TouchBarItem> children = null;

  TouchBarItem({Map<String, Function> methods}) : super(methods: methods);
}

/// The base type for touch bar items that contain others touchbar items
abstract class TouchBarWrapper extends AbstractTouchBarItem {
  const TouchBarWrapper({this.children = const []});

  /// The subitems of [this].
  final List<TouchBarItem> children;
}
