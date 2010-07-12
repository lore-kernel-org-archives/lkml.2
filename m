Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab0GLU4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:56:15 -0400
Received: from mail.perches.com ([173.55.12.10]:1745 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab0GLUuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:46 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 13/36] drivers/net/caif: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:05 -0700
Message-Id: <2fadd3261e91b96050bf8193efacee08842ef9eb.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/caif/caif_spi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/caif/caif_spi.c b/drivers/net/caif/caif_spi.c
index 03049e8..6c94803 100644
--- a/drivers/net/caif/caif_spi.c
+++ b/drivers/net/caif/caif_spi.c
@@ -134,7 +134,7 @@ static ssize_t dbgfs_state(struct file *file, char __user *user_buf,
 	char *buf;
 	int len = 0;
 	ssize_t size;
-	struct cfspi *cfspi = (struct cfspi *)file->private_data;
+	struct cfspi *cfspi = file->private_data;
 
 	buf = kzalloc(DEBUGFS_BUF_SIZE, GFP_KERNEL);
 	if (!buf)
@@ -205,7 +205,7 @@ static ssize_t dbgfs_frame(struct file *file, char __user *user_buf,
 	ssize_t size;
 	struct cfspi *cfspi;
 
-	cfspi = (struct cfspi *)file->private_data;
+	cfspi = file->private_data;
 	buf = kzalloc(DEBUGFS_BUF_SIZE, GFP_KERNEL);
 	if (!buf)
 		return 0;
-- 
1.7.1.337.g6068.dirty

