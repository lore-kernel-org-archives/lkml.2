Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2GBQYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:24:20 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab2GBQXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:23:38 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/3] UBI: Fastmap: Export fm_auto to sysfs
Date: Mon,  2 Jul 2012 18:23:18 +0200
Message-Id: <1341246199-7198-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1341246199-7198-1-git-send-email-richard@nod.at>
References: <1341246199-7198-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/build.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 50b7590..0ffa2c9 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1394,7 +1394,7 @@ MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
 		      "with name \"content\" using VID header offset 1984, and "
 		      "MTD device number 4 with default VID header offset.");
 
-module_param(fm_auto, bool, 000);
+module_param(fm_auto, bool, 0644);
 MODULE_PARM_DESC(fm_auto, "Set this parameter to enable fastmap automatically "
 			  "on images without a fastmap.");
 
-- 
1.7.6.5

