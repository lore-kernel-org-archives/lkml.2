Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2FRQTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:19:40 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab2FRQTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:19:35 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 10/22] UBI: Fastmap: Remove more useless new lines
Date: Mon, 18 Jun 2012 18:18:53 +0200
Message-Id: <1340036345-96726-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340036345-96726-1-git-send-email-richard@nod.at>
References: <1340036345-96726-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index caefcb3..8aa43e8 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1272,7 +1272,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 			if (!ec_hdr) {
 				ret = -ENOMEM;
-
 				goto err;
 			}
 
@@ -1282,7 +1281,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			if (ret && ret != UBI_IO_BITFLIPS) {
 				ubi_err("unable to read EC header");
 				kfree(ec_hdr);
-
 				goto err;
 			}
 
@@ -1291,7 +1289,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			if (ret < 0) {
 				ubi_err("unable to erase old SB");
 				kfree(ec_hdr);
-
 				goto err;
 			}
 
@@ -1301,7 +1298,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 				ubi_err("erase counter overflow!");
 				kfree(ec_hdr);
 				ret = -EINVAL;
-
 				goto err;
 			}
 
@@ -1311,7 +1307,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			kfree(ec_hdr);
 			if (ret) {
 				ubi_err("unable to write new EC header");
-
 				goto err;
 			}
 
@@ -1334,7 +1329,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		if (!tmp_e) {
 			ubi_err("could not find an early PEB");
 			ret = -ENOSPC;
-
 			goto err;
 		}
 
@@ -1345,7 +1339,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	if (new_fm->used_blocks > UBI_FM_MAX_BLOCKS) {
 		ubi_err("fastmap too large");
 		ret = -ENOSPC;
-
 		goto err;
 	}
 
@@ -1365,7 +1358,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 				kfree(new_fm->e[i]);
 			}
 			ret = -ENOSPC;
-
 			goto err;
 		}
 
-- 
1.7.6.5

