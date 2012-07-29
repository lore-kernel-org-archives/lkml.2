Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2G2KuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 06:50:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2G2KuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 06:50:19 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] Documentation: update mount option in filesystem/vfat.txt
Date: Sun, 29 Jul 2012 06:50:05 -0400
Message-Id: <1343559005-7661-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update two mount option(discard, nfs) in vfat.txt.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 Documentation/filesystems/vfat.txt |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index ead764b..dd322a4 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -137,6 +137,17 @@ errors=panic|continue|remount-ro
 		 without doing anything or remount the partition in
 		 read-only mode (default behavior).
 
+discard		  -- If set, issues discard/TRIM commands to the block
+		 device when blocks are freed. This is useful for SSD devices
+		 and sparse/thinly-provisoned LUNs.
+
+nfs			  -- This option maintains an index (cache) of directory
+		 inodes by i_logstart which is used by the nfs-related code to
+		 improve look-ups.
+
+		 Enable this only if you want to export the FAT filesystem
+		 over NFS
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
-- 
1.7.9.5

