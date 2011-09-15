Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859Ab1IOUMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:12:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:61479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934752Ab1IOUKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="48899370"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, JBottomley@parallels.com
Subject: [PATCH 20/27] Initconst section fixes for SCSI
Date: Thu, 15 Sep 2011 13:09:47 -0700
Message-Id: <1316117394-21666-21-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: JBottomley@parallels.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/scsi/aacraid/linit.c        |    2 +-
 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3382475..9c8d000 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -92,7 +92,7 @@ static DECLARE_PCI_DEVICE_TABLE(aac_pci_tbl) = {
 #elif defined(__devinitconst)
 static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
 #else
-static const struct pci_device_id aac_pci_tbl[] __devinitdata = {
+static const struct pci_device_id aac_pci_tbl[] __devinitconst = {
 #endif
 	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si (Iguana/PERC2Si) */
 	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di (Opal/PERC3Di) */
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index d5ff142..49c0ebb 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -1012,7 +1012,7 @@ static struct sas_domain_function_template aic94xx_transport_functions = {
 	.lldd_control_phy	= asd_control_phy,
 };
 
-static const struct pci_device_id aic94xx_pci_table[] __devinitdata = {
+static const struct pci_device_id aic94xx_pci_table[] __devinitconst = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x410),0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x412),0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x416),0, 0, 1},
-- 
1.7.4.4

