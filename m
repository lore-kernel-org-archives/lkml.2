Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0FHDuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:50:52 -0400
Received: from mail.perches.com ([173.55.12.10]:2764 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab0FHDus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:48 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] drivers/isdn/capi/capidrv.c: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:37 -0700
Message-Id: <3af10f48d8b325c51c545615af5a0e030d7d4969.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
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
1.7.1.244.gbdc4

