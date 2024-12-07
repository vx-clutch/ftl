#include "config.h"
#include "error.h"
#include "parse_args.h"
#include <string.h>
#include <getopt.h>
#include <stdio.h>
#include <getopt.h>
#include <stdlib.h>

void print_help() {
  printf("Usage: ftl [options] file...\n\n");
  printf("Options:\n");
  printf("  --help\tPrints out the help and exit.\n");
  printf("  --version\tPrints out the version number and exit.\n");
  printf("  -o <file>\tPlace the output into <file>.\n");
  printf("  -S\t\tCompile only; do not assembly or link.\n");
  printf("  -c\t\tComppile and assemble, but do not link.\n");
}

#ifndef COMPILER_VERSION
#define COMPILER_VERSION "unknown"
#endif
#ifndef COMPILER_YEAR
#define COMPILER_YEAR "unknown"
#endif
#ifndef COMPILER_PLATFORM
#define COMPILER_PLATFORM "unknown unix system"
#endif

void print_version() {
  printf("ftl (FTL) %s %s (%s)\nCopyright (C) %s vx-clutch\nThis is free software; see the source for copying conditions. There is NO\nwarranty; not even for MERCHANTABLITY or FITNESS FOR A PARTICULAR PURPOSE\n", COMPILER_VERSION, COMPILER_YEAR, COMPILER_PLATFORM, COMPILER_YEAR);
}

Options parse_args(int argc, char **argv) {
  int c;
  int option_index = 0;
  Options options;
  options.E = false;
  options.c = false;
  options.S = false;
  options.o = NULL;
  options.F =  NULL;
  struct option long_options[] = {
    {"version", no_argument, 0, 'v'},
    {"help", no_argument, 0, 'h'},
    {0, 0, 0, 0}
  };
  while ((c = getopt_long(argc, argv, "Sco:hv", long_options, &option_index)) != -1) {
    switch (c) {
      case 'S':
        options.S = true;
        break;
      case 'c':
        options.c = true;
        break;
      case 'o':
        options.o = optarg;
        break;
      case 'E':
        options.E = true;
        break;
      case 'h':
        print_help();
        exit(EXIT_SUCCESS);
      case 'v':
        print_version();
        exit(EXIT_SUCCESS);
      case '?':
        exit(EXIT_FAILURE);
      default:
        abort();
    }
  }
  if (optind >= argc) {
    fatal_error("no input files.");
  }
  for (int i = optind; i < argc; i++) {
    const char *filename = argv[i];
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
      fatal_error("error opening file");
    }
    options.F = file;
  }
  return options;
}
