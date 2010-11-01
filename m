Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0KAStt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:49:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49923 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab0KASlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hIQ8JK+8Q9zQ59R7FRaRcOgAZdFjS7etiwMPQWpdqbaiBXYKrkQJb34nBMJh3Nfzcd
         3CocjIlLANa36h7tMdH+Is93HCScBKu62aIffT7jj6CzsFUvvGhu4C6OiRRcIGOTfSkx
         27aaohnoXpxMts9d48bw8IC7tRMLxvSDgfnzs=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 03/29] Staging: yaffs2: devextras.h: Add file
Date: Mon,  1 Nov 2010 14:40:51 -0400
Message-Id: <1288636877-7964-4-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/devextras.h |  101 ++++++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/devextras.h

diff --git a/drivers/staging/yaffs2/devextras.h b/drivers/staging/yaffs2/devextras.h
new file mode 100644
index 0000000..ce30c82
--- /dev/null
+++ b/drivers/staging/yaffs2/devextras.h
@@ -0,0 +1,101 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+/*
+ * This file is just holds extra declarations of macros that would normally
+ * be providesd in the Linux kernel. These macros have been written from
+ * scratch but are functionally equivalent to the Linux ones.
+ *
+ */
+
+#ifndef __EXTRAS_H__
+#define __EXTRAS_H__
+
+
+#include "yportenv.h"
+
+#if !(defined __KERNEL__)
+
+/* Definition of types */
+typedef unsigned char __u8;
+typedef unsigned short __u16;
+typedef unsigned __u32;
+
+#endif
+
+
+#if !(defined __KERNEL__)
+
+
+#ifndef WIN32
+#include <sys/stat.h>
+#endif
+
+
+#ifdef CONFIG_YAFFS_PROVIDE_DEFS
+/* File types */
+
+
+#define DT_UNKNOWN	0
+#define DT_FIFO		1
+#define DT_CHR		2
+#define DT_DIR		4
+#define DT_BLK		6
+#define DT_REG		8
+#define DT_LNK		10
+#define DT_SOCK		12
+#define DT_WHT		14
+
+
+#ifndef WIN32
+#include <sys/stat.h>
+#endif
+
+/*
+ * Attribute flags.  These should be or-ed together to figure out what
+ * has been changed!
+ */
+#define ATTR_MODE	1
+#define ATTR_UID	2
+#define ATTR_GID	4
+#define ATTR_SIZE	8
+#define ATTR_ATIME	16
+#define ATTR_MTIME	32
+#define ATTR_CTIME	64
+
+struct iattr {
+	unsigned int ia_valid;
+	unsigned ia_mode;
+	unsigned ia_uid;
+	unsigned ia_gid;
+	unsigned ia_size;
+	unsigned ia_atime;
+	unsigned ia_mtime;
+	unsigned ia_ctime;
+	unsigned int ia_attr_flags;
+};
+
+#endif
+
+#else
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/stat.h>
+
+#endif
+
+
+#endif
-- 
1.7.3.2.146.gca209

