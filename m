Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2IYAC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 20:02:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59704 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2IYAC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 20:02:56 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] ARM: dove: Fix clock names of sata and gbe
Date: Tue, 25 Sep 2012 02:02:15 +0200
Message-Id: <1348531338-16624-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes wrong clock names of lately added clock gates
for sata and gbe (mv64xx_eth).

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-dove/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 343a4bc..ffec26f 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -110,8 +110,8 @@ static void __init dove_clk_init(void)
 
 	orion_clkdev_add(NULL, "orion-ehci.0", usb0);
 	orion_clkdev_add(NULL, "orion-ehci.1", usb1);
-	orion_clkdev_add(NULL, "mv643xx_eth.0", ge);
-	orion_clkdev_add("0", "sata_mv.0", sata);
+	orion_clkdev_add(NULL, "mv643xx_eth_port.0", ge);
+	orion_clkdev_add(NULL, "sata_mv.0", sata);
 	orion_clkdev_add("0", "pcie", pex0);
 	orion_clkdev_add("1", "pcie", pex1);
 	orion_clkdev_add(NULL, "sdhci-dove.0", sdio0);
-- 
1.7.10.4

