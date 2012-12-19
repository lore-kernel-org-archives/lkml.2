Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2LSKH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:07:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48785 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab2LSKHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:07:20 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH] ARM: OMAP4: PRM: fix RSTTIME and RSTST offsets
Date: Wed, 19 Dec 2012 12:06:28 +0200
Message-ID: <1355911588-21977-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355911588-21977-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1355911588-21977-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

RSTTIME is offset 0x8 and RSTST is offset 0x04 for OMAP4430 and
OMAP4460.

Signed-off-by: Nishanth Menon <nm@ti.com>
[ivan.khoronzhuk@ti.com: ported from k3.4]
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
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

