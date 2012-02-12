Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab2BLOGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 09:06:11 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:52383
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754504Ab2BLOGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 09:06:09 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: ben-linux@fluff.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] simtec: Fix typo in pm-simtec.c
Date: Sun, 12 Feb 2012 22:58:46 +0900
Message-Id: <1329055126-1924-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "Manangement" to "Management" in
arch/arm/plat-s3c24xx/pm-simtec.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/plat-s3c24xx/pm-simtec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-s3c24xx/pm-simtec.c b/arch/arm/plat-s3c24xx/pm-simtec.c
index 68296b1..699f931 100644
--- a/arch/arm/plat-s3c24xx/pm-simtec.c
+++ b/arch/arm/plat-s3c24xx/pm-simtec.c
@@ -52,7 +52,7 @@ static __init int pm_simtec_init(void)
 	    !machine_is_aml_m5900())
 		return 0;
 
-	printk(KERN_INFO "Simtec Board Power Manangement" COPYRIGHT "\n");
+	printk(KERN_INFO "Simtec Board Power Management" COPYRIGHT "\n");
 
 	gstatus4  = (__raw_readl(S3C2410_BANKCON7) & 0x3) << 30;
 	gstatus4 |= (__raw_readl(S3C2410_BANKCON6) & 0x3) << 28;
-- 
1.7.6.5

