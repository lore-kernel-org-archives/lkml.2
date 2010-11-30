Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab0K3Trt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:47:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35932 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab0K3TrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:47:21 -0500
From: David Sin <davidsin@ti.com>
To: Greg KH <greg@kroah.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Lajos Molnar <molnar@ti.com>, David Sin <davidsin@ti.com>
Subject: [RFC v2 8/8] TILER-DMM: Linking TILER driver into the Linux kernel build
Date: Tue, 30 Nov 2010 13:58:59 -0600
Message-Id: <1291147139-23472-9-git-send-email-davidsin@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1291147139-23472-1-git-send-email-davidsin@ti.com>
References: <1291147139-23472-1-git-send-email-davidsin@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lajos Molnar <molnar@ti.com>

This patch links the TILER driver into the Linux kernel build
and config system.

Signed-off-by: Lajos Molnar <molnar@ti.com>
Signed-off-by: David Sin <davidsin@ti.com>
---
 drivers/misc/Kconfig  |    5 +++++
 drivers/misc/Makefile |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index ac6d6ac..fff7927 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -378,4 +378,9 @@ source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
 source "drivers/misc/iwmc3200top/Kconfig"
 
+#
+# TI TILER driver support
+#
+source "drivers/misc/tiler/Kconfig"
+
 endif # MISC_DEVICES
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index bf6f0e0..9985a6f 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -33,3 +33,4 @@ obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
 obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
+obj-$(CONFIG_TI_TILER)		+= tiler/
-- 
1.7.0.4

