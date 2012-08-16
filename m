Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2HPDGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 23:06:18 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:50148 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab2HPDGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 23:06:07 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Cc: Chao Xie <xiechao.mail@gmail.com>
Subject: [PATCH V3 5/5] arm: mmp: make all SOCs use common clock by default
Date: Thu, 16 Aug 2012 11:08:45 +0800
Message-Id: <1345086525-12328-6-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345086525-12328-1-git-send-email-xiechao.mail@gmail.com>
References: <1345086525-12328-1-git-send-email-xiechao.mail@gmail.com>
X-OriginalArrivalTime: 16 Aug 2012 03:04:59.0058 (UTC) FILETIME=[EBB85920:01CD7B5B]
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

