Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab1BKWPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:15:16 -0500
Received: from mail131.messagelabs.com ([216.82.242.99]:15752 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab1BKWPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:15:14 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1297462496!13899671!5
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] phy: Remove unneeded depends on PHYLIB
Date: Fri, 11 Feb 2011 15:14:06 -0700
User-Agent: KMail/1.9.9
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201102111514.06971.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded depends on PHYLIB.  The config selection is already in
an if PHYLIB / endif block.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "David S. Miller" <davem@davemloft.net>

---

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 35fda5a..392a6c4 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -77,7 +77,6 @@ config NATIONAL_PHY
 	  Currently supports the DP83865 PHY.
 
 config STE10XP
-	depends on PHYLIB
 	tristate "Driver for STMicroelectronics STe10Xp PHYs"
 	---help---
 	  This is the driver for the STe100p and STe101p PHYs.
