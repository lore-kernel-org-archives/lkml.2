Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0FAD1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:27:11 -0400
Received: from mail.perches.com ([173.55.12.10]:2473 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab0FADX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:28 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/21] drivers/isdn/capi/capidrv.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:09 -0700
Message-Id: <8df6f3fde6e8b9c8e7bf663a34bc9131efe42572.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/isdn/capi/capidrv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index bf55ed5..02e0182 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -469,8 +469,7 @@ static int capidrv_add_ack(struct capidrv_ncci *nccip,
 {
 	struct ncci_datahandle_queue *n, **pp;
 
-	n = (struct ncci_datahandle_queue *)
-		kmalloc(sizeof(struct ncci_datahandle_queue), GFP_ATOMIC);
+	n = kmalloc(sizeof(struct ncci_datahandle_queue), GFP_ATOMIC);
 	if (!n) {
 	   printk(KERN_ERR "capidrv: kmalloc ncci_datahandle failed\n");
 	   return -1;
-- 
1.7.0.3.311.g6a6955

