Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2GIMUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:20:22 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47839 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab2GIMS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:18:57 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/7] UBI: Fastmap: Kerneldoc fixes
Date: Mon,  9 Jul 2012 14:18:41 +0200
Message-Id: <1341836323-43916-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1341836323-43916-1-git-send-email-richard@nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |    3 +++
 drivers/mtd/ubi/ubi.h    |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 85c9e0c..14d2580 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -810,6 +810,8 @@ out_unlock:
  * @ubi: UBI device description object
  * @ai: attaching information
  * @pnum: the physical eraseblock number
+ * @vid: The volume ID of the found volume will be stored in this pointer
+ * @sqnum: The sqnum of the found volume will be stored in this pointer
  *
  * This function reads UBI headers of PEB @pnum, checks them, and adds
  * information about this PEB to the corresponding list or RB-tree in the
@@ -1223,6 +1225,7 @@ static void destroy_ai(struct ubi_attach_info *ai)
  * scan_all - scan entire MTD device.
  * @ubi: UBI device description object
  * @ai: attach info object
+ * @start: start scanning at this PEB
  *
  * This function does full scanning of an MTD device and returns complete
  * information about it in form of a "struct ubi_attach_info" object. In case
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 56e6be0..a25d59a 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -218,7 +218,7 @@ struct ubi_volume_desc;
  * @to_be_tortured: if non-zero tortured this PEB
  * @used_blocks: number of used PEBs
  * @max_pool_size: maximal size of the user pool
- * @max_wl_pool_size: maximal size of the pooly used by the WL sub-system
+ * @max_wl_pool_size: maximal size of the pool used by the WL sub-system
  */
 struct ubi_fastmap_layout {
 	struct ubi_wl_entry *e[UBI_FM_MAX_BLOCKS];
-- 
1.7.6.5

