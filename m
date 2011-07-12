Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1GLRZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:25:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51108 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab1GLRZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:25:07 -0400
From: kerolasa@iki.fi
To: linux-kernel@vger.kernel.org
Cc: kerolasa@iki.fi
Subject: [PATCH] minix: tell usage of different magic numbers
Date: Tue, 12 Jul 2011 19:24:49 +0200
Message-Id: <4e1c8370.d12c0e0a.7282.0113@mx.google.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Kerola <kerolasa@iki.fi>

One could see from minix inode.c the same, but telling the
differences in comments is more clear. The v3 information is not
strictly speaking needed, but it is there in sake of completeness.

Signed-off-by: Sami Kerola <kerolasa@iki.fi>
---
 include/linux/magic.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/magic.h b/include/linux/magic.h
index 1e5df2a..2d4beab 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -30,11 +30,11 @@
 #define ANON_INODE_FS_MAGIC	0x09041934
 #define PSTOREFS_MAGIC		0x6165676C
 
-#define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
-#define MINIX_SUPER_MAGIC2	0x138F		/* minix fs, 30 char names */
-#define MINIX2_SUPER_MAGIC	0x2468		/* minix V2 fs */
-#define MINIX2_SUPER_MAGIC2	0x2478		/* minix V2 fs, 30 char names */
-#define MINIX3_SUPER_MAGIC	0x4d5a		/* minix V3 fs */
+#define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
+#define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
+#define MINIX2_SUPER_MAGIC	0x2468		/* minix v2 fs, 14 char names */
+#define MINIX2_SUPER_MAGIC2	0x2478		/* minix v2 fs, 30 char names */
+#define MINIX3_SUPER_MAGIC	0x4d5a		/* minix v3 fs, 60 char names */
 
 #define MSDOS_SUPER_MAGIC	0x4d44		/* MD */
 #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
-- 
1.7.6

