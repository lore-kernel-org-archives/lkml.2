Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491Ab2FUVuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:50:25 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760359Ab2FUVuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:22 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 02/15] UBI: Fastmap: Coding style fix...
Date: Thu, 21 Jun 2012 23:49:55 +0200
Message-Id: <1340315408-27375-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/eba.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 6698d5e..294ceb8 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1280,7 +1280,8 @@ int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
 					fm_eba[i][j] == UBI_LEB_UNMAPPED)
 					continue;
 
-				ubi_err("LEB:%i is mapped to PEB:%i instead of PEB:%i!", i, fm_eba[i][j], scan_eba[i][j]);
+				ubi_err("LEB:%i:%i is PEB:%i instead of %i!",
+					vol->vol_id, i, fm_eba[i][j], scan_eba[i][j]);
 				BUG();
 			}
 		}
-- 
1.7.6.5

