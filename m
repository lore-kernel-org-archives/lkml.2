Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2LQTyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:54:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58851 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2LQTyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:54:14 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH] ARM: OMAP4: PRM: Correct PRM_RSTST and PRM_RSTTIME registers shifts
Date: Mon, 17 Dec 2012 21:52:56 +0200
Message-ID: <1355773976-30164-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to TRMs the assigned shifts are wrong, so correct them.
---
 arch/arm/mach-omap2/prm44xx.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/prm44xx.h b/arch/arm/mach-omap2/prm44xx.h
index 22b0979..8ee1fbd 100644
--- a/arch/arm/mach-omap2/prm44xx.h
+++ b/arch/arm/mach-omap2/prm44xx.h
@@ -62,8 +62,8 @@
 
 /* OMAP4 specific register offsets */
 #define OMAP4_RM_RSTCTRL				0x0000
-#define OMAP4_RM_RSTTIME				0x0004
-#define OMAP4_RM_RSTST					0x0008
+#define OMAP4_RM_RSTST					0x0004
+#define OMAP4_RM_RSTTIME				0x0008
 #define OMAP4_PM_PWSTCTRL				0x0000
 #define OMAP4_PM_PWSTST					0x0004
 
-- 
1.7.9.5

