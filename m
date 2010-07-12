Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0GLUur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1747 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab0GLUuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:44 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/36] drivers/misc: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:04 -0700
Message-Id: <e4b196da6ea12a37aac25f120841f2fedea0ec81.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/misc/ibmasm/ibmasmfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index 8844a3f..8d650d6 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -517,7 +517,7 @@ static int remote_settings_file_close(struct inode *inode, struct file *file)
 
 static ssize_t remote_settings_file_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
-	void __iomem *address = (void __iomem *)file->private_data;
+	void __iomem *address = file->private_data;
 	unsigned char *page;
 	int retval;
 	int len = 0;
@@ -551,7 +551,7 @@ exit:
 
 static ssize_t remote_settings_file_write(struct file *file, const char __user *ubuff, size_t count, loff_t *offset)
 {
-	void __iomem *address = (void __iomem *)file->private_data;
+	void __iomem *address = file->private_data;
 	char *buff;
 	unsigned int value;
 
-- 
1.7.1.337.g6068.dirty

