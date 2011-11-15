Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1KOLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:25:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59965 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab1KOLZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:25:56 -0500
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: ralf@linux-mips.org, juhosg@openwrt.org, rodrigue@qca.qualcomm.com,
        linville@tuxdriver.com, rmanohar@qca.qualcomm.com, patches@linaro.org,
        Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH] ath9k: rename ath9k_platform.h to ath_platform.h
Date: Tue, 15 Nov 2011 11:23:44 +0000
Message-Id: <1321356224-5053-1-git-send-email-sangwook.lee@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series proposes to rename ath9k_platform.h to "ath_platform.h
This header file handles platform data used only for ath9k,
but it can used by ath6k as well. We can take "wl12xx.h" as
as a example. Please let us change this file name so that
other Atheors WLANs use this file for their own platform data

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
 arch/mips/ath79/dev-ar913x-wmac.c                  |    2 +-
 drivers/net/wireless/ath/ath9k/ahb.c               |    2 +-
 drivers/net/wireless/ath/ath9k/init.c              |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    2 +-
 include/linux/{ath9k_platform.h => ath_platform.h} |    0
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename include/linux/{ath9k_platform.h => ath_platform.h} (100%)

diff --git a/arch/mips/ath79/dev-ar913x-wmac.c b/arch/mips/ath79/dev-ar913x-wmac.c
index 48f425a..bc8869c 100644
--- a/arch/mips/ath79/dev-ar913x-wmac.c
+++ b/arch/mips/ath79/dev-ar913x-wmac.c
@@ -13,7 +13,7 @@
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/platform_device.h>
-#include <linux/ath9k_platform.h>
+#include <linux/ath_platform.h>
 
 #include <asm/mach-ath79/ath79.h>
 #include <asm/mach-ath79/ar71xx_regs.h>
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 85a54cd..d84bee6 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -18,7 +18,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
-#include <linux/ath9k_platform.h>
+#include <linux/ath_platform.h>
 #include "ath9k.h"
 
 static const struct platform_device_id ath9k_platform_id_table[] = {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index af1b325..0c82aea 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -16,7 +16,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-#include <linux/ath9k_platform.h>
+#include <linux/ath_platform.h>
 
 #include "ath9k.h"
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index edb0b4b..2f031b8 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -17,7 +17,7 @@
 #include <linux/nl80211.h>
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
-#include <linux/ath9k_platform.h>
+#include <linux/ath_platform.h>
 #include "ath9k.h"
 
 static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath_platform.h
similarity index 100%
rename from include/linux/ath9k_platform.h
rename to include/linux/ath_platform.h
-- 
1.7.4.1

