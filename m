Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0FHDwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:52:10 -0400
Received: from mail.perches.com ([173.55.12.10]:2765 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab0FHDus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:48 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] drivers/message/i2o/i20_config.c: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:39 -0700
Message-Id: <e0677ac5caec66d2cb4c8029dc4eb966ec71322c.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/message/i2o/i2o_config.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index c4b117f..3be46c5 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -1041,8 +1041,7 @@ static long i2o_cfg_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 
 static int cfg_open(struct inode *inode, struct file *file)
 {
-	struct i2o_cfg_info *tmp =
-	    (struct i2o_cfg_info *)kmalloc(sizeof(struct i2o_cfg_info),
+	struct i2o_cfg_info *tmp = kmalloc(sizeof(struct i2o_cfg_info),
 					   GFP_KERNEL);
 	unsigned long flags;
 
-- 
1.7.1.244.gbdc4

