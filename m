Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2GBQXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:23:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab2GBQXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:23:37 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/3] UBI: Fastmap: Document return codes.
Date: Mon,  2 Jul 2012 18:23:17 +0200
Message-Id: <1341246199-7198-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1341246199-7198-1-git-send-email-richard@nod.at>
References: <1341246199-7198-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index a343a41..106aa01 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1305,6 +1305,11 @@ out_ech:
  * scan_fastmap - try to find a fastmap and attach from it.
  * @ubi: UBI device description object
  * @ai: attach info object
+ *
+ * Returns 0 on success, negative return values indicate an internal
+ * error.
+ * UBI_NO_FASTMAP denotes that no fastmap was found.
+ * UBI_BAD_FASTMAP denotes that the found fastmap was invalid.
  */
 static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info *ai)
 {
-- 
1.7.6.5

