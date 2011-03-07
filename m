Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1CGNud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 08:50:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63313 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1CGNuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 08:50:32 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@ti.com> (supporter:TI DAVINCI MACHIN... 
	,commit_signer:3/4=75%),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        Cyril Chemparathy <cyril@ti.com> (commit_signer:2/4=50%),
        Juha Kuikka <juha.kuikka@elektrobit.com> (commit_signer:1/4=25%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/1] davinci: macro rename DA8XX_LPSC0_DMAX to DA8XX_LPSC0_PRUSS.
Date: Mon,  7 Mar 2011 19:36:57 +0530
Message-Id: <1299506818-11785-1-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMAX is an internal name for the module which is
known as PRUSS in TI public documentation. This patch just
gets the code in sync with TI documentation.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/da830.c            |    2 +-
 arch/arm/mach-davinci/include/mach/psc.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index ec23ab4..0577a5d 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -148,7 +148,7 @@ static struct clk scr2_ss_clk = {
 static struct clk dmax_clk = {
 	.name		= "dmax",
 	.parent		= &pll0_sysclk2,
-	.lpsc		= DA8XX_LPSC0_DMAX,
+	.lpsc		= DA8XX_LPSC0_PRUSS,
 	.flags		= ALWAYS_ENABLED,
 };
 
diff --git a/arch/arm/mach-davinci/include/mach/psc.h b/arch/arm/mach-davinci/include/mach/psc.h
index 62b0858..a47e6f2 100644
--- a/arch/arm/mach-davinci/include/mach/psc.h
+++ b/arch/arm/mach-davinci/include/mach/psc.h
@@ -150,7 +150,7 @@
 #define DA8XX_LPSC0_SCR0_SS		10
 #define DA8XX_LPSC0_SCR1_SS		11
 #define DA8XX_LPSC0_SCR2_SS		12
-#define DA8XX_LPSC0_DMAX		13
+#define DA8XX_LPSC0_PRUSS		13
 #define DA8XX_LPSC0_ARM			14
 #define DA8XX_LPSC0_GEM			15
 
-- 
1.7.2.3

