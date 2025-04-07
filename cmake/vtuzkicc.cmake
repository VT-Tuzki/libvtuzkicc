# 检查是否已经添加了 vtuzkicc 目标
if(NOT TARGET vtuzkicc::vtuzkicc)
    # 如果当前是作为子目录包含
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../CMakeLists.txt")
        # 如果作为子目录包含时，设置选项以避免测试和安装
        set(VTUZKICC_BUILD_TESTS OFF CACHE BOOL "Disable vtuzkicc tests when used as subproject" FORCE)
        set(VTUZKICC_INSTALL OFF CACHE BOOL "Disable vtuzkicc installation when used as subproject" FORCE)
        add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/.. ${CMAKE_BINARY_DIR}/vtuzkicc)
    else()
        # 否则尝试通过 find_package 找到已安装的包
        find_package(vtuzkicc REQUIRED)
    endif()
endif()