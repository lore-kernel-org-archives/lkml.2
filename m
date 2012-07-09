Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2GIMTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:19:01 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47841 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab2GIMS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:18:59 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 7/7] UBI: Fastmap: Make checkpatch.pl happy
Date: Mon,  9 Jul 2012 14:18:43 +0200
Message-Id: <1341836323-43916-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1341836323-43916-1-git-send-email-richard@nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 44b95ce..be73a1d 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -912,7 +912,8 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 	fm_size = ubi->leb_size * used_blocks;
 	if (fm_size != ubi->fm_size) {
-		ubi_err("bad fastmap size: %zi, expected: %zi", fm_size, ubi->fm_size);
+		ubi_err("bad fastmap size: %zi, expected: %zi", fm_size,
+			ubi->fm_size);
 		ret = UBI_BAD_FASTMAP;
 		kfree(fmsb);
 		kfree(fm);
-- 
1.7.6.5

