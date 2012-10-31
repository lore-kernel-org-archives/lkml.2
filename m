Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934791Ab2JaJub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:50:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35567 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2JaJu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:50:27 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-38-5090f461c67d
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
In-reply-to: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
Subject: [PATCH 17/17] f2fs: update Kconfig and Makefile
Date: Wed, 31 Oct 2012 18:50:25 +0900
Message-id: <005201cdb74d$26e57870$74b06950$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac23SwwW/9IJbTdIRgmy8VWYLJ8GMwAAfv7A
Content-language: en-us
x-cr-hashedpuzzle: CqDJ IQ8u OCmg ZxjD is8A wVHG 1czy ABmWmQ== ACv1qw==
 AC5L9w== ADlejA== AEOMyA== AFRPuQ== AF0SYQ== AHRlQw==
 AKH+uA==;9;YQByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGMAaAB1AHIALgBsAGUAZQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGMAbQAyADIANAAuAGwAZQBlAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAagBvAG8AeQBvAHUAbgBnAC4AaAB3AGEAbgBnAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AZgBzAGQAZQB2AGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAeQB0AHMAbwBAAG0AaQB0AC4AZQBkAHUAOwB2AGkAcgBvAEAAegBlAG4AaQB2AC4AbABpAG4AdQB4AC4AbwByAGcALgB1AGsA;Sosha1_v1;7;{7DE02567-0ABB-4074-9BF7-676E677F4678};agBhAGUAZwBlAHUAawAuAGsAaQBtAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Wed,
 31 Oct 2012 09:50:07
 GMT;WwBQAEEAVABDAEgAIAAxADcALwAxADcAXQAgAGYAMgBmAHMAOgAgAHUAcABkAGEAdABlACAASwBjAG8AbgBmAGkAZwAgAGEAbgBkACAATQBhAGsAZQBmAGkAbABlAA==
x-cr-puzzleid: {7DE02567-0ABB-4074-9BF7-676E677F4678}
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ93ELxMCDE6/sLbYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mro3nuPtWCdYsXdk4fZGxhfS3UxcnJICJhIzGl8yA5h
	i0lcuLeerYuRi0NIYBmjROfJXawwRbOPX2SGSCxilFjTPYMJwvnHKPFi+TGgdg4ONgFtic37
	DUDiIgIPGSX2P1sKNlZIwFbi6f1rYDWcAnYSl09EgISFBSwk+ueuYgaxWQRUJVZN38MIYvMC
	lf+ZNpUdwhaU+DH5HguIzSygLjFp3iJmCFteYvOat8wgIyWA4o/+6oKERQSMJF7/eM0OUSIu
	MekByGNcQCVn2CV+r3oD9YypxJltZ6D2Ckh8m3yIBWKOrMSmA8wQ9fuA6ld/Z4Kol5Q4uOIG
	ywRGyVlITpqF5KRZSE6ahWT3AkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxgh0Se1g3Fl
	g8UhRgEORiUeXsN//QFCrIllxZW5hxglOJiVRHiTP00IEOJNSaysSi3Kjy8qzUktPsToA3T5
	RGYp0eR8YGLIK4k3NDY2MTMxNTG3NDU3xSGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoHx
	UNKKQI3Nn54vfOx7KiUmZvOch/uTPt/Q04tr32A9werOmjuG/Cf2dj678ET1fJ6a1ry5D2In
	iiWoF7IGFcofP9s+d2el3BLBw8xt2yb+tk1b83aG2YMpSZ/uCn7c87M+kz1bNq1Q9cMdK89Z
	HjGW0UqR/WtKDa6VNW0//qFLMfG6XXowT+0UJZbijERDLeai4kQAHcANpusCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xgG7ilwkBBh3bzC327D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzuvfeYy1Yp1hx
	9+Rh9gbG11JdjJwcEgImErOPX2SGsMUkLtxbz9bFyMUhJLCIUWJN9wwmCOcfo8SL5cfYuxg5
	ONgEtCU27zcAiYsIPGSU2P9sKTtIt5CArcTT+9fAajgF7CQun4gACQsLWEj0z10FtoBFQFVi
	1fQ9jCA2L1D5n2lT2SFsQYkfk++xgNjMAuoSk+YtYoaw5SU2r3nLDDJSAij+6K8uSFhEwEji
	9Y/X7BAl4hKTHjxkBzlHQuAMu8TvVW9YIZ4xlTiz7QzzBEbhWUhWzEKyYhaSFbOQzFrAyLKK
	UTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi2n0ntYFzZYHGIUYCDUYmH1/Bff4AQa2JZcWXu
	IUYJDmYlEd7kTxMChHhTEiurUovy44tKc1KLDzH6AENgIrOUaHI+MO3klcQbGpuYGVkamVkY
	mZib4xBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cA4XSNgrQXPbMYTXv0/k8w7lv57WX0p
	rsghTUYluiaMY+4Ku5dXpnSKPDf4ckok7SgLf7husNHmPQY2SxYmM4Wui3IVzFZc4Vy5s+rf
	TyHGlW+ywhq2OXZ/SWCM2lmfYu2S73g53PNs827NtWan5NRjt3GsZy7wY5879WnjSx31218P
	iUaHrVFiKc5INNRiLipOBACGkfhWGgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Makefile and Kconfig for f2fs, and updates Makefile and Kconfig files
in the fs directory.
In addition, add F2FS_SUPER_MAGIC in magic.h.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/Kconfig                 |    1 +
 fs/Makefile                |    1 +
 fs/f2fs/Kconfig            |   52 ++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/Makefile           |    7 ++++++
 include/uapi/linux/magic.h |    1 +
 5 files changed, 62 insertions(+)
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
index 0000000..37a6b8e
--- /dev/null
+++ b/fs/f2fs/Kconfig
@@ -0,0 +1,52 @@
+config F2FS_FS
+	tristate "F2FS filesystem support (EXPERIMENTAL)"
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
+	depends on F2FS_FS && DEBUG_FS
+	default y
+	help
+	  /sys/kernel/debug/f2fs/ contains information about all the partitions
+	  mounted as f2fs. Each file shows the whole f2fs information.
+
+	  /sys/kernel/debug/f2fs/status includes:
+	    - major file system information managed by f2fs currently
+	    - average SIT information about whole segments
+	    - current memory footprint consumed by f2fs.
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
index 0000000..27a0820
--- /dev/null
+++ b/fs/f2fs/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_F2FS_FS) += f2fs.o
+
+f2fs-y		:= dir.o file.o inode.o namei.o hash.o super.o
+f2fs-y		+= checkpoint.o gc.o data.o node.o segment.o recovery.o
+f2fs-$(CONFIG_F2FS_STAT_FS) += debug.o
+f2fs-$(CONFIG_F2FS_FS_XATTR) += xattr.o
+f2fs-$(CONFIG_F2FS_FS_POSIX_ACL) += acl.o
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index e15192c..66353ff 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -23,6 +23,7 @@
 #define EXT4_SUPER_MAGIC	0xEF53
 #define BTRFS_SUPER_MAGIC	0x9123683E
 #define NILFS_SUPER_MAGIC	0x3434
+#define F2FS_SUPER_MAGIC	0xF2F52010
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
-- 
1.7.9.5




---
Jaegeuk Kim
Samsung


