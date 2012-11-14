Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422640Ab2KNLVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:21:25 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57009 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161052Ab2KNLVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:21:23 -0500
From: Johan Hovold <jhovold@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] ARM: at91/ide: remove unsused at91-ide Kconfig entry
Date: Wed, 14 Nov 2012 12:20:34 +0100
Message-Id: <1352892034-18871-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cf844751fb25e ("ARM: at91: drop ide driver in favor of the pata
one") removed the at91-ide driver but did not remove the Kconfig entry.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/ide/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 5a26584..bfec4e6 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -702,11 +702,6 @@ config BLK_DEV_IDE_TX4939
 	depends on SOC_TX4939
 	select BLK_DEV_IDEDMA_SFF
 
-config BLK_DEV_IDE_AT91
-	tristate "Atmel AT91 (SAM9, CAP9, AT572D940HF) IDE support"
-	depends on ARM && ARCH_AT91 && !ARCH_AT91RM9200 && !ARCH_AT91X40
-	select IDE_TIMINGS
-
 config BLK_DEV_IDE_ICSIDE
 	tristate "ICS IDE interface support"
 	depends on ARM && ARCH_ACORN
-- 
1.8.0

