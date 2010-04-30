Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0D3UvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:51:10 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:37632 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab0D3UtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:49:18 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, r.herring@freescale.com,
       Jun.Li@freescale.com, xiao-lizhang@freescale.com,
       Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv10 2.6.34-rc6 5/5] mx5: Add USB to Freescale MX51 defconfig
Date: Fri, 30 Apr 2010 15:48:27 -0500
Message-Id: <1272660507-5917-5-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272660507-5917-4-git-send-email-Dinh.Nguyen@freescale.com>
References: <1272660507-5917-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1272660507-5917-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1272660507-5917-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1272660507-5917-4-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Update mx51_defconfig to include USB EHCI by default.

This patch applies to 2.6.34-rc6.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/configs/mx51_defconfig |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/mx51_defconfig b/arch/arm/configs/mx51_defconfig
index c88e952..a708fd6 100644
--- a/arch/arm/configs/mx51_defconfig
+++ b/arch/arm/configs/mx51_defconfig
@@ -809,7 +809,22 @@ CONFIG_SSB_POSSIBLE=y
 CONFIG_DUMMY_CONSOLE=y
 # CONFIG_SOUND is not set
 # CONFIG_HID_SUPPORT is not set
-# CONFIG_USB_SUPPORT is not set
+CONFIG_USB_SUPPORT=y
+CONFIG_USB_ARCH_HAS_HCD=y
+# CONFIG_USB_ARCH_HAS_OHCI is not set
+CONFIG_USB_ARCH_HAS_EHCI=y
+CONFIG_USB=y
+
+#
+# USB Host Controller Drivers
+#
+# CONFIG_USB_C67X00_HCD is not set
+CONFIG_USB_EHCI_HCD=y
+CONFIG_USB_EHCI_ROOT_HUB_TT=y
+# CONFIG_USB_EHCI_TT_NEWSCHED is not set
+CONFIG_USB_EHCI_MXC=y
+
+
 CONFIG_MMC=y
 # CONFIG_MMC_DEBUG is not set
 # CONFIG_MMC_UNSAFE_RESUME is not set
-- 
1.6.0.4

