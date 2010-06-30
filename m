Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0F3P7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:59:49 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39898 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755696Ab0F3P7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:59:47 -0400
Date: Wed, 30 Jun 2010 17:59:45 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 18/33] Removing dead OMAP_ARM_96MHZ
Message-ID: <8304abb0dbda307c488b6fe2b3cc8df3c9909eb6.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP_ARM_96MHZ doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-omap1/opp_data.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap1/opp_data.c b/arch/arm/mach-omap1/opp_data.c
index 75a5465..060df86 100644
--- a/arch/arm/mach-omap1/opp_data.c
+++ b/arch/arm/mach-omap1/opp_data.c
@@ -45,9 +45,6 @@ struct mpu_rate omap1_rate_table[] = {
 #if defined(CONFIG_OMAP_ARM_120MHZ)
 	{ 120000000, 12000000, 120000000, 0x010a, 0x2510 }, /* 1/1/1/2/4/4 */
 #endif
-#if defined(CONFIG_OMAP_ARM_96MHZ)
-	{  96000000, 12000000,  96000000, 0x0005, 0x2410 }, /* 1/1/1/1/2/2 */
-#endif
 #if defined(CONFIG_OMAP_ARM_60MHZ)
 	{  60000000, 12000000,  60000000, 0x0005, 0x2290 }, /* 1/1/1/1/2/2 */
 #endif
-- 
1.7.0.4

