Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2HPCR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 22:17:29 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:48226 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753715Ab2HPCRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 22:17:15 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.or,
        arnd@arndb.de
Cc: Chao Xie <xiechao.mail@gmail.com>
Subject: [PATCH V2 5/5] arm: mmp: make all SOCs use common clock by default
Date: Thu, 16 Aug 2012 10:20:25 +0800
Message-Id: <1345083625-3041-6-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345083625-3041-1-git-send-email-xiechao.mail@gmail.com>
References: <1345083625-3041-1-git-send-email-xiechao.mail@gmail.com>
X-OriginalArrivalTime: 16 Aug 2012 02:16:43.0813 (UTC) FILETIME=[2E050550:01CD7B55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

Signed-off-by: Chao Xie <xiechao.mail@gmail.com>
---
 arch/arm/mach-mmp/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
index 7fddd01..d697d07 100644
--- a/arch/arm/mach-mmp/Kconfig
+++ b/arch/arm/mach-mmp/Kconfig
@@ -108,18 +108,21 @@ endmenu
 config CPU_PXA168
 	bool
 	select CPU_MOHAWK
+	select COMMON_CLK
 	help
 	  Select code specific to PXA168
 
 config CPU_PXA910
 	bool
 	select CPU_MOHAWK
+	select COMMON_CLK
 	help
 	  Select code specific to PXA910
 
 config CPU_MMP2
 	bool
 	select CPU_PJ4
+	select COMMON_CLK
 	help
 	  Select code specific to MMP2. MMP2 is ARMv7 compatible.
 
-- 
1.7.0.4

