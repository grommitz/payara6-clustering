#!/bin/bash
ps -aef | grep payara6-clustering | awk '{print $2}' | xargs kill -9
