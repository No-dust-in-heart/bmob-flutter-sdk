import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_plugin/utils/file_picker.dart';
import 'dart:io';

import 'package:data_plugin/bmob/bmob_file_manager.dart';
import 'package:data_plugin/data_plugin.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import '../bean/blog.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:dio/dio.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => new _FilePageState();
}

class _FilePageState extends State<FilePage> {
  String _fileName;
  String _path;
  String _url;
  BmobFile _bmobFile;
  Map<String, String> _paths;
  String _extension;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
        DataPlugin.toast("所选文件：$_fileName");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('File Picker example app'),
        ),
        body: new Center(
            child: new Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                new Padding(
//                  padding: const EdgeInsets.only(top: 20.0),
//                  child: new DropdownButton(
//                      hint: new Text('LOAD PATH FROM'),
//                      value: _pickingType,
//                      items: <DropdownMenuItem>[
//                        new DropdownMenuItem(
//                          child: new Text('FROM AUDIO'),
//                          value: FileType.AUDIO,
//                        ),
//                        new DropdownMenuItem(
//                          child: new Text('FROM IMAGE'),
//                          value: FileType.IMAGE,
//                        ),
//                        new DropdownMenuItem(
//                          child: new Text('FROM VIDEO'),
//                          value: FileType.VIDEO,
//                        ),
//                        new DropdownMenuItem(
//                          child: new Text('FROM ANY'),
//                          value: FileType.ANY,
//                        ),
//                        new DropdownMenuItem(
//                          child: new Text('CUSTOM FORMAT'),
//                          value: FileType.CUSTOM,
//                        ),
//                      ],
//                      onChanged: (value) => setState(() {
//                            _pickingType = value;
//                            if (_pickingType != FileType.CUSTOM) {
//                              _controller.text = _extension = '';
//                            }
//                          })),
//                ),
//                    ConstrainedBox(
//                      constraints: BoxConstraints.tightFor(width: 100.0),
//                      child: _pickingType == FileType.CUSTOM
//                          ? new TextFormField(
//                        maxLength: 15,
//                        autovalidate: true,
//                        controller: _controller,
//                        decoration:
//                        InputDecoration(labelText: 'File extension'),
//                        keyboardType: TextInputType.text,
//                        textCapitalization: TextCapitalization.none,
//                        validator: (value) {
//                          RegExp reg = new RegExp(r'[^a-zA-Z0-9]');
//                          if (reg.hasMatch(value)) {
//                            _hasValidMime = false;
//                            return 'Invalid format';
//                          }
//                          _hasValidMime = true;
//                        },
//                      )
//                          : new Container(),
//                    ),
//                    new ConstrainedBox(
//                      constraints: BoxConstraints.tightFor(width: 200.0),
//                      child: new SwitchListTile.adaptive(
//                        title: new Text('Pick multiple files',
//                            textAlign: TextAlign.right),
//                        onChanged: (bool value) =>
//                            setState(() => _multiPick = value),
//                        value: _multiPick,
//                      ),
//                    ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: new RaisedButton(
                    onPressed: () => _openFileExplorer(),
                    color: Colors.blue[400],
                    child: new Text(
                      "选择文件",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: new RaisedButton(
                    onPressed: () => _uploadFile(_path),
                    color: Colors.blue[400],
                    child: new Text(
                      "上传文件",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: new RaisedButton(
                    onPressed: () => _addFile(_bmobFile),
                    color: Colors.blue[400],
                    child: new Text(
                      "添加文件到表中",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: new RaisedButton(
                    onPressed: () => _downloadFile(_url,
                        "/storage/emulated/0/Pictures/Screenshots/download-${DateTime.now().toString()}.png"),
                    color: Colors.blue[400],
                    child: new Text(
                      "下载文件",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: new RaisedButton(
                    onPressed: () => _deleteFile(_url),
                    color: Colors.blue[400],
                    child: new Text(
                      "删除文件",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                new Builder(
                  builder: (BuildContext context) => new Container(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: new Scrollbar(
                          child: _path != null || _paths != null
                              ? new ListView.separated(
                                  itemCount: _paths != null && _paths.isNotEmpty
                                      ? _paths.length
                                      : 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final bool isMultiPath =
                                        _paths != null && _paths.isNotEmpty;
                                    final String name = 'File $index: ' +
                                        (isMultiPath
                                            ? _paths.keys.toList()[index]
                                            : _fileName ?? '...');
                                    final path = isMultiPath
                                        ? _paths.values
                                            .toList()[index]
                                            .toString()
                                        : _path;

                                    return new ListTile(
                                      title: new Text(
                                        name,
                                      ),
                                      subtitle: new Text(path),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          new Divider(),
                                )
                              : new Container(),
                        ),
                      ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  //上传文件，上传文件涉及到android的文件访问权限，调用此方法前需要开发者们先适配好应用在各个android版本的权限管理。
  void _uploadFile(String path) {
    if(path==null){
      DataPlugin.toast("请先选择文件");
      return;
    }
    DataPlugin.toast("上传中，请稍候……");
    File file = new File(path);
    BmobFileManager.upload(file, successListener: (BmobFile bmobFile) {
      _bmobFile = bmobFile;
      _url = bmobFile.url;
      print("${bmobFile.cdn}\n${bmobFile.url}\n${bmobFile.filename}");
      DataPlugin.toast(
          "上传成功：${bmobFile.cdn}\n${bmobFile.url}\n${bmobFile.filename}");
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }

  //添加文件到表中
  void _addFile(BmobFile bmobFile) {
    if(bmobFile==null){
      DataPlugin.toast("请先上传文件");
      return;
    }
    Blog blog = Blog();
    blog.pic = bmobFile;
    blog.save(successListener: (BmobSaved bmobSaved) {
      print(bmobSaved.objectId);
      DataPlugin.toast("添加成功："+bmobSaved.objectId);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }

  //下载文件，直接使用dio下载，下载文件涉及到android的文件访问权限，调用此方法前需要开发者们先适配好应用在各个android版本的权限管理。
  void _downloadFile(String url, String path) async {
    if(url==null){
      DataPlugin.toast("请先上传文件");
      return;
    }
    Dio dio = Dio();
    Response<dynamic> response = await dio.download(url, path);
    print(response.toString());
    print(response.data);

    DataPlugin.toast("下载结束");
  }

  //删除文件
  void _deleteFile(String url) {
    if(url==null){
      DataPlugin.toast("请先上传文件");
      return;
    }
    BmobFileManager.delete(url, successListener: (BmobHandled bmobHandled) {
      print(bmobHandled.msg);
      DataPlugin.toast("删除成功："+bmobHandled.msg);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }
}
