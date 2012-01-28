Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2A1NiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 08:38:11 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:46499
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753197Ab2A1NiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 08:38:09 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org
Cc: standby24x7@gmail.com, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] [trivial] mips: Fix typo in bcm63xx/setup.c
Date: Sat, 28 Jan 2012 22:36:56 +0900
Message-Id: <1327757816-7401-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "reseting" to "resetting" in
arch/mips/bcm63xx/setup.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/mips/bcm63xx/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/bcm63xx/setup.c b/arch/mips/bcm63xx/setup.c
index d209f85..356b055 100644
--- a/arch/mips/bcm63xx/setup.c
+++ b/arch/mips/bcm63xx/setup.c
@@ -33,7 +33,7 @@ static void bcm6348_a1_reboot(void)
 	u32 reg;
 
 	/* soft reset all blocks */
-	printk(KERN_INFO "soft-reseting all blocks ...\n");
+	printk(KERN_INFO "soft-resetting all blocks ...\n");
 	reg = bcm_perf_readl(PERF_SOFTRESET_REG);
 	reg &= ~SOFTRESET_6348_ALL;
 	bcm_perf_writel(reg, PERF_SOFTRESET_REG);
-- 
1.7.6.5

