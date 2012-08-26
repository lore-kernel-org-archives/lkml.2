Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2HZBsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:48:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35061 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab2HZBsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:48:12 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:48:11 +0800
Message-ID: <CAPgLHd_pYM3otnZBZ=nz7aYTP4dorBSjQtj=x9Z+zz7yr1NgSg@mail.gmail.com>
Subject: [PATCH] ARM i.MX: remove duplicated include from clk-imx21.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-imx/clk-imx21.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx21.c b/arch/arm/mach-imx/clk-imx21.c
index ea13e61..cf65148 100644
--- a/arch/arm/mach-imx/clk-imx21.c
+++ b/arch/arm/mach-imx/clk-imx21.c
@@ -23,7 +23,6 @@
 #include <linux/clk-provider.h>
 #include <linux/io.h>
 #include <linux/module.h>
-#include <linux/clkdev.h>
 #include <linux/err.h>
 
 #include <mach/hardware.h>

