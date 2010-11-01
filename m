Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0KASn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:43:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60527 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab0KASmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CJL7cr0yeCk6hpdTqQaUrjQcfcijePJgqN92fsB1EHCRVcP1VK+4FE8cThIbiOudWv
         TaNQOFqLDWo7yfjYypaZkIURvnU13Spf5qjP5kAPC4tuC16ULm5Rz52v4AI+rbpfS+yf
         kx3aLQM2GcHZXKmzO+ksZr6zl9Od9/lmD3dSY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 23/29] Staging: yaffs2: yaffs_trace.h: Add file
Date: Mon,  1 Nov 2010 14:41:11 -0400
Message-Id: <1288636877-7964-24-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_trace.h |   60 ++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_trace.h

diff --git a/drivers/staging/yaffs2/yaffs_trace.h b/drivers/staging/yaffs2/yaffs_trace.h
new file mode 100644
index 0000000..9fe7214
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_trace.h
@@ -0,0 +1,60 @@
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
+#ifndef __YTRACE_H__
+#define __YTRACE_H__
+
+extern unsigned int yaffs_trace_mask;
+extern unsigned int yaffs_wr_attempts;
+
+/*
+ * Tracing flags.
+ * The flags masked in YAFFS_TRACE_ALWAYS are always traced.
+ */
+
+#define YAFFS_TRACE_OS			0x00000002
+#define YAFFS_TRACE_ALLOCATE		0x00000004
+#define YAFFS_TRACE_SCAN		0x00000008
+#define YAFFS_TRACE_BAD_BLOCKS		0x00000010
+#define YAFFS_TRACE_ERASE		0x00000020
+#define YAFFS_TRACE_GC			0x00000040
+#define YAFFS_TRACE_WRITE		0x00000080
+#define YAFFS_TRACE_TRACING		0x00000100
+#define YAFFS_TRACE_DELETION		0x00000200
+#define YAFFS_TRACE_BUFFERS		0x00000400
+#define YAFFS_TRACE_NANDACCESS		0x00000800
+#define YAFFS_TRACE_GC_DETAIL		0x00001000
+#define YAFFS_TRACE_SCAN_DEBUG		0x00002000
+#define YAFFS_TRACE_MTD			0x00004000
+#define YAFFS_TRACE_CHECKPOINT		0x00008000
+
+#define YAFFS_TRACE_VERIFY		0x00010000
+#define YAFFS_TRACE_VERIFY_NAND		0x00020000
+#define YAFFS_TRACE_VERIFY_FULL		0x00040000
+#define YAFFS_TRACE_VERIFY_ALL		0x000F0000
+
+#define YAFFS_TRACE_SYNC		0x00100000
+#define YAFFS_TRACE_BACKGROUND		0x00200000
+#define YAFFS_TRACE_LOCK		0x00400000
+
+#define YAFFS_TRACE_ERROR		0x40000000
+#define YAFFS_TRACE_BUG			0x80000000
+#define YAFFS_TRACE_ALWAYS		0xF0000000
+
+
+#define T(mask, p) do { if ((mask) & (yaffs_trace_mask | YAFFS_TRACE_ALWAYS)) TOUT(p); } while (0)
+
+#endif
-- 
1.7.3.2.146.gca209

