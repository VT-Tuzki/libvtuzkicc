cmake_minimum_required(VERSION 3.15)
project(vtuzkicc VERSION 1.0.0 LANGUAGES C)

option(VTUZKICC_BUILD_TESTS "Build tests for vtuzkicc" ON)
option(VTUZKICC_INSTALL "Generate installation target" ON)
option(VTUZKICC_USE_ARM_CORTEX "Use ARM Cortex specific implementations" OFF)
option(VTUZKICC_USE_RISCV "Use RISC-V specific implementations" OFF)

if(VTUZKICC_USE_ARM_CORTEX)
    add_compile_definitions(USE_ARM_CORTEX)
endif()

if(VTUZKICC_USE_RISCV)
    add_compile_definitions(USE_RISCV)
endif()

add_library(compiler_flags INTERFACE)
target_compile_features(compiler_flags INTERFACE c_std_11)

file(GLOB SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c")

add_library(vtuzkicc STATIC ${SOURCE})
#只是在该项目内界定 c_std_11 和对应的编译条件 对外不可见
target_link_libraries(vtuzkicc PRIVATE compiler_flags)
target_include_directories(vtuzkicc
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)

# add compiler warning flags just when building this project via
# the BUILD_INTERFACE genex
set(gcc_like_c "$<COMPILE_LANG_AND_ID:C,ARMClang,AppleClang,Clang,GNU,LCC>")
set(msvc_c "$<COMPILE_LANG_AND_ID:C,MSVC>")
target_compile_options(compiler_flags INTERFACE
  "$<${gcc_like_c}:$<BUILD_INTERFACE:-Wall;-Wextra;-Wshadow;-Wformat=2;-Wunused;-Werror>>"
  "$<${msvc_c}:$<BUILD_INTERFACE:-W3;/WX>>"
)

if(VTUZKICC_BUILD_TESTS)
    enable_testing()
    add_subdirectory(test)
endif()

if(VTUZKICC_INSTALL)
    include(GNUInstallDirs)

    install(TARGETS vtuzkicc compiler_flags
        EXPORT vtuzkicc-targets
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )

    install(DIRECTORY include/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )

    install(EXPORT vtuzkicc-targets
        FILE vtuzkicc-targets.cmake
        NAMESPACE vtuzkicc::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/vtuzkicc
    )

    include(CMakePackageConfigHelpers)
    configure_package_config_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/cmake/vtuzkicc-config.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/vtuzkicc-config.cmake
        INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/vtuzkicc
    )

    install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/vtuzkicc-config.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/vtuzkicc
    )
endif()


# 添加到主 CMakeLists.txt 末尾
if(NOT PROJECT_IS_TOP_LEVEL)
    # 当作为子项目时，创建别名目标
    add_library(vtuzkicc::vtuzkicc ALIAS vtuzkicc)
endif()
