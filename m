Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2HQF7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:59:24 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:51434 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585Ab2HQF7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:59:18 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        chao.xie@marvell.com
Cc: Chao Xie <xiechao.mail@gmail.com>
Subject: [PATCH V4 5/5] arm: mmp: make all SOCs use common clock by default
Date: Fri, 17 Aug 2012 14:02:10 +0800
Message-Id: <1345183330-20244-6-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345183330-20244-1-git-send-email-xiechao.mail@gmail.com>
References: <1345183330-20244-1-git-send-email-xiechao.mail@gmail.com>
X-OriginalArrivalTime: 17 Aug 2012 05:58:05.0424 (UTC) FILETIME=[44E3C700:01CD7C3D]
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

