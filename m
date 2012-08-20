Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2HTCvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 22:51:33 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:34276 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824Ab2HTCv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 22:51:27 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com,
        arnd@arndb.de
Cc: Chao Xie <xiechao.mail@gmail.com>
Subject: [PATCH V5 5/5] arm: mmp: make all SOCs use common clock by default
Date: Mon, 20 Aug 2012 10:55:15 +0800
Message-Id: <1345431315-8037-6-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
References: <1345431315-8037-1-git-send-email-xiechao.mail@gmail.com>
X-OriginalArrivalTime: 20 Aug 2012 02:50:41.0774 (UTC) FILETIME=[966430E0:01CD7E7E]
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

