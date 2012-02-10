Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab2BJNjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:39:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42046 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab2BJNio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:38:44 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/6] sep: Add new PCI identifier
To: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Date: Fri, 10 Feb 2012 13:52:27 +0000
Message-ID: <20120210135225.12442.88492.stgit@bob.linux.org.uk>
In-Reply-To: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
References: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark A. Allyn <mark.a.allyn@intel.com>

[This is picked out of the differences between the upstream driver and
 the staging driver. I'm resolving the differences as a series of updates -AC]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver_hw_defs.h |    3 ---
 drivers/staging/sep/sep_main.c           |    5 +++--
 2 files changed, 3 insertions(+), 5 deletions(-)


diff --git a/drivers/staging/sep/sep_driver_hw_defs.h b/drivers/staging/sep/sep_driver_hw_defs.h
index c48e49a..a6a4481 100644
--- a/drivers/staging/sep/sep_driver_hw_defs.h
+++ b/drivers/staging/sep/sep_driver_hw_defs.h
@@ -33,9 +33,6 @@
 #ifndef SEP_DRIVER_HW_DEFS__H
 #define SEP_DRIVER_HW_DEFS__H
 
-/* PCI ID's */
-#define MFLD_PCI_DEVICE_ID 0x0826
-
 /*----------------------- */
 /* HW Registers Defines.  */
 /*                        */
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 7f8362c..421a2b1 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -4085,8 +4085,9 @@ static void sep_remove(struct pci_dev *pdev)
 
 /* Initialize struct pci_device_id for our driver */
 static DEFINE_PCI_DEVICE_TABLE(sep_pci_id_tbl) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MFLD_PCI_DEVICE_ID)},
-	{0}
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0826)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08e9)},
+ 	{0}
 };
 
 /* Export our pci_device_id structure to user space */

