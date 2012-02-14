Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab2BNOgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:36:20 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:51163
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756648Ab2BNOgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:36:17 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: viresh.kumar@st.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] arm: Fix typo in spear3[012]0.c
Date: Tue, 14 Feb 2012 23:35:42 +0900
Message-Id: <1329230142-2063-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "registeration" to "registration" in
arch/arm/mach-spear3xx/spear300.c, spear310.c and spear320.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/mach-spear3xx/spear300.c |    2 +-
 arch/arm/mach-spear3xx/spear310.c |    2 +-
 arch/arm/mach-spear3xx/spear320.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index a5e46b4..4f7f518 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -469,7 +469,7 @@ void __init spear300_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
 	if (pmx_driver.base) {
 		ret = pmx_register(&pmx_driver);
 		if (ret)
-			printk(KERN_ERR "padmux: registeration failed. err no"
+			printk(KERN_ERR "padmux: registration failed. err no"
 					": %d\n", ret);
 		/* Free Mapping, device selection already done */
 		iounmap(pmx_driver.base);
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index 9004cf9..febaa6f 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -303,6 +303,6 @@ void __init spear310_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
 
 	ret = pmx_register(&pmx_driver);
 	if (ret)
-		printk(KERN_ERR "padmux: registeration failed. err no: %d\n",
+		printk(KERN_ERR "padmux: registration failed. err no: %d\n",
 				ret);
 }
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index ee29bef..deaaf19 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -550,6 +550,6 @@ void __init spear320_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
 
 	ret = pmx_register(&pmx_driver);
 	if (ret)
-		printk(KERN_ERR "padmux: registeration failed. err no: %d\n",
+		printk(KERN_ERR "padmux: registration failed. err no: %d\n",
 				ret);
 }
-- 
1.7.6.5

