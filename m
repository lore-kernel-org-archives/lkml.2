Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab0LULIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 06:08:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0LULIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 06:08:51 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP3: Devkit8000: Add DEBUG_LL support
Date: Tue, 21 Dec 2010 12:07:09 +0100
Message-Id: <1292929629-3396-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.3.4
X-Provags-ID: V02:K0:KbDZAv8FxJUhhuywqyHqTRrpEiNLM4J6X+Qrj+jsV1E
 m+o0DFbBezUx3htWjRUhhww8UE+gbn48D/vlWHlNzmqwL9V/u4
 ETpyAOMiqnv4E5aJk3CA9lxq9jXupz/gAWkOJw/DRUmUGFauws
 5KV41QHKhjqZuPk8cdsnqDFWt7G6rzlcN/n+m4Vj1dncgAiXFQ
 86hVKVupXCTkLcMW1Ds8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for DEBUG_LL for Devkit8000.
Devkit8000 uses uart 3 for debug output.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/plat-omap/include/plat/uncompress.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/uncompress.h b/arch/arm/plat-omap/include/plat/uncompress.h
index 7bbc074..ad98b85 100644
--- a/arch/arm/plat-omap/include/plat/uncompress.h
+++ b/arch/arm/plat-omap/include/plat/uncompress.h
@@ -146,6 +146,7 @@ static inline void __arch_decomp_setup(unsigned long arch_id)
 		DEBUG_LL_OMAP3(3, cm_t35);
 		DEBUG_LL_OMAP3(3, cm_t3517);
 		DEBUG_LL_OMAP3(3, craneboard);
+		DEBUG_LL_OMAP3(3, devkit8000);
 		DEBUG_LL_OMAP3(3, igep0020);
 		DEBUG_LL_OMAP3(3, igep0030);
 		DEBUG_LL_OMAP3(3, nokia_rm680);
-- 
1.7.3.4

