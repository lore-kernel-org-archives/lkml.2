Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2FRQTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:19:44 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47846 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab2FRQTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:41 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 17/22] UBI: Fastmap: Add comments to new functions
Date: Mon, 18 Jun 2012 18:19:00 +0200
Message-Id: <1340036345-96726-18-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 7d36034..65fd7ee 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1266,6 +1266,11 @@ out:
 	return ret;
 }
 
+/**
+ * erase_block - Manually erase a PEB
+ * @ubi: UBI device object
+ * @pnum: PEB to be erased
+ */
 static int erase_block(struct ubi_device *ubi, int pnum)
 {
 	int ret;
@@ -1306,6 +1311,11 @@ out:
 	return ret;
 }
 
+/**
+ * invalidate_fastmap - destroys a fastmap
+ * @ubi: UBI device object
+ * @fm: the fastmap to be destroyed
+ */
 static int invalidate_fastmap(struct ubi_device *ubi,
 			      struct ubi_fastmap_layout *fm)
 {
-- 
1.7.6.5

