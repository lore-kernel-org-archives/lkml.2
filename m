Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab1C3JT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:19:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51193 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932148Ab1C3JT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:19:26 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 11/18] gma500: Add Moorestown identifiers
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:00:43 +0100
Message-ID: <20110330090037.5897.30398.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn it on, turn it up, turn it loose

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c |    8 ++++++++
 drivers/staging/gma500/psb_drv.h |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 878b603..b9256e3 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -62,6 +62,14 @@ module_param_named(rtpm, gfxrtdelay, int, 0600);
 static struct pci_device_id pciidlist[] = {
 	{ 0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108 },
 	{ 0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109 },
+	{ 0x8086, 0x4100, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
+	{ 0x8086, 0x4101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
+	{ 0x8086, 0x4102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
+	{ 0x8086, 0x4103, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
+	{ 0x8086, 0x4104, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
+	{ 0x8086, 0x4105, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
+	{ 0x8086, 0x4106, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
+	{ 0x8086, 0x4107, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
 	{ 0, 0, 0}
 };
 MODULE_DEVICE_TABLE(pci, pciidlist);
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index b4a8f02..dbb3fbb 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -43,6 +43,7 @@ extern struct ttm_bo_driver psb_ttm_bo_driver;
 enum {
 	CHIP_PSB_8108 = 0,
 	CHIP_PSB_8109 = 1,
+	CHIP_MRST_4100 = 2,
 };
 
 #define IS_MRST(dev) (((dev)->pci_device & 0xfffc) == 0x4100)

