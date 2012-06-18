Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2FRQVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:21:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47845 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab2FRQTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:40 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 16/22] UBI: Fastmap: Fix loglevel
Date: Mon, 18 Jun 2012 18:18:59 +0200
Message-Id: <1340036345-96726-17-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index eec3940..be847d4 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -799,7 +799,7 @@ static int do_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 {
 	struct ubi_work *wl_wrk;
 
-	ubi_msg("sync erase of PEB %i", e->pnum);
+	dbg_wl("sync erase of PEB %i", e->pnum);
 
 	wl_wrk = kmalloc(sizeof(struct ubi_work), GFP_NOFS);
 	if (!wl_wrk)
-- 
1.7.6.5

