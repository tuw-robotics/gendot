#!/usr/bin/env python

## ROS message source code generation for Graphviz
##
## Converts ROS .msg files in a package into dot files .

import sys
import os
import genmsg.template_tools

msg_template_map = { 'msg.dot.template':'@NAME@.dot' }
srv_template_map = { 'srv.dot.template':'@NAME@.dot' }

if __name__ == "__main__":
    genmsg.template_tools.generate_from_command_line_options(sys.argv,
                                                             msg_template_map,
                                                             srv_template_map)

