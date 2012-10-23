Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2JWCV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:21:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40633 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab2JWCVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:21:55 -0400
X-AuditID: cbfee61b-b7f616d00000319b-b2-5085ff41f73f
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: [PATCH 00/16 v2] f2fs: introduce flash-friendly file system
Date: Tue, 23 Oct 2012 11:21:53 +0900
Message-id: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2wxSqFSBGNbwToQsqWze4D+LI2xQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t8zI13H/60BBpN3Wlrs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX07L7AVnBRt+L/qzdMDYxvFLsYOTkkBEwklhycwwJh
	i0lcuLeerYuRi0NIYBmjxN1tLawwRcuv/mKBSExnlLg34wk7hPOPUWLJ5ZVALRwcbALaEpv3
	G4DERQQeMkrsf7aUHaRbWMBFYsGuM2ArWARUJf7MOskMYvMK2Eq87j3KBGELSvyYfA+shllA
	XWLSvEXMELa8xOY1b5lB5ksAxR/91QUxRQT0JA6v9oCoEJHY9+IdI8R0AYlvkw+xQFTLSmw6
	wAxyjYRAM7vErfYzzBC/SEocXHGDZQKj6Cwki2chWTwLyeJZSFYsYGRZxSiaWpBcUJyUnmuk
	V5yYW1yal66XnJ+7iRESG9I7GFc1WBxiFOBgVOLh7djfGiDEmlhWXJl7iFGCg1lJhFc5ACjE
	m5JYWZValB9fVJqTWnyI0Qfo8onMUqLJ+cC4zSuJNzQ2NjEzMTUxtzQ1N8UhrCTO2+yREiAk
	kJ5YkpqdmlqQWgQzjomDU6qBMVI/aa1gSUmIZrPJnrzS1HMe7H9+RrdHay74JsknUZxvXKSR
	rlNxcu+Fxx/33np8dPHKJeGB7f5f/j5bJuyu1VIXc2H/23Xn/zV8sT3eWuB0TOfeW7Ybd4Kv
	zOewXp7rOIcj9ObiCWYzLi02vsgf4FV/iim3+SgnA8OxC0ZbTl3fWXOy6oTrEyWW4oxEQy3m
	ouJEACjFjzu6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQV3H/60BBremmlrs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm9Oy+wFZwUbfi
	/6s3TA2MbxS7GDk5JARMJJZf/cUCYYtJXLi3nq2LkYtDSGA6o8S9GU/YIZx/jBJLLq8EynBw
	sAloS2zebwASFxF4yCix/9lSdpBuYQEXiQW7zoBNYhFQlfgz6yQziM0rYCvxuvcoE4QtKPFj
	8j2wGmYBdYlJ8xYxQ9jyEpvXvGUGmS8BFH/0VxfEFBHQkzi82gOiQkRi34t3jBMY+WchGTQL
	yaBZSAbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw5D2T3sG4qsHiEKMAB6MS
	D2/H/tYAIdbEsuLK3EOMEhzMSiK8ygFAId6UxMqq1KL8+KLSnNTiQ4w+QH9OZJYSTc4HJoW8
	knhDYxMzI0sjMwsjE3NzHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhgFJjYH/flyUcTg
	wvXCw1Vv1URkajV012g0qq9eHbCkcfPT1fFb/SsdZhz339j9pYU/rpRTMe5q7qtbm4x+PQ+x
	c0ju9sxW2itZ1OwwO5PrYkW5zvIVUd+rZjkkNWpNn/BuvuyEpWvnL6x7oi3OI3L2TVHe3kXP
	WzWTX+9+5Tj/TssbUz01/hQlluKMREMt5qLiRAAVzVtc6QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:

 o Apply the recent user namespace changes [Eric]
 o Remove unnecessary condition check [Al]
 o Fix wrong description [Stefan]
 o Fix f2fs document [Randy]
 o Enlarge the volume label length to 256 unicodes [Martin]
 o Support time resolution to nano scale [Boaz]
 o Fix the wrong use of endian conversion [David]
 o Fix the use of mutex and spinlocks [David]
 o Remove the use of __GFP_NOFAIL, etc [Neil]
 o Change the flow for readability [Neil]
 o Reduce the lock contention in CP [Neil]
 o Support multiples of section size [Arnd]
 o Support configurable extension list [Arnd]
 o Support configurable active log numbers [Arnd]

[Future works]
 o Aware of file access pattern
 o Erase block indirect
 o Sub-page write avoidance
 o In-line data
 o Xattr optimization/in-line xattrs

I really appreciate the valuable comments from all of you in community.

Note)
Due to the change of on-disk layout, please download f2fs-tools-1.1.0.tar.gz.

--------------------------------------------------------------------------------

This is a new patch set for the f2fs file system.

What is F2FS?
=============

NAND flash memory-based storage devices, such as SSD, eMMC, and SD cards, have
been widely being used for ranging from mobile to server systems. Since they are
known to have different characteristics from the conventional rotational disks,
a file system, an upper layer to the storage device, should adapt to the changes
from the sketch.

F2FS is a new file system carefully designed for the NAND flash memory-based storage
devices. We chose a log structure file system approach, but we tried to adapt it
to the new form of storage. Also we remedy some known issues of the very old log
structured file system, such as snowball effect of wandering tree and high cleaning
overhead.

Because a NAND-based storage device shows different characteristics according to
its internal geometry or flash memory management scheme aka FTL, we add various
parameters not only for configuring on-disk layout, but also for selecting allocation
and cleaning algorithms.

Patch set
=========

The patch #1 adds a document to Documentation/filesystems/.
The patch #2 adds a header file of on-disk layout to include/linux/.
The patches #3-#15 adds f2fs source files to fs/f2fs/.
The Last patch, patch #16, updates Makefile and Kconfig.

mkfs.f2fs
=========

The file system formatting tool, "mkfs.f2fs", is available from the following
download page:		http://sourceforge.net/projects/f2fs-tools/

Usage
=====

If you'd like to experience f2fs, simply:
 # mkfs.f2fs /dev/sdb1
 # mount -t f2fs /dev/sdb1 /mnt/f2fs

Short log
=========

Jaegeuk Kim (16):
  f2fs: add document
  f2fs: add on-disk layout
  f2fs: add superblock and major in-memory structure
  f2fs: add super block operations
  f2fs: add checkpoint operations
  f2fs: add node operations
  f2fs: add segment operations
  f2fs: add file operations
  f2fs: add address space operations for data
  f2fs: add core inode operations
  f2fs: add inode operations for special inodes
  f2fs: add core directory operations
  f2fs: add xattr and acl functionalities
  f2fs: add garbage collection functions
  f2fs: add recovery routines for roll-forward
  f2fs: update Kconfig and Makefile

 Documentation/filesystems/00-INDEX |    2 +
 Documentation/filesystems/f2fs.txt |  404 ++++++++
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/f2fs/Kconfig                    |   55 ++
 fs/f2fs/Makefile                   |    6 +
 fs/f2fs/acl.c                      |  465 ++++++++++
 fs/f2fs/acl.h                      |   57 ++
 fs/f2fs/checkpoint.c               |  795 ++++++++++++++++
 fs/f2fs/data.c                     |  701 ++++++++++++++
 fs/f2fs/dir.c                      |  657 +++++++++++++
 fs/f2fs/f2fs.h                     |  982 ++++++++++++++++++++
 fs/f2fs/file.c                     |  640 +++++++++++++
 fs/f2fs/gc.c                       | 1139 +++++++++++++++++++++++
 fs/f2fs/gc.h                       |  203 ++++
 fs/f2fs/hash.c                     |   98 ++
 fs/f2fs/inode.c                    |  262 ++++++
 fs/f2fs/namei.c                    |  494 ++++++++++
 fs/f2fs/node.c                     | 1782 +++++++++++++++++++++++++++++++++++
 fs/f2fs/node.h                     |  330 +++++++
 fs/f2fs/recovery.c                 |  375 ++++++++
 fs/f2fs/segment.c                  | 1795 ++++++++++++++++++++++++++++++++++++
 fs/f2fs/segment.h                  |  594 ++++++++++++
 fs/f2fs/super.c                    |  590 ++++++++++++
 fs/f2fs/xattr.c                    |  389 ++++++++
 fs/f2fs/xattr.h                    |  145 +++
 include/linux/f2fs_fs.h            |  362 ++++++++
 27 files changed, 13324 insertions(+)
 create mode 100644 Documentation/filesystems/f2fs.txt
 create mode 100644 fs/f2fs/Kconfig
 create mode 100644 fs/f2fs/Makefile
 create mode 100644 fs/f2fs/acl.c
 create mode 100644 fs/f2fs/acl.h
 create mode 100644 fs/f2fs/checkpoint.c
 create mode 100644 fs/f2fs/data.c
 create mode 100644 fs/f2fs/dir.c
 create mode 100644 fs/f2fs/f2fs.h
 create mode 100644 fs/f2fs/file.c
 create mode 100644 fs/f2fs/gc.c
 create mode 100644 fs/f2fs/gc.h
 create mode 100644 fs/f2fs/hash.c
 create mode 100644 fs/f2fs/inode.c
 create mode 100644 fs/f2fs/namei.c
 create mode 100644 fs/f2fs/node.c
 create mode 100644 fs/f2fs/node.h
 create mode 100644 fs/f2fs/recovery.c
 create mode 100644 fs/f2fs/segment.c
 create mode 100644 fs/f2fs/segment.h
 create mode 100644 fs/f2fs/super.c
 create mode 100644 fs/f2fs/xattr.c
 create mode 100644 fs/f2fs/xattr.h
 create mode 100644 include/linux/f2fs_fs.h

-- 
1.7.9.5




---
Jaegeuk Kim
Samsung



