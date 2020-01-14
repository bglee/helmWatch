#!/bin/bash
KUBECONFIG=~/.dev-kube1/config
watch -c -n 2 ./helmColors.sh $KUBECONFIG  
