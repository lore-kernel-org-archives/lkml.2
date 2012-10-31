Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2JaJfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:35:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32996 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2JaJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:35:24 -0400
X-AuditID: cbfee61b-b7f616d00000319b-a3-5090f0da4afe
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: [PATCH 00/16 v3] f2fs: introduce flash-friendly file system
Date: Wed, 31 Oct 2012 18:35:21 +0900
Message-id: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac23SwwW/9IJbTdIRgmy8VWYLJ8GMw==
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t8zY91bHyYEGJz/I2ixZ+9JFovLu+aw
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJXx588pxoJ/xhWvljWxNTC+UOti5OSQEDCRWDj9MjuE
	LSZx4d56ti5GLg4hgWWMEm19V9hgiq7vXcEOkZjOKPH11nIo5x+jxK21+xi7GDk42AS0JTbv
	NwCJiwg8ZJTY/2wp2FhhAReJbef/sYLYLAKqEk8fbAGzeQVsJf41n2GEsAUlfky+xwJiMwuo
	S0yat4gZwpaX2LzmLTPIfAmg+KO/uiCmiICeRNeeKIgKcYlJDx6yQ0wXkPg2+RALRLWsxKYD
	zCDXSAg0s0uc+/2FGeIXSYmDK26wTGAUnYVk8Swki2chWTwLyYoFjCyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MUJiQ3oH46oGi0OMAhyMSjy8Bv/6A4RYE8uKK3MPMUpwMCuJ8DZcnxAg
	xJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnAuM0riTc0NjYxMzE1Mbc0NTfFIawkztvskRIg
	JJCeWJKanZpakFoEM46Jg1OqgTFt2xpL99eM6/8Yrjkem7Dqy6zYCD7b3cfM2aZK2X+ZsC9a
	jK3SpXbF4eNqC6x37VO8L7B/UoO1uZ3F/++B3nquPllqCyra6jtNBU6dfhljf887LHdz9zvd
	svZLk0ol+C8f+R31W3We1F83AWMNxmtqvzbHvc5/wyUyIVY3fUr7F/HE3z6v+pVYijMSDbWY
	i4oTAYUhBN66AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQd1bHyYEGMx8y2OxZ+9JFovLu+aw
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8efPKcaCf8YV
	r5Y1sTUwvlDrYuTkkBAwkbi+dwU7hC0mceHeerYuRi4OIYHpjBJfby1nh3D+MUrcWruPsYuR
	g4NNQFti834DkLiIwENGif3PloJ1Cwu4SGw7/48VxGYRUJV4+mALmM0rYCvxr/kMI4QtKPFj
	8j0WEJtZQF1i0rxFzBC2vMTmNW+ZQeZLAMUf/dUFMUUE9CS69kRBVIhLTHrwkH0CI/8sJINm
	IRk0C8mgWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjrxn0jsYVzVYHGIU4GBU
	4uE1+NcfIMSaWFZcmXuIUYKDWUmEt+H6hAAh3pTEyqrUovz4otKc1OJDjD5Af05klhJNzgcm
	hbySeENjEzMjSyMzCyMTc3McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGKs7D67dwfte
	zE/Z0v+VVs3ZVoW3IV7zhdNPXUrhOxay/bjQv1meKre4wzYdfnBb+tXr+vIDbOt07iwquXOD
	Janzlzl3BvOZh1MOzWUrsud2ZfD/subu7B2vN5XUz5vvKmj196DRDrP8Ws+rj9/6mjS4rPEy
	Upe69MnDtGxuQ1oK4xQtrjvLm5VYijMSDbWYi4oTAfVwy53pAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v2:

 o Fix compilation error for arm [Max]
 o Move proc entries to debugfs [Greg]
 o Add i_atime, i_generation, etc [Neil]
 o Support NFS export [Changman]
 o Move the f2fs magic number [Marco]
 o Add s_time_gran [Marco]
 o Fix f2fs_truncate [Marco]
 o Enhance f2fs document [Vyacheslav]
 o Support uuid and add additional comments [Vyacheslav]
 o Change superblock offset [Vyacheslav]
 o Fix some bugs and return values [Vyacheslav]
 o Improve initial mount time [Jaegeuk]
 o Fix f2fs-tools environment [Mike]

I've set up a git tree in sf.net for f2fs-tools.
Please download f2fs-tools by tag: for_patch_set_v3.

--------------------------------------------------------------------------------
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

[Furture works]
 o Aware of file access pattern
 o Erase block indirect
 o Sub-page write avoidance
 o in-line data
 o xattr optimization/in-line xattrs

I really appreciate the valuable comments from all of you in community.

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
The patches #3-#16 adds f2fs source files to fs/f2fs/.
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

Jaegeuk Kim (17):
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
  f2fs: move proc files to debugfs
  f2fs: update Kconfig and Makefile

 Documentation/filesystems/00-INDEX |    2 +
 Documentation/filesystems/f2fs.txt |  417 +++++++++
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/f2fs/Kconfig                    |   52 ++
 fs/f2fs/Makefile                   |    7 +
 fs/f2fs/acl.c                      |  465 ++++++++++
 fs/f2fs/acl.h                      |   57 ++
 fs/f2fs/checkpoint.c               |  792 ++++++++++++++++
 fs/f2fs/data.c                     |  701 ++++++++++++++
 fs/f2fs/debug.c                    |  361 ++++++++
 fs/f2fs/dir.c                      |  674 ++++++++++++++
 fs/f2fs/f2fs.h                     | 1062 +++++++++++++++++++++
 fs/f2fs/file.c                     |  637 +++++++++++++
 fs/f2fs/gc.c                       |  742 +++++++++++++++
 fs/f2fs/gc.h                       |  117 +++
 fs/f2fs/hash.c                     |   98 ++
 fs/f2fs/inode.c                    |  266 ++++++
 fs/f2fs/namei.c                    |  504 ++++++++++
 fs/f2fs/node.c                     | 1763 +++++++++++++++++++++++++++++++++++
 fs/f2fs/node.h                     |  353 +++++++
 fs/f2fs/recovery.c                 |  375 ++++++++
 fs/f2fs/segment.c                  | 1798 ++++++++++++++++++++++++++++++++++++
 fs/f2fs/segment.h                  |  615 ++++++++++++
 fs/f2fs/super.c                    |  656 +++++++++++++
 fs/f2fs/xattr.c                    |  389 ++++++++
 fs/f2fs/xattr.h                    |  145 +++
 include/linux/f2fs_fs.h            |  410 ++++++++
 include/uapi/linux/magic.h         |    1 +
 29 files changed, 13461 insertions(+)
 create mode 100644 Documentation/filesystems/f2fs.txt
 create mode 100644 fs/f2fs/Kconfig
 create mode 100644 fs/f2fs/Makefile
 create mode 100644 fs/f2fs/acl.c
 create mode 100644 fs/f2fs/acl.h
 create mode 100644 fs/f2fs/checkpoint.c
 create mode 100644 fs/f2fs/data.c
 create mode 100644 fs/f2fs/debug.c
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



