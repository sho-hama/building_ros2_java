# ROS2Javaのビルド環境構築のためのリポジトリ
ビルド手順は[ここ]()を参照してください。

- test_msgsだけビルドできなかったので一旦スキップ
- 例題サンプルコードのコンパイルエラーをとりあえず解消するコマンド
  - client.waitForService()がないよと怒られる
  - sed -ie 's/client\.waitForService()/true/' ./src/ros2_java/ros2_java_examples/rcljava_examples/src/main/java/org/ros2/rcljava/examples/client/AddTwoIntsClient.java
  - ソースコードの修正は後で検討
 
