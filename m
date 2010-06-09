Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0FILU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:20:26 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37108 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764Ab0FILUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:20:25 -0400
Date: Wed, 9 Jun 2010 13:20:23 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 1/9] Removing dead CONFIG_SOC_AU1000_FREQUENCY
Message-ID: <2bd4314b3380c3c4aedd686f14187a80d00522e7.1275925108.git.siccegge@cs.fau.de>
References: <cover.1275925108.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1275925108.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SOC_AU1000_FREQUENCY doesn't exist in Kconfig, therefore
removing all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/mips/alchemy/common/clocks.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/mips/alchemy/common/clocks.c b/arch/mips/alchemy/common/clocks.c
index 460c628..af0fe41 100644
--- a/arch/mips/alchemy/common/clocks.c
+++ b/arch/mips/alchemy/common/clocks.c
@@ -89,11 +89,7 @@ unsigned long au1xxx_calc_clock(void)
 	 * over backwards trying to determine the frequency.
 	 */
 	if (au1xxx_cpu_has_pll_wo())
-#ifdef CONFIG_SOC_AU1000_FREQUENCY
-		cpu_speed = CONFIG_SOC_AU1000_FREQUENCY;
-#else
 		cpu_speed = 396000000;
-#endif
 	else
 		cpu_speed = (au_readl(SYS_CPUPLL) & 0x0000003f) * AU1000_SRC_CLK;
 
-- 
1.6.3.3

