Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0GLUuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1725 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab0GLUuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:35 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH 05/36] drivers/bluetooth: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:49:57 -0700
Message-Id: <2c766ab749f348012f0338eb41ec0b938a65044e.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/bluetooth/btmrvl_debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_debugfs.c b/drivers/bluetooth/btmrvl_debugfs.c
index b50b41d..54739b0 100644
--- a/drivers/bluetooth/btmrvl_debugfs.c
+++ b/drivers/bluetooth/btmrvl_debugfs.c
@@ -216,7 +216,7 @@ static const struct file_operations btmrvl_gpiogap_fops = {
 static ssize_t btmrvl_hscmd_write(struct file *file, const char __user *ubuf,
 						size_t count, loff_t *ppos)
 {
-	struct btmrvl_private *priv = (struct btmrvl_private *) file->private_data;
+	struct btmrvl_private *priv = file->private_data;
 	char buf[16];
 	long result, ret;
 
-- 
1.7.1.337.g6068.dirty

