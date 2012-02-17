Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2BQOuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:50:32 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:13209 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2BQOua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:50:30 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org, ludovic.desroches@atmel.com
Cc: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MAINTAINERS: hand over atmel-mci (sd/mmc interface)
Date: Fri, 17 Feb 2012 15:49:59 +0100
Message-Id: <1329490199-18362-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <e3d27dde7a46fcd0e440e17e4a66469f6b22697f.1328801500.git.ludovic.desroches@atmel.com>
References: <e3d27dde7a46fcd0e440e17e4a66469f6b22697f.1328801500.git.ludovic.desroches@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify MAINTAINERS entry for Atmel SD/MMC drivers.
I hand the atmel-mci and at91_mci drivers over to Ludovic.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55ca0be..16c1b08 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1311,7 +1311,7 @@ F:	drivers/atm/
 F:	include/linux/atm*
 
 ATMEL AT91 MCI DRIVER
-M:	Nicolas Ferre <nicolas.ferre@atmel.com>
+M:	Ludovic Desroches <ludovic.desroches@atmel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
@@ -1319,7 +1319,7 @@ S:	Maintained
 F:	drivers/mmc/host/at91_mci.c
 
 ATMEL AT91 / AT32 MCI DRIVER
-M:	Nicolas Ferre <nicolas.ferre@atmel.com>
+M:	Ludovic Desroches <ludovic.desroches@atmel.com>
 S:	Maintained
 F:	drivers/mmc/host/atmel-mci.c
 F:	drivers/mmc/host/atmel-mci-regs.h
-- 
1.7.9

