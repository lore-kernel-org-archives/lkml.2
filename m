Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2IRQgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:36:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40500 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2IRQg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:36:29 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: kernel@pengutronix.de
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] arch/arm/plat-mxc/ulpi.c: Remove unecessary semicolon
Date: Tue, 18 Sep 2012 18:36:12 +0200
Message-Id: <1347986174-30287-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347986174-30287-1-git-send-email-peter.senna@gmail.com>
References: <1347986174-30287-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 arch/arm/plat-mxc/ulpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-mxc/ulpi.c b/arch/arm/plat-mxc/ulpi.c
index d296342..a799afb 100644
--- a/arch/arm/plat-mxc/ulpi.c
+++ b/arch/arm/plat-mxc/ulpi.c
@@ -51,7 +51,7 @@ static int ulpi_poll(void __iomem *view, u32 bit)
 			return 0;
 
 		cpu_relax();
-	};
+	}
 
 	printk(KERN_WARNING "timeout polling for ULPI device\n");
 
-- 
1.7.11.4

