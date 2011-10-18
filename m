Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab1JRNGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:06:01 -0400
Received: from sputnik.urmx.de ([88.198.51.18]:39343 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab1JRNGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:06:00 -0400
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, grant.likely@secretlab.ca,
        Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH] net: Fix driver name for mdio-gpio.c
Date: Tue, 18 Oct 2011 15:04:11 +0200
Message-Id: <1318943051-22432-1-git-send-email-eibach@gdsys.de>
X-SafeGuard_MailGateway: Version: 5.60.3.11066 SGMG Date: 20111018130010Z
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.6.84; VDF: 7.11.16.49; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit
"7488876... dt/net: Eliminate users of of_platform_{,un}register_driver"
there are two platform drivers named "mdio-gpio" registered.
I renamed the of variant to "mdio-ofgpio".

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
 drivers/net/phy/mdio-gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index f2d122f..3d66d9f 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -241,7 +241,7 @@ MODULE_DEVICE_TABLE(of, mdio_ofgpio_match);
 
 static struct platform_driver mdio_ofgpio_driver = {
 	.driver = {
-		.name = "mdio-gpio",
+		.name = "mdio-ofgpio",
 		.owner = THIS_MODULE,
 		.of_match_table = mdio_ofgpio_match,
 	},
-- 
1.5.6.5

