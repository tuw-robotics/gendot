install(
  FILES msg.dot.template srv.dot.template
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})

catkin_install_python(
  PROGRAMS gen_dot.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})
