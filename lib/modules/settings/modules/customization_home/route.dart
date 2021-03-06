import 'package:fluro_fork/fluro_fork.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsCustomizationHomeRouter {
    static const ROUTE_NAME = '/settings/customization/home';

    static Future<void> navigateTo(BuildContext context) async => LunaRouter.router.navigateTo(
        context,
        route(),
    );

    static String route() => ROUTE_NAME;
    
    static void defineRoutes(Router router) => router.define(
        ROUTE_NAME,
        handler: Handler(handlerFunc: (context, params) => _SettingsCustomizationHomeRoute()),
        transitionType: LunaRouter.transitionType,
    );

    SettingsCustomizationHomeRouter._();
}

class _SettingsCustomizationHomeRoute extends StatefulWidget {
    @override
    State<_SettingsCustomizationHomeRoute> createState() => _State();
}

class _State extends State<_SettingsCustomizationHomeRoute> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    @override
    Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: _appBar,
        body: _body,
    );

    Widget get _appBar => LunaAppBar(
        context: context,
        popUntil: '/settings',
        title: 'Home',
    );

    Widget get _body => LSListView(
        children: [
            ..._defaultPages,
            ..._modules,
        ],
    );

    List<Widget> get _defaultPages => [
        LSHeader(
            text: 'Default Pages',
            subtitle: 'Choose the default page when opening routes with navigation bars',
        ),
        SettingsCustomizationHomeDefaultPageTile(),
    ];

    List<Widget> get _modules => [
        LSHeader(
            text: 'Modules',
            subtitle: 'Customizable options related to the module list',
        ),
        SettingsCustomizationHomeBrandColoursTile(),
    ];
}
