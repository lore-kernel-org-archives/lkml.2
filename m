Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032Ab1CXT2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:28:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53790 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020Ab1CXT15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r6DDpCBenwIl5belSPuQKbMR/3DXo/UnJTdIm7CL4zzB62vgFpQ/VG2KXr6V5jBUuB
         F2ADPXwNyMLdaASiCKwBrzRfObVIe5+oC38U+ZDTAUZtLbRLnqSM93cZmwsxUGM2E3u4
         xjKZHFCw5m9rrEsKID4pfIZulX6AYAZ9F9geg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 15/21]drivers:target Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:53 -0700
Message-Id: <1300994819-30930-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/target/target_core_alua.c      |    4 ++--
 drivers/target/target_core_transport.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 2c5fcfe..e7dddaf 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1036,7 +1036,7 @@ core_alua_allocate_lu_gp(const char *name, int def_group)
 	lu_gp = kmem_cache_zalloc(t10_alua_lu_gp_cache, GFP_KERNEL);
 	if (!(lu_gp)) {
 		printk(KERN_ERR "Unable to allocate struct t10_alua_lu_gp\n");
-		return ERR_PTR(-ENOMEM);;
+		return ERR_PTR(-ENOMEM);
 	}
 	INIT_LIST_HEAD(&lu_gp->lu_gp_list);
 	INIT_LIST_HEAD(&lu_gp->lu_gp_mem_list);
@@ -1044,7 +1044,7 @@ core_alua_allocate_lu_gp(const char *name, int def_group)
 	atomic_set(&lu_gp->lu_gp_ref_cnt, 0);
 
 	if (def_group) {
-		lu_gp->lu_gp_id = se_global->alua_lu_gps_counter++;;
+		lu_gp->lu_gp_id = se_global->alua_lu_gps_counter++;
 		lu_gp->lu_gp_valid_id = 1;
 		se_global->alua_lu_gps_count++;
 	}
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ff9ace0..39ac190 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2131,7 +2131,7 @@ static void transport_failure_reset_queue_depth(struct se_device *dev)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&SE_HBA(dev)->hba_queue_lock, flags);;
+	spin_lock_irqsave(&SE_HBA(dev)->hba_queue_lock, flags);
 	atomic_inc(&dev->depth_left);
 	atomic_inc(&SE_HBA(dev)->left_queue_depth);
 	spin_unlock_irqrestore(&SE_HBA(dev)->hba_queue_lock, flags);
-- 
1.7.4.1

