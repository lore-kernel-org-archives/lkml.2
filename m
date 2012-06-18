Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2FRQX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:23:29 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47841 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab2FRQTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:33 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 07/22] UBI: Fastmap: Fix build (a left over from the ai->fm removal)
Date: Mon, 18 Jun 2012 18:18:50 +0200
Message-Id: <1340036345-96726-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 369e07f..4d9384b 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1727,8 +1727,8 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 	dbg_wl("found %i PEBs", found_pebs);
 
-	if (ai->fm)
-		ubi_assert(ubi->peb_count == found_pebs + ai->fm->used_blocks);
+	if (ubi->fm)
+		ubi_assert(ubi->peb_count == found_pebs + ubi->fm->used_blocks);
 	else
 		ubi_assert(ubi->peb_count == found_pebs);
 
-- 
1.7.6.5

