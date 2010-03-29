Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0C2Rxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:53:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:41474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab0C2RxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:53:24 -0400
From: Tejun Heo <tj@kernel.org>
To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 11/17] mtd: update gfp/slab.h includes
Date: Tue, 30 Mar 2010 02:52:39 +0900
Message-Id: <1269885165-18617-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269885165-18617-1-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 17:52:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/mtdcore.c          |    1 +
 drivers/mtd/nand/mpc5121_nfc.c |    1 +
 drivers/mtd/nand/r852.c        |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index e8573c9..3c48193 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -17,6 +17,7 @@
 #include <linux/mtd/compatmac.h>
 #include <linux/proc_fs.h>
 #include <linux/idr.h>
+#include <linux/gfp.h>
 
 #include <linux/mtd/mtd.h>
 #include "internal.h"
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index d7333f4..1a06f78 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -27,6 +27,7 @@
 
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/gfp.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
index 96bfbd8..dd5158c 100644
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -15,6 +15,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <asm/byteorder.h>
 #include <linux/sched.h>
 #include "sm_common.h"
-- 
1.6.4.2

