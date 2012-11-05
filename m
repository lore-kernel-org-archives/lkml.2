Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2KEXOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:14:48 -0500
Received: from smtp.outflux.net ([198.145.64.163]:55083 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab2KEXFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:31 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 073/104] drivers/scsi: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:30 -0800
Message-Id: <1352156701-4038-74-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/Kconfig |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 74bf1aa..e2c33d3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -42,7 +42,7 @@ config SCSI_DMA
 
 config SCSI_TGT
 	tristate "SCSI target support"
-	depends on SCSI && EXPERIMENTAL
+	depends on SCSI
 	---help---
 	  If you want to use SCSI target mode drivers enable this option.
 	  If you choose M, the module will be called scsi_tgt.
@@ -1391,8 +1391,8 @@ config SCSI_SYM53C416
 	  module will be called sym53c416.
 
 config SCSI_DC395x
-	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support (EXPERIMENTAL)"
-	depends on PCI && SCSI && EXPERIMENTAL
+	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support"
+	depends on PCI && SCSI
 	---help---
 	  This driver supports PCI SCSI host adapters based on the ASIC
 	  TRM-S1040 chip, e.g Tekram DC395(U/UW/F) and DC315(U) variants.
@@ -1617,8 +1617,8 @@ config GVP11_SCSI
 	  module will be called gvp11.
 
 config SCSI_A4000T
-	tristate "A4000T NCR53c710 SCSI support (EXPERIMENTAL)"
-	depends on AMIGA && SCSI && EXPERIMENTAL
+	tristate "A4000T NCR53c710 SCSI support"
+	depends on AMIGA && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  If you have an Amiga 4000T and have SCSI devices connected to the
@@ -1628,8 +1628,8 @@ config SCSI_A4000T
 	  module will be called a4000t.
 
 config SCSI_ZORRO7XX
-	tristate "Zorro NCR53c710 SCSI support (EXPERIMENTAL)"
-	depends on ZORRO && SCSI && EXPERIMENTAL
+	tristate "Zorro NCR53c710 SCSI support"
+	depends on ZORRO && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  Support for various NCR53c710-based SCSI controllers on Zorro
@@ -1806,8 +1806,8 @@ config SCSI_BFA_FC
 	  be called bfa.
 
 config SCSI_VIRTIO
-	tristate "virtio-scsi support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && VIRTIO
+	tristate "virtio-scsi support"
+	depends on VIRTIO
 	help
           This is the virtual HBA driver for virtio.  If the kernel will
           be used in a virtual machine, say Y or M.
-- 
1.7.9.5

