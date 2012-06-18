Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2FRQWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:22:03 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47838 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab2FRQTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:39 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 14/22] UBI: Fastmap: Fix copy&paste error
Date: Mon, 18 Jun 2012 18:18:57 +0200
Message-Id: <1340036345-96726-15-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index b4f7fce..f9e5dbb 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1403,7 +1403,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		tmp_e = ubi_wl_get_fm_peb(ubi, -1);
 		spin_unlock(&ubi->wl_lock);
 
-		if (!new_fm->e[i]) {
+		if (!tmp_e) {
 			ubi_err("could not get any free erase block");
 
 			while (i--) {
-- 
1.7.6.5

