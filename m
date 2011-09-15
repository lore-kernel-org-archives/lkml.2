Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934864Ab1IOUNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:13:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:46846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934737Ab1IOUKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873438"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, dougthompson@xmission.com
Subject: [PATCH 11/27] Initconst section fixes for EDAC
Date: Thu, 15 Sep 2011 13:09:38 -0700
Message-Id: <1316117394-21666-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: dougthompson@xmission.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/edac/amd64_edac.c      |    2 +-
 drivers/edac/amd76x_edac.c     |    2 +-
 drivers/edac/e752x_edac.c      |    2 +-
 drivers/edac/e7xxx_edac.c      |    2 +-
 drivers/edac/i3000_edac.c      |    2 +-
 drivers/edac/i3200_edac.c      |    2 +-
 drivers/edac/i5000_edac.c      |    2 +-
 drivers/edac/i5100_edac.c      |    2 +-
 drivers/edac/i5400_edac.c      |    2 +-
 drivers/edac/i7300_edac.c      |    2 +-
 drivers/edac/i7core_edac.c     |    2 +-
 drivers/edac/i82443bxgx_edac.c |    2 +-
 drivers/edac/i82860_edac.c     |    2 +-
 drivers/edac/i82875p_edac.c    |    2 +-
 drivers/edac/i82975x_edac.c    |    2 +-
 drivers/edac/r82600_edac.c     |    2 +-
 drivers/edac/x38_edac.c        |    2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9a8bebc..b1e4989 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2670,7 +2670,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
  * PCI core identifies what devices are on a system during boot, and then
  * inquiry this table to see if this driver is for a given device found.
  */
-static const struct pci_device_id amd64_pci_table[] __devinitdata = {
+static const struct pci_device_id amd64_pci_table[] __devinitconst = {
 	{
 		.vendor		= PCI_VENDOR_ID_AMD,
 		.device		= PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index e47e73b..348e0bd 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -321,7 +321,7 @@ static void __devexit amd76x_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id amd76x_pci_tbl[] __devinitdata = {
+static const struct pci_device_id amd76x_pci_tbl[] __devinitconst = {
 	{
 	 PCI_VEND_DEV(AMD, FE_GATE_700C), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 AMD762},
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index 1af531a..3a8ff27 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1380,7 +1380,7 @@ static void __devexit e752x_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id e752x_pci_tbl[] __devinitdata = {
+static const struct pci_device_id e752x_pci_tbl[] __devinitconst = {
 	{
 	 PCI_VEND_DEV(INTEL, 7520_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 E7520},
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 6ffb6d2..383d8d7 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -525,7 +525,7 @@ static void __devexit e7xxx_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id e7xxx_pci_tbl[] __devinitdata = {
+static const struct pci_device_id e7xxx_pci_tbl[] __devinitconst = {
 	{
 	 PCI_VEND_DEV(INTEL, 7205_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 E7205},
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index c0510b3..6e2a954 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -470,7 +470,7 @@ static void __devexit i3000_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i3000_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i3000_pci_tbl[] __devinitconst = {
 	{
 	 PCI_VEND_DEV(INTEL, 3000_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 I3000},
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index aa08497..7e6822a 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -456,7 +456,7 @@ static void __devexit i3200_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i3200_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i3200_pci_tbl[] __devinitconst = {
 	{
 		PCI_VEND_DEV(INTEL, 3200_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		I3200},
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 4dc3ac2..67d05a6 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1516,7 +1516,7 @@ static void __devexit i5000_remove_one(struct pci_dev *pdev)
  *
  *	The "E500P" device is the first device supported.
  */
-static const struct pci_device_id i5000_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i5000_pci_tbl[] __devinitconst = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_I5000_DEV16),
 	 .driver_data = I5000P},
 
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index bcbdeec..9886d16 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -1051,7 +1051,7 @@ static void __devexit i5100_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i5100_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i5100_pci_tbl[] __devinitconst = {
 	/* Device 16, Function 0, Channel 0 Memory Map, Error Flag/Mask, ... */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5100_16) },
 	{ 0, }
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 74d6ec3..baff517 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1383,7 +1383,7 @@ static void __devexit i5400_remove_one(struct pci_dev *pdev)
  *
  *	The "E500P" device is the first device supported.
  */
-static const struct pci_device_id i5400_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i5400_pci_tbl[] __devinitconst = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR)},
 	{0,}			/* 0 terminated list. */
 };
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index a76fe83..15479e6 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -1191,7 +1191,7 @@ static void __devexit i7300_remove_one(struct pci_dev *pdev)
  *
  * Has only 8086:360c PCI ID
  */
-static const struct pci_device_id i7300_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i7300_pci_tbl[] __devinitconst = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_I7300_MCH_ERR)},
 	{0,}			/* 0 terminated list. */
 };
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index f6cf448..3f612e9 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -359,7 +359,7 @@ static const struct pci_id_table pci_dev_table[] = {
 /*
  *	pci_device_id	table for which devices we are looking for
  */
-static const struct pci_device_id i7core_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i7core_pci_tbl[] __devinitconst = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_X58_HUB_MGMT)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNNFIELD_QPI_LINK0)},
 	{0,}			/* 0 terminated list. */
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 4329d39..f3022ef 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -380,7 +380,7 @@ static void __devexit i82443bxgx_edacmc_remove_one(struct pci_dev *pdev)
 
 EXPORT_SYMBOL_GPL(i82443bxgx_edacmc_remove_one);
 
-static const struct pci_device_id i82443bxgx_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i82443bxgx_pci_tbl[] __devinitconst = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443BX_0)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443BX_2)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443GX_0)},
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index 931a057..fd28340 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -270,7 +270,7 @@ static void __devexit i82860_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i82860_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i82860_pci_tbl[] __devinitconst = {
 	{
 	 PCI_VEND_DEV(INTEL, 82860_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 I82860},
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 33864c6..01edc61 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -511,7 +511,7 @@ static void __devexit i82875p_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i82875p_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i82875p_pci_tbl[] __devinitconst = {
 	{
 	 PCI_VEND_DEV(INTEL, 82875_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 I82875P},
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index a5da732..983363b 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -604,7 +604,7 @@ static void __devexit i82975x_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id i82975x_pci_tbl[] __devinitdata = {
+static const struct pci_device_id i82975x_pci_tbl[] __devinitconst = {
 	{
 		PCI_VEND_DEV(INTEL, 82975_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		I82975X
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index b153674..ad2ba9b 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -373,7 +373,7 @@ static void __devexit r82600_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id r82600_pci_tbl[] __devinitdata = {
+static const struct pci_device_id r82600_pci_tbl[] __devinitconst = {
 	{
 	 PCI_DEVICE(PCI_VENDOR_ID_RADISYS, R82600_BRIDGE_ID)
 	 },
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index b6f47de..c5acf3a 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -440,7 +440,7 @@ static void __devexit x38_remove_one(struct pci_dev *pdev)
 	edac_mc_free(mci);
 }
 
-static const struct pci_device_id x38_pci_tbl[] __devinitdata = {
+static const struct pci_device_id x38_pci_tbl[] __devinitconst = {
 	{
 	 PCI_VEND_DEV(INTEL, X38_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 X38},
-- 
1.7.4.4

