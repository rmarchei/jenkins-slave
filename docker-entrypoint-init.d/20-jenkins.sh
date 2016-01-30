#!/bin/bash

echo "Setting $JENKINS_HOME permissions"
chown jenkins. "$JENKINS_HOME"
