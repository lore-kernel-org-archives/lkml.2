Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539Ab2FUVub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:50:31 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47844 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765Ab2FUVu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:50:29 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 10/15] UBI: Fastmap: Remove unused variable Signed-off-by: Richard Weinberger <richard@nod.at>
Date: Thu, 21 Jun 2012 23:50:03 +0200
Message-Id: <1340315408-27375-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340315408-27375-1-git-send-email-richard@nod.at>
References: <UBI fastmap updates>
 <1340315408-27375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 7f65166..7cf4711 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1214,7 +1214,7 @@ out_ai:
  */
 int ubi_attach(struct ubi_device *ubi, int force_scan)
 {
-	int err, i;
+	int err;
 	struct ubi_attach_info *ai;
 
 	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
-- 
1.7.6.5

