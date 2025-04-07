[English](##Introduction) | [中文](#项目简介)

# libvtuzkicc

## Introduction

libvtuzkicc is a general-purpose data structure library implemented in C that provides various data structure implementations including arrays, linked lists, stacks, queues, pools, etc., with support for both static and dynamic initialization.

## Features

- Array (cc_array): A basic array structure for storing fixed-size elements.
- Stack (cc_stack): Provides both array-based and linked list-based stack implementations: cc_array_stack and cc_list_stack.
- Queue (cc_queue): Includes array-based queue cc_array_queue, linked list-based queue cc_list_queue, and circular queue cc_array_ring_queue.
- Pool (cc_pool): Implementation of object pools for efficient management and reuse of objects, reducing memory allocation and deallocation overhead.
- Linked List (cc_list): Implementation of double-linked lists, supporting insertion, deletion, and search operations. Also provides linked lists with object pools cc_list_with_pool for more efficient management of list nodes.

## Installation

### Prerequisites

- C/C++ compiler (e.g., GCC, Clang)

### Build and Install

"make help" can be used to view help information.

## Usage

Please refer to the files in the test directory for usage examples.

## Documentation

Not available yet.

## Contributing

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Author - VT-Tuzki

Project Link: [https://github.com/VT-Tuzki/libvtuzkicc](https://github.com/VT-Tuzki/libvtuzkicc)

---

# libvtuzkicc

## 项目简介

libvtuzkicc 是一个用 C 语言实现的通用数据结构库，提供了多种数据结构的实现，包括数组、链表、栈、队列、池等，并且支持静态和动态初始化。

## 特性

- 数组 (cc_array)：一个基本的数组结构，用于存储固定大小的元素。
- 栈 (cc_stack)：提供了基于数组和链表的栈实现，分别为 cc_array_stack 和 cc_list_stack。
- 队列 (cc_queue)：包括基于数组的队列 cc_array_queue 和基于链表的队列 cc_list_queue，还支持环形队列 cc_array_ring_queue。
- 池 (cc_pool)：对象池的实现，用于高效地管理和复用对象，减少内存分配和释放的开销。
- 链表 (cc_list)：双向链表的实现，支持插入、删除和查找操作。还提供了带有对象池的链表 cc_list_with_pool，可以更高效地管理链表节点。

## 安装

### 前提条件

- C/C++ 编译器 (如 GCC, Clang)

### 编译安装

"make help" 可以查看帮助信息

## 使用方法

可以看下test目录文件

## 文档

暂无

## 贡献指南

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交您的更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 打开一个 Pull Request

## 许可证

本项目采用 MIT License 许可证 - 详见 [LICENSE](LICENSE) 文件

## 联系方式

作者名称 - VT-Tuzki

项目链接: [https://github.com/VT-Tuzki/libvtuzkicc](https://github.com/VT-Tuzki/libvtuzkicc)
