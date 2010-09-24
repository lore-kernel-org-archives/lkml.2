Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab0IXUOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:14:51 -0400
Received: from mail.logicpd.com ([66.162.60.3]:11017 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758072Ab0IXUOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:14:12 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2010 16:14:09 EDT
From: Tim Nordell <tim.nordell@logicpd.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH v3 5/5] ARM: OMAP3LOGIC: Adding low-level debug support
Date: Fri, 24 Sep 2010 14:58:58 -0500
Message-Id: <1285358338-3403-6-git-send-email-tim.nordell@logicpd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285358338-3403-1-git-send-email-tim.nordell@logicpd.com>
References: <1285358338-3403-1-git-send-email-tim.nordell@logicpd.com>
X-OriginalArrivalTime: 24 Sep 2010 19:58:57.0573 (UTC) FILETIME=[EC720550:01CB5C22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defined UART1 as the low-level debug port for both the
omap3530_lv_som board and the omap3_torpedo board.

Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
---
 arch/arm/plat-omap/include/plat/uncompress.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/uncompress.h b/arch/arm/plat-omap/include/plat/uncompress.h
index ddf723b..ff9f3a2 100644
--- a/arch/arm/plat-omap/include/plat/uncompress.h
+++ b/arch/arm/plat-omap/include/plat/uncompress.h
@@ -139,6 +139,8 @@ static inline void __arch_decomp_setup(unsigned long arch_id)
 		DEBUG_LL_OMAP2(1, omap3evm);
 		DEBUG_LL_OMAP3(1, omap_3430sdp);
 		DEBUG_LL_OMAP3(1, omap_3630sdp);
+		DEBUG_LL_OMAP3(1, omap3530_lv_som);
+		DEBUG_LL_OMAP3(1, omap3_torpedo);
 
 		/* omap3 based boards using UART3 */
 		DEBUG_LL_OMAP3(3, cm_t35);
-- 
1.7.1

