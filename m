Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070Ab2CJCxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:53:43 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:58971 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756238Ab2CJCxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:53:42 -0500
Date: Sat, 10 Mar 2012 02:53:39 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/6] Squashfs: get rid of obsolete definitions in header
 file
Message-ID: <4f5ac233.7DwpdFxsrdXJxSei%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Most of these were never used by the kernel code, but belong to
the time when the header file was used by both the kernel code
and the user space tools.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/squashfs_fs.h |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index e8e1464..6241f96 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -30,11 +30,6 @@
 
 /* size of metadata (inode and directory) blocks */
 #define SQUASHFS_METADATA_SIZE		8192
-#define SQUASHFS_METADATA_LOG		13
-
-/* default size of data blocks */
-#define SQUASHFS_FILE_SIZE		131072
-#define SQUASHFS_FILE_LOG		17
 
 /* default size of block device I/O */
 #ifdef CONFIG_SQUASHFS_4K_DEVBLK_SIZE
@@ -46,9 +41,6 @@
 #define SQUASHFS_FILE_MAX_SIZE		1048576
 #define SQUASHFS_FILE_MAX_LOG		20
 
-/* Max number of uids and gids */
-#define SQUASHFS_IDS			65536
-
 /* Max length of filename (not 255) */
 #define SQUASHFS_NAME_LEN		256
 
@@ -142,9 +134,6 @@
 #define SQUASHFS_MKINODE(A, B)		((long long)(((long long) (A)\
 					<< 16) + (B)))
 
-/* Translate between VFS mode and squashfs mode */
-#define SQUASHFS_MODE(A)		((A) & 0xfff)
-
 /* fragment and fragment table defines */
 #define SQUASHFS_FRAGMENT_BYTES(A)	\
 				((A) * sizeof(struct squashfs_fragment_entry))
@@ -215,11 +204,6 @@
 /* cached data constants for filesystem */
 #define SQUASHFS_CACHED_BLKS		8
 
-#define SQUASHFS_MAX_FILE_SIZE_LOG	64
-
-#define SQUASHFS_MAX_FILE_SIZE		(1LL << \
-					(SQUASHFS_MAX_FILE_SIZE_LOG - 2))
-
 /* meta index cache */
 #define SQUASHFS_META_INDEXES	(SQUASHFS_METADATA_SIZE / sizeof(unsigned int))
 #define SQUASHFS_META_ENTRIES	127
-- 
1.7.5.4

