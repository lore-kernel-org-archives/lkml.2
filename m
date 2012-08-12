Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2HLJpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:45:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2HLJpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:45:10 -0400
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 3/7] fs/fat: Changed indentation of some comments in fat.h
Date: Sun, 12 Aug 2012 19:44:43 +1000
Message-Id: <1344764687-4155-4-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
References: <1344764687-4155-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comments were not lined up properly, so I just
re-indented them.

This also fixes a stupid checkpatch issue unknowingly

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 fs/fat/fat.h |   72 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 2ef82cf..76f036f 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -28,27 +28,27 @@ struct fat_mount_options {
 	gid_t fs_gid;
 	unsigned short fs_fmask;
 	unsigned short fs_dmask;
-	unsigned short codepage;  /* Codepage for shortname conversions */
-	char *iocharset;          /* Charset used for filename input/display */
-	unsigned short shortname; /* flags for shortname display/create rule */
-	unsigned char name_check; /* r = relaxed, n = normal, s = strict */
-	unsigned char errors;	  /* On error: continue, panic, remount-ro */
+	unsigned short codepage;   /* Codepage for shortname conversions */
+	char *iocharset;           /* Charset used for filename input/display */
+	unsigned short shortname;  /* flags for shortname display/create rule */
+	unsigned char name_check;  /* r = relaxed, n = normal, s = strict */
+	unsigned char errors;	   /* On error: continue, panic, remount-ro */
 	unsigned short allow_utime;/* permission for setting the [am]time */
-	unsigned quiet:1,         /* set = fake successful chmods and chowns */
-		 showexec:1,      /* set = only set x bit for com/exe/bat */
-		 sys_immutable:1, /* set = system files are immutable */
-		 dotsOK:1,        /* set = hidden and system files are named '.filename' */
-		 isvfat:1,        /* 0=no vfat long filename support, 1=vfat support */
-		 utf8:1,	  /* Use of UTF-8 character set (Default) */
-		 unicode_xlate:1, /* create escape sequences for unhandled Unicode */
-		 numtail:1,       /* Does first alias have a numeric '~1' type tail? */
-		 flush:1,	  /* write things quickly */
-		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
-		 usefree:1,	  /* Use free_clusters for FAT32 */
-		 tz_utc:1,	  /* Filesystem timestamps are in UTC */
-		 rodir:1,	  /* allow ATTR_RO for directory */
-		 discard:1,	  /* Issue discard requests on deletions */
-		 nfs:1;		  /* Do extra work needed for NFS export */
+	unsigned quiet:1,          /* set = fake successful chmods and chowns */
+		 showexec:1,       /* set = only set x bit for com/exe/bat */
+		 sys_immutable:1,  /* set = system files are immutable */
+		 dotsOK:1,         /* set = hidden and system files are named '.filename' */
+		 isvfat:1,         /* 0=no vfat long filename support, 1=vfat support */
+		 utf8:1,	   /* Use of UTF-8 character set (Default) */
+		 unicode_xlate:1,  /* create escape sequences for unhandled Unicode */
+		 numtail:1,        /* Does first alias have a numeric '~1' type tail? */
+		 flush:1,	   /* write things quickly */
+		 nocase:1,	   /* Does this need case conversion? 0=need case conversion*/
+		 usefree:1,	   /* Use free_clusters for FAT32 */
+		 tz_utc:1,	   /* Filesystem timestamps are in UTC */
+		 rodir:1,	   /* allow ATTR_RO for directory */
+		 discard:1,	   /* Issue discard requests on deletions */
+		 nfs:1;		   /* Do extra work needed for NFS export */
 };
 
 #define FAT_HASH_BITS	8
@@ -58,28 +58,28 @@ struct fat_mount_options {
  * MS-DOS file system in-core superblock data
  */
 struct msdos_sb_info {
-	unsigned short sec_per_clus; /* sectors/cluster */
-	unsigned short cluster_bits; /* log2(cluster_size) */
-	unsigned int cluster_size;   /* cluster size */
+	unsigned short sec_per_clus;  /* sectors/cluster */
+	unsigned short cluster_bits;  /* log2(cluster_size) */
+	unsigned int cluster_size;    /* cluster size */
 	unsigned char fats, fat_bits; /* number of FATs, FAT bits (12 or 16) */
 	unsigned short fat_start;
-	unsigned long fat_length;    /* FAT start & length (sec.) */
+	unsigned long fat_length;     /* FAT start & length (sec.) */
 	unsigned long dir_start;
-	unsigned short dir_entries;  /* root dir start & entries */
-	unsigned long data_start;    /* first data sector */
-	unsigned long max_cluster;   /* maximum cluster number */
-	unsigned long root_cluster;  /* first cluster of the root directory */
-	unsigned long fsinfo_sector; /* sector number of FAT32 fsinfo */
+	unsigned short dir_entries;   /* root dir start & entries */
+	unsigned long data_start;     /* first data sector */
+	unsigned long max_cluster;    /* maximum cluster number */
+	unsigned long root_cluster;   /* first cluster of the root directory */
+	unsigned long fsinfo_sector;  /* sector number of FAT32 fsinfo */
 	struct mutex fat_lock;
-	unsigned int prev_free;      /* previously allocated cluster number */
-	unsigned int free_clusters;  /* -1 if undefined */
+	unsigned int prev_free;       /* previously allocated cluster number */
+	unsigned int free_clusters;   /* -1 if undefined */
 	unsigned int free_clus_valid; /* is free_clusters valid? */
 	struct fat_mount_options options;
-	struct nls_table *nls_disk;  /* Codepage used on disk */
-	struct nls_table *nls_io;    /* Charset used for input and display */
-	const void *dir_ops;		     /* Opaque; default directory operations */
-	int dir_per_block;	     /* dir entries per block */
-	int dir_per_block_bits;	     /* log2(dir_per_block) */
+	struct nls_table *nls_disk;   /* Codepage used on disk */
+	struct nls_table *nls_io;     /* Charset used for input and display */
+	const void *dir_ops;	      /* Opaque; default directory operations */
+	int dir_per_block;	      /* dir entries per block */
+	int dir_per_block_bits;	      /* log2(dir_per_block) */
 
 	int fatent_shift;
 	struct fatent_operations *fatent_ops;
-- 
1.7.9.5

