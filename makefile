SHELL := bash
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.RECIPEPREFIX +=

.PHONY: all build

DIR := $(shell basename "$(shell pwd)")
NAME = mkcmd
DOCKERFILE = ./Dockerfile

ifndef SSH_PRIVATE_KEY
  override SSH_PRIVATE_KEY=${HOME}/.ssh/id_ed25519
endif

ifndef SSH_PUBLIC_KEY
  override SSH_PUBLIC_KEY=${HOME}/.ssh/id_ed25519.pub
endif

all: build
  echo all

build:
  docker build -f $(DOCKERFILE) -t $(NAME) .
