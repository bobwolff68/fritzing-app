# /*******************************************************************
# Part of the Fritzing project - http://fritzing.org
# Copyright (c) 2016 Fritzing
# Fritzing is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# Fritzing is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Fritzing. If not, see <http://www.gnu.org/licenses/>.
# ********************************************************************


packagesExist(libgit2) {
} else {
    LIBGIT_STATIC = true
}

if ($$LIBGIT_STATIC) {
    LIBGIT2INCLUDE = "$$_PRO_FILE_PWD_/../libgit2/include"
    exists($$LIBGIT2INCLUDE/git2.h) {
        message("found libgit2 include path at $$LIBGIT2INCLUDE")
    } else {
        message("Fritzing requires libgit2")
        message("Build it from the repo at https://github.com/libgit2")
        message("See https://github.com/fritzing/fritzing-app/wiki for details.")

        error("libgit2 include path not found in $$LIBGIT2INCLUDE")
    }

    INCLUDEPATH += $$LIBGIT2INCLUDE
}

win32 {
    contains(QMAKE_TARGET.arch, x86_64) {
        LIBGIT2LIB = "$$_PRO_FILE_PWD_/../libgit2/build64/Release"
    } else {
        LIBGIT2LIB = "$$_PRO_FILE_PWD_/../libgit2/build32/Release"
    }

    exists($$LIBGIT2LIB/git2.lib) {
        message("found libgit2 library in $$LIBGIT2LIB")
    } else {
        error("libgit2 library not found in $$LIBGIT2LIB")
    }

    LIBS += -L$$LIBGIT2LIB -lgit2
    message($$PKGCONFIG)
}

unix {
    if ($$LIBGIT_STATIC) {
        LIBGIT2LIB = $$_PRO_FILE_PWD_/../libgit2/build
        exists($$LIBGIT2LIB/libgit2.a) {
            message("found libgit2 library in $$LIBGIT2LIB")
        } else {
            error("static libgit2 library not found in $$LIBGIT2LIB")
        }
        macx {
            LIBS += $$LIBGIT2LIB/libgit2.a
        } else {
            LIBS += $$LIBGIT2LIB/libgit2.a  -lssl -lcrypto
        }
    } else {
        !build_pass:warning("Using dynamic linking for libgit2.")
        #message("Enabled dynamic linking of libgit2")
        PKGCONFIG += libgit2
    }
}
