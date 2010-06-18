INCLUDEPATH += $$PWD/src $$PWD/src/models $$PWD/src/styles
LIBRARYPATH += $$PWD/lib
QMAKE_RPATHDIR = $$OUT_PWD/lib

QMAKE_INCDIR += $$INCLUDEPATH
QMAKE_LIBDIR += $$LIBRARYPATH
LIBS += -L$$PWD/lib -lqtcomponents

win32:DEFINES += Q_COMPONENTS_EXPORT=__declspec(dllimport)
unix:DEFINES += Q_COMPONENTS_EXPORT=""
