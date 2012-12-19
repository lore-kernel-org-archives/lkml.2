Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2LSKHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:07:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45127 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab2LSKHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:07:06 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH] ARM: OMAP4: PRM: Correct reset source map
Date: Wed, 19 Dec 2012 12:06:26 +0200
Message-ID: <1355911588-21977-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the map for reset sources register we use defines intended for
using with PRM_RSTCTRL register. So fix it.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/mach-omap2/prm44xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/prm44xx.c b/arch/arm/mach-omap2/prm44xx.c
index 7498bc7..e335216 100644
--- a/arch/arm/mach-omap2/prm44xx.c
+++ b/arch/arm/mach-omap2/prm44xx.c
@@ -56,9 +56,9 @@ static struct omap_prcm_irq_setup omap4_prcm_irq_setup = {
  *   enumeration)
  */
 static struct prm_reset_src_map omap44xx_prm_reset_src_map[] = {
-	{ OMAP4430_RST_GLOBAL_WARM_SW_SHIFT,
+	{ OMAP4430_GLOBAL_WARM_SW_RST_SHIFT,
 	  OMAP_GLOBAL_WARM_RST_SRC_ID_SHIFT },
-	{ OMAP4430_RST_GLOBAL_COLD_SW_SHIFT,
+	{ OMAP4430_GLOBAL_COLD_RST_SHIFT,
 	  OMAP_GLOBAL_COLD_RST_SRC_ID_SHIFT },
 	{ OMAP4430_MPU_SECURITY_VIOL_RST_SHIFT,
 	  OMAP_SECU_VIOL_RST_SRC_ID_SHIFT },
-- 
1.7.9.5

