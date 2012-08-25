Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2HYIY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 04:24:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61362 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab2HYIXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 04:23:24 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 1/2] fat: kill unused macros
Date: Sat, 25 Aug 2012 04:23:15 -0400
Message-Id: <1345882995-6229-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused macros.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 include/linux/msdos_fs.h |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index 11cc2ac..be3dc72 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -9,18 +9,6 @@
  * The MS-DOS filesystem constants/structures
  */
 
-#define SECTOR_SIZE	512		/* sector size (bytes) */
-#define SECTOR_BITS	9		/* log2(SECTOR_SIZE) */
-#define MSDOS_DPB	(MSDOS_DPS)	/* dir entries per block */
-#define MSDOS_DPB_BITS	4		/* log2(MSDOS_DPB) */
-#define MSDOS_DPS	(SECTOR_SIZE / sizeof(struct msdos_dir_entry))
-#define MSDOS_DPS_BITS	4		/* log2(MSDOS_DPS) */
-#define MSDOS_LONGNAME	256		/* maximum name length */
-#define CF_LE_W(v)	le16_to_cpu(v)
-#define CF_LE_L(v)	le32_to_cpu(v)
-#define CT_LE_W(v)	cpu_to_le16(v)
-#define CT_LE_L(v)	cpu_to_le32(v)
-
 #define MSDOS_ROOT_INO	 1	/* The root inode number */
 #define MSDOS_FSINFO_INO 2	/* Used for managing the FSINFO block */
 
-- 
1.7.9.5

