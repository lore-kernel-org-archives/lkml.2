Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2GHQ3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 12:29:34 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:36929 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab2GHQ3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 12:29:33 -0400
From: Philippe Reynes <tremyfr@yahoo.fr>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        Philippe Reynes <tremyfr@yahoo.fr>
Subject: [PATCH] Add nand platform on imx27 devicetree
Date: Sun,  8 Jul 2012 18:29:23 +0200
Message-Id: <1341764963-11402-1-git-send-email-tremyfr@yahoo.fr>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
---
 arch/arm/mach-imx/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index eff4db5..565422b 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -381,6 +381,7 @@ config MACH_IMX27_DT
 	bool "Support i.MX27 platforms from device tree"
 	select SOC_IMX27
 	select USE_OF
+	select IMX_HAVE_PLATFORM_MXC_NAND
 	help
 	  Include support for Freescale i.MX27 based platforms
 	  using the device tree for discovery
-- 
1.7.1

