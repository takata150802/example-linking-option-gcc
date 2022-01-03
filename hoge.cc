#include <iostream>
#include "hoge.h"

void hoge (void) {
   std::cout << __FILE__
             << "("
             << __LINE__
             << "): "
             << "hoge"
             << std::endl;
}
