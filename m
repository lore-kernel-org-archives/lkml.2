Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2LGBQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:16:27 -0500
Received: from mail.fuel7.com ([74.222.0.51]:43622 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab2LGBQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:16:26 -0500
From: Patrick Trantham <patrick.trantham@fuel7.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Patrick Trantham <patrick.trantham@fuel7.com>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Jiri Kosina <jkosina@suse.cz>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] net: phy: smsc: Fix config_init typo
Date: Thu,  6 Dec 2012 19:16:02 -0600
Message-Id: <1354842963-28464-1-git-send-email-patrick.trantham@fuel7.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct a mistake made in the previous commit due to reckless
copy-and-pasting.

Signed-off-by: Patrick Trantham <patrick.trantham@fuel7.com>
---
 drivers/net/phy/smsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 16dceed..eb3e08a 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -205,7 +205,7 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* basic functions */
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= lan87xx_read_status,
-	.config_intr	= smsc_phy_config_intr,
+	.config_init	= smsc_phy_config_init,
 
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
-- 
1.7.9.5

