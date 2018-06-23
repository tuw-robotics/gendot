@[if DEVELSPACE]@
# bin and template dir variables in develspace
set(GENDOT_BIN "@(CMAKE_CURRENT_SOURCE_DIR)/scripts/gen_dot.py")
set(GENDOT_TEMPLATE_DIR "@(CMAKE_CURRENT_SOURCE_DIR)/scripts")
@[else]@
# bin and template dir variables in installspace
set(GENDOT_BIN "${gendot_DIR}/../../../@(CATKIN_PACKAGE_BIN_DESTINATION)/gen_dot.py")
set(GENDOT_TEMPLATE_DIR "${gendot_DIR}/..")
@[end if]@

# Generate .msg->.dot for dot
# The generated .dot files should be added ALL_GEN_OUTPUT_FILES_dot
macro(_generate_msg_dot ARG_PKG ARG_MSG ARG_IFLAGS ARG_MSG_DEPS ARG_GEN_OUTPUT_DIR)
  file(MAKE_DIRECTORY ${ARG_GEN_OUTPUT_DIR})

  #Create input and output filenames
  get_filename_component(MSG_NAME ${ARG_MSG} NAME)
  get_filename_component(MSG_SHORT_NAME ${ARG_MSG} NAME_WE)

  set(MSG_GENERATED_NAME ${MSG_SHORT_NAME}.dot)
  set(GEN_OUTPUT_FILE ${ARG_GEN_OUTPUT_DIR}/${MSG_GENERATED_NAME})

  # check if a user-provided header file exists
  if(EXISTS "${PROJECT_SOURCE_DIR}/include/${ARG_PKG}/${MSG_SHORT_NAME}.dot")
    message(STATUS "${ARG_PKG}: Found user-provided header '${PROJECT_SOURCE_DIR}/include/${ARG_PKG}/${MSG_SHORT_NAME}.dot' for message '${ARG_PKG}/${MSG_SHORT_NAME}'. Skipping generation...")
    # Do nothing. The header will be installed by the user.
  else()
    # check if a user-provided plugin header file exists
    if(EXISTS "${PROJECT_SOURCE_DIR}/include/${ARG_PKG}/plugin/${MSG_SHORT_NAME}.dot")
      message(STATUS "${ARG_PKG}: Found user-provided plugin header '${PROJECT_SOURCE_DIR}/include/${ARG_PKG}/plugin/${MSG_SHORT_NAME}.dot' for message '${ARG_PKG}/${MSG_SHORT_NAME}'.")
      # Add a file dependency to enforce regeneration if the plugin header was added after initial cmake invocation.
      # Even with --force-cmake the generator would otherwise not run if the .msg file did not change.
      set(MSG_PLUGIN "${PROJECT_SOURCE_DIR}/include/${ARG_PKG}/plugin/${MSG_SHORT_NAME}.dot")
    else()
      set(MSG_PLUGIN)
    endif()

    assert(CATKIN_ENV)
    add_custom_command(OUTPUT ${GEN_OUTPUT_FILE}
      DEPENDS ${GENDOT_BIN} ${ARG_MSG} ${ARG_MSG_DEPS} ${MSG_PLUGIN} "${GENDOT_TEMPLATE_DIR}/msg.dot.template" ${ARGN}
      COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENDOT_BIN} ${ARG_MSG}
      ${ARG_IFLAGS}
      -p ${ARG_PKG}
      -o ${ARG_GEN_OUTPUT_DIR}
      -e ${GENDOT_TEMPLATE_DIR}
      COMMENT "Generating Dot code from ${ARG_PKG}/${MSG_NAME}"
      WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
      )
    list(APPEND ALL_GEN_OUTPUT_FILES_dot ${GEN_OUTPUT_FILE})
  endif()

  gendot_append_include_dirs()
endmacro()

#gendot uses the same program to generate srv and msg files, so call the same macro
macro(_generate_srv_dot ARG_PKG ARG_SRV ARG_IFLAGS ARG_MSG_DEPS ARG_GEN_OUTPUT_DIR)
  _generate_msg_dot(${ARG_PKG} ${ARG_SRV} "${ARG_IFLAGS}" "${ARG_MSG_DEPS}" ${ARG_GEN_OUTPUT_DIR} "${GENDOT_TEMPLATE_DIR}/srv.dot.template")
endmacro()

macro(_generate_module_dot)
  # the macros, they do nothing
endmacro()

set(gendot_INSTALL_DIR graphviz)

macro(gendot_append_include_dirs)
  if(NOT gendot_APPENDED_INCLUDE_DIRS)
    # make sure we can find generated messages and that they overlay all other includes
    include_directories(BEFORE ${CATKIN_DEVEL_PREFIX}/${gendot_INSTALL_DIR})
    # pass the include directory to catkin_package()
    list(APPEND ${PROJECT_NAME}_INCLUDE_DIRS ${CATKIN_DEVEL_PREFIX}/${gendot_INSTALL_DIR})
    set(gendot_APPENDED_INCLUDE_DIRS TRUE)
  endif()
endmacro()
