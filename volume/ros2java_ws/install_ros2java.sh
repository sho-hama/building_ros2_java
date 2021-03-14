set -eu
vcs import src < ros2_java_desktop.repos
sed -ie 's/client\.waitForService()/true/' ./src/ros2_java/ros2_java_examples/rcljava_examples/src/main/java/org/ros2/rcljava/examples/client/AddTwoIntsClient.java
ament build --symlink-install --isolated --skip-packages test_msgs && . ./install_isolated/local_setup.sh 
