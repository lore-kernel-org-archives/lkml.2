Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3AJQwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:52:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50936 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab3AJQwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:52:17 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 14/14] ARM: OMAP2+: omap4panda: Remove irrelevant USB host platform data
Date: Thu, 10 Jan 2013 18:51:34 +0200
Message-ID: <1357836694-30788-15-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These platform data bits are no longer used so remove them.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap4panda.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index fd2f907..cde7316 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -220,12 +220,6 @@ static struct usbhs_phy_config phy_config0 = {
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
-	.phy_reset  = false,
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL,
 	.phy_config[0] = &phy_config0,
 };
 
-- 
1.7.4.1

