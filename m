Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2LFXTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 18:19:17 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62670 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2LFXTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 18:19:16 -0500
From: Cong Ding <dinggnu@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Patrick Trantham <patrick.trantham@fuel7.com>,
        Jiri Kosina <jkosina@suse.cz>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] fix initializer entry defined twice issue
Date: Thu,  6 Dec 2012 23:16:07 +0000
Message-Id: <1354835928-617-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the ".config_intr" is defined twice in both line 208 and 212.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/net/phy/smsc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 16dceed..5cee6bd 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -205,7 +205,6 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* basic functions */
 	.config_aneg	= genphy_config_aneg,
 	.read_status	= lan87xx_read_status,
-	.config_intr	= smsc_phy_config_intr,
 
 	/* IRQ related */
 	.ack_interrupt	= smsc_phy_ack_interrupt,
-- 
1.7.4.5

