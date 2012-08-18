Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab2HRJnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:43:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2HRJnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:43:37 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 4/4] Documentation: update nfs option in filesystem/vfat.txt
Date: Sat, 18 Aug 2012 05:43:27 -0400
Message-Id: <1345283007-7671-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

update nfs option in filesystem/vfat.txt

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 Documentation/filesystems/vfat.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index de1e6c4..b9405aa 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -143,7 +143,8 @@ discard       -- If set, issues discard/TRIM commands to the block
 
 nfs           -- This option maintains an index (cache) of directory
 		 inodes by i_logstart which is used by the nfs-related code to
-		 improve look-ups.
+		 improve look-ups. And rebuild inode after reading
+		 directory entry from disk cluster if look-up fail.
 
 		 Enable this only if you want to export the FAT filesystem
 		 over NFS
-- 
1.7.9.5

