Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0FAD0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:26:38 -0400
Received: from mail.perches.com ([173.55.12.10]:2476 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0FADX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:29 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/21] drivers/message/i2o/i20_config.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:11 -0700
Message-Id: <339f43c45c6725e43faeefe6fa59a1996e15bcb1.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
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
1.7.0.3.311.g6a6955

