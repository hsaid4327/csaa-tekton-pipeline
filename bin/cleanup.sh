#!/bin/bash


oc delete pods --field-selector=status.phase=Succeeded
oc delete pods --field-selector=status.phase=Failed
