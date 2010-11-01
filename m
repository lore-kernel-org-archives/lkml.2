Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0KASoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:44:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0KASmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F+xLXgX3nEzM0OATrTEDJj8uyM312J8J0vzv+shKKRRX8EF/jJkEMzXne9m3aejOcJ
         8/vciUnHUBkMKQ3WVwXlKMMHi9Gh5idI7c1a0e8pWQegM6fb1Rx52bdIifYnUZUpP+oj
         UqYUzXo+8Bjz+AhSxJ+Pjf1XQw8Ect2ZrRNsQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 20/29] Staging: yaffs2: yaffs_qsort.h: Add file
Date: Mon,  1 Nov 2010 14:41:08 -0400
Message-Id: <1288636877-7964-21-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_qsort.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_qsort.h

diff --git a/drivers/staging/yaffs2/yaffs_qsort.h b/drivers/staging/yaffs2/yaffs_qsort.h
new file mode 100644
index 0000000..4a4981b
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_qsort.h
@@ -0,0 +1,34 @@
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
+
+#ifndef __YAFFS_QSORT_H__
+#define __YAFFS_QSORT_H__
+
+#ifdef __KERNEL__
+#include <linux/sort.h>
+
+extern void yaffs_qsort(void *const base, size_t total_elems, size_t size,
+			int (*cmp)(const void *, const void *)){
+	sort(base, total_elems, size, cmp, NULL);
+}
+
+#else
+
+extern void yaffs_qsort(void *const base, size_t total_elems, size_t size,
+			int (*cmp)(const void *, const void *));
+
+#endif
+#endif
-- 
1.7.3.2.146.gca209

