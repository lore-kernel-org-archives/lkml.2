Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801Ab1FWWfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:35:42 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24396 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab1FWWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:35:24 -0400
Date: Fri, 24 Jun 2011 00:26:28 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jing Huang <huangj@brocade.com>, Robert Love <robert.w.love@intel.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        Kashyap Desai <kashyap.desai@lsi.com>, Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Xiangliang Yu <yuxiangl@marvell.com>
Subject: [PATCH 14/37] Remove unneeded version.h includes from
 drivers/scsi/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240021160.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/scsi/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/aacraid/src.c            |    1 -
 drivers/scsi/bfa/bfad_drv.h           |    1 -
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c    |    1 -
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c    |    1 -
 drivers/scsi/fcoe/fcoe.c              |    1 -
 drivers/scsi/mpt2sas/mpt2sas_base.c   |    1 -
 drivers/scsi/mpt2sas/mpt2sas_config.c |    1 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c    |    1 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |    1 -
 drivers/scsi/mvsas/mv_sas.h           |    1 -
 drivers/scsi/pmcraid.c                |    1 -
 drivers/scsi/pmcraid.h                |    1 -
 12 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index c204946..957595a 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -37,7 +37,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
-#include <linux/version.h>
 #include <linux/completion.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 7f9ea90..bcba182 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -27,7 +27,6 @@
 #define __BFAD_DRV_H__
 
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/idr.h>
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index fc2cdb6..93f9bb09 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -14,7 +14,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index f3a4cd7..8323c7b 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -13,7 +13,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 155d7b9..73e5457 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/spinlock.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index efa0255..f89d389 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index 6861244..2b11010 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -41,7 +41,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 437c2d9..c98dbc6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index a7dbc68..28e3f56 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -41,7 +41,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 1367d8b..d6fd740 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -43,7 +43,6 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
-#include <linux/version.h>
 #include "mv_defs.h"
 
 #define DRV_NAME		"mvsas"
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index fca6a89..ee161c6 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -39,7 +39,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/hdreg.h>
-#include <linux/version.h>
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <asm/irq.h>
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index f920baf..ca496c7 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -24,7 +24,6 @@
 #ifndef _PMCRAID_H
 #define _PMCRAID_H
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/completion.h>
 #include <linux/list.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

