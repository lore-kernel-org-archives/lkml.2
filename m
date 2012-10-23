Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab2JWCdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:33:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48623 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab2JWCda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:33:30 -0400
X-AuditID: cbfee61b-b7f616d00000319b-cb-508601f969f6
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
In-reply-to: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
Subject: [PATCH 16/16 v2] f2fs: update Kconfig and Makefile
Date: Tue, 23 Oct 2012 11:33:28 +0900
Message-id: <002001cdb0c6$c9527550$5bf75ff0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2wxSqFSBGNbwToQsqWze4D+LI2xQAAYyaw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zfd2fjG0BBpNuS1js2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcP7WCrWCHbMXWyadYGhhviHcxcnBICJhI7HyZ0MXI
	CWSKSVy4t56ti5GLQ0hgGaPEm5l7mSASJhI3by5ghkhMZ5T43b4Fquofo8Tj3QcZQSaxCWhL
	bN5vABIXEXjIKLH/2VJ2kG4hAVuJSf8XM4PYnAJ2Es8eXWQEsYUFrCW+9bWygNgsAqoSc/av
	YAWxeYHqL088xwRhC0r8mHwPrIZZQF1i0rxFzBC2vMTmNW+ZIT5Ql3j0VxckLCJgJHHm0xEm
	iBIRiX0v3jFCjBeQ+Db5EAtEuazEpgPMEH8tYpfoOM8JYUtKHFxxg2UCo/gsJItnIVk8C8ni
	WUg2LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kREknSOxhXNVgcYhTgYFTi4e3Y3xog
	xJpYVlyZe4hRgoNZSYRXOQAoxJuSWFmVWpQfX1Sak1p8iNEH6PCJzFKiyfnAKM8riTc0NjYx
	MzE1Mbc0NTfFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgdGe29ff9fRDzktTchTKjdTf
	L3pjEjj74O6z/893sztz6/3i61Iob/m64vj/ONd2Y7ljS1sV7GoF7Kvuzv64KSBy8Qq97kPv
	P85Z5HK/t+L13SvvCh822YacXbD1x6S7tpue37pzuJhr+886V9Mj7nsOWKSsap1wY635J9OU
	X4/bW1xv8X5L8upVYinOSDTUYi4qTgQAjMywsNECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQd2fjG0BBlPOiFjs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3D+1gq1gh2zF
	1smnWBoYb4h3MXJySAiYSNy8uYAZwhaTuHBvPVsXIxeHkMB0Ronf7VugnH+MEo93H2TsYuTg
	YBPQlti83wAkLiLwkFFi/7Ol7CDdQgK2EpP+LwabxClgJ/Hs0UVGEFtYwFriW18rC4jNIqAq
	MWf/ClYQmxeo/vLEc0wQtqDEj8n3wGqYBdQlJs1bxAxhy0tsXvOWGWSvBFD80V9dkLCIgJHE
	mU9HmCBKRCT2vXjHOIFRcBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgTH6jPpHYyrGiwOMQpwMCrx8Hbsbw0QYk0sK67MPcQowcGsJMKrHAAU4k1JrKxKLcqP
	LyrNSS0+xOgD9OhEZinR5HxgGskriTc0NjEzsjQyszAyMTfHIawkztvskRIgJJCeWJKanZpa
	kFoEM46Jg1OqgdHysn9idBXT7U2v8+9zHLuzzPzT0rZlXQs8o8/MTA55uOB91onkHVE6JRs4
	93XIzY38Xue12z4m2+xoTPDuwxMXPepd+sw+sWD5vXu+6fOOrsu+1scnpR5ZJWY/Jb69yvPU
	azcuyZX/KtawN+2duj42/treVznvJGKOW0/onfjUdwdzepLosrdKLMUZiYZazEXFiQBwmOnJ
	AgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Makefile and Kconfig for f2fs, and updates Makefile and Kconfig files
in the fs directory.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/Kconfig       |    1 +
 fs/Makefile      |    1 +
 fs/f2fs/Kconfig  |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/Makefile |    6 ++++++
 4 files changed, 63 insertions(+)
 create mode 100644 fs/f2fs/Kconfig
 create mode 100644 fs/f2fs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index f95ae3a..e352b37 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -220,6 +220,7 @@ source "fs/pstore/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
+source "fs/f2fs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/Makefile b/fs/Makefile
index 1d7af79..9d53192 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -123,6 +123,7 @@ obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_BTRFS_FS)		+= btrfs/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_F2FS_FS)		+= f2fs/
 obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
new file mode 100644
index 0000000..8821c6a
--- /dev/null
+++ b/fs/f2fs/Kconfig
@@ -0,0 +1,55 @@
+config F2FS_FS
+	tristate "F2FS filesystem support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  F2FS is based on Log-structured File System (LFS), which supports
+	  versatile "flash-friendly" features. The design has been focused on
+	  addressing the fundamental issues in LFS, which are snowball effect
+	  of wandering tree and high cleaning overhead.
+
+	  Since flash-based storages show different characteristics according to
+	  the internal geometry or flash memory management schemes aka FTL, F2FS
+	  and tools support various parameters not only for configuring on-disk
+	  layout, but also for selecting allocation and cleaning algorithms.
+
+	  If unsure, say N.
+
+config F2FS_STAT_FS
+	bool "F2FS Status Information"
+	depends on F2FS_FS
+	default y
+	help
+	  /proc/fs/f2fs/ contains information about partitions mounted as f2fs.
+	  For each partition, a corresponding directory, named as its device
+	  name, is provided with the following proc entries.
+
+	  f2fs_stat	major file system information managed by f2fs currently
+	  f2fs_sit_stat	average SIT information about whole segments
+	  f2fs_mem_stat	current memory footprint consumed by f2fs
+
+	  e.g., in /proc/fs/f2fs/sdb1/
+
+config F2FS_FS_XATTR
+	bool "F2FS extended attributes"
+	depends on F2FS_FS
+	default y
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page, or visit
+	  <http://acl.bestbits.at/> for details).
+
+	  If unsure, say N.
+
+config F2FS_FS_POSIX_ACL
+	bool "F2FS Access Control Lists"
+	depends on F2FS_FS_XATTR
+	select FS_POSIX_ACL
+	default y
+	help
+	  Posix Access Control Lists (ACLs) support permissions for users and
+	  gourps beyond the owner/group/world scheme.
+
+	  To learn more about Access Control Lists, visit the POSIX ACLs for
+	  Linux website <http://acl.bestbits.at/>.
+
+	  If you don't know what Access Control Lists are, say N
diff --git a/fs/f2fs/Makefile b/fs/f2fs/Makefile
new file mode 100644
index 0000000..72fcf9a
--- /dev/null
+++ b/fs/f2fs/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_F2FS_FS) += f2fs.o
+
+f2fs-y		:= dir.o file.o inode.o namei.o hash.o super.o
+f2fs-y		+= checkpoint.o gc.o data.o node.o segment.o recovery.o
+f2fs-$(CONFIG_F2FS_FS_XATTR) += xattr.o
+f2fs-$(CONFIG_F2FS_FS_POSIX_ACL) += acl.o
-- 
1.7.9.5




---
Jaegeuk Kim
Samsung



