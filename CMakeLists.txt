cmake_minimum_required(VERSION 2.8.3)
project(gendot)
find_package(catkin REQUIRED COMPONENTS genmsg)

catkin_package(
  CATKIN_DEPENDS genmsg
  CFG_EXTRAS gendot-extras.cmake
)

add_subdirectory(scripts)

file(WRITE ${CATKIN_DEVEL_PREFIX}/${GENMSG_LANGS_DESTINATION}/gendot "dot")
install(FILES ${CATKIN_DEVEL_PREFIX}/${GENMSG_LANGS_DESTINATION}/gendot
  DESTINATION ${GENMSG_LANGS_DESTINATION})

catkin_python_setup()
