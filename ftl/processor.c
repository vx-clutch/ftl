#include "config.h"
#include "processor.h"

char *remove_comments(char source[MAXINPUTBUFFER]) {
  return source;
}

char *processor(char source[MAXINPUTBUFFER]) {
  /* TODO:
   *  + preprocessor macros
   *  + cut comments
   */
  return remove_comments(source);
}
