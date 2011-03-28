Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1C1QaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37936 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1C1QaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f8xlA0hp67pnZuSY35QNFJ5uZW9J9uGu3p0UFmEEuKY0u6i+6ybcWKu/Uf8sk8bmvt
         CG2QUoLNK6frBQEW6lmzYJr3KUkBQSEk3jBKKFRq7pOAMP4WZ5Cbf2eegDXwm80OeCNX
         w+WoRy3RiQIZsu4dQ86Y1DIT5860XjShH5XNs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 08/25]drivers:scsi Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:31 -0700
Message-Id: <1301329788-3423-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/aacraid/src.c            |    1 -
 drivers/scsi/bfa/bfad_drv.h           |    1 -
 drivers/scsi/fcoe/fcoe.c              |    1 -
 drivers/scsi/gdth.c                   |    1 -
 drivers/scsi/mpt2sas/mpt2sas_base.c   |    1 -
 drivers/scsi/mpt2sas/mpt2sas_config.c |    1 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c    |    1 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |    1 -
 drivers/scsi/mvsas/mv_sas.h           |    1 -
 drivers/scsi/pmcraid.c                |    1 -
 drivers/scsi/pmcraid.h                |    1 -
 11 files changed, 0 insertions(+), 11 deletions(-)

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
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index bde6ee5..f9324a9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/spinlock.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3242bca..ef4ab7b 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -105,7 +105,6 @@
 
 #include <linux/module.h>
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 5e001ff..60bade0 100644
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
index 6afd67b..68690b5 100644
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
index e92b77a..cda4f85 100644
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
index 6ceb775..ee7dc19 100644
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
index 77ddc7c..cb2038e 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -42,7 +42,6 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
-#include <linux/version.h>
 #include "mv_defs.h"
 
 #define DRV_NAME		"mvsas"
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bcf858e..871f375 100644
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
index 4db210d..7fbe6a1 100644
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
1.7.4.1

