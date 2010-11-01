Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0KASmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:42:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64991 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab0KASmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:42:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pDkkmS+jwanhCcpXV8Yy5byp1bkBst9jjkjDhYBQPhIjOMI1YbTBoVN1ei6TipRbwB
         82BJjMCTsRIq38UnqhB3VMlHnhamL94AapmlvL1qz+C7m4KcSBTQhDvC8cIm7xeWWYDZ
         Vj8AznZAux5GiUmwuEth+4PqrsG7pD9TsHp8k=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 22/29] Staging: yaffs2: yaffs_tagsvalidity: Add files
Date: Mon,  1 Nov 2010 14:41:10 -0400
Message-Id: <1288636877-7964-23-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_tagsvalidity.c |   28 +++++++++++++++++++++++++++
 drivers/staging/yaffs2/yaffs_tagsvalidity.h |   24 +++++++++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_tagsvalidity.c
 create mode 100644 drivers/staging/yaffs2/yaffs_tagsvalidity.h

diff --git a/drivers/staging/yaffs2/yaffs_tagsvalidity.c b/drivers/staging/yaffs2/yaffs_tagsvalidity.c
new file mode 100644
index 0000000..787cdba
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_tagsvalidity.c
@@ -0,0 +1,28 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yaffs_tagsvalidity.h"
+
+void yaffs_init_tags(yaffs_ext_tags *tags)
+{
+	memset(tags, 0, sizeof(yaffs_ext_tags));
+	tags->validity1 = 0xAAAAAAAA;
+	tags->validty1 = 0x55555555;
+}
+
+int yaffs_validate_tags(yaffs_ext_tags *tags)
+{
+	return (tags->validity1 == 0xAAAAAAAA &&
+		tags->validty1 == 0x55555555);
+
+}
diff --git a/drivers/staging/yaffs2/yaffs_tagsvalidity.h b/drivers/staging/yaffs2/yaffs_tagsvalidity.h
new file mode 100644
index 0000000..085056c
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_tagsvalidity.h
@@ -0,0 +1,24 @@
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
+#ifndef __YAFFS_TAGS_VALIDITY_H__
+#define __YAFFS_TAGS_VALIDITY_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_init_tags(yaffs_ext_tags *tags);
+int yaffs_validate_tags(yaffs_ext_tags *tags);
+#endif
-- 
1.7.3.2.146.gca209

