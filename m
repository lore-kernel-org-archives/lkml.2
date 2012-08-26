Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2HZBth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:49:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57283 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2HZBte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:49:34 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:49:34 +0800
Message-ID: <CAPgLHd_QDRHKBybnCtD_K-JJvJG_f4x6wTXczQZqraiLch4wEg@mail.gmail.com>
Subject: [PATCH] ARM: mxs: remove duplicated include from mach-mxs.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: shawn.guo@linaro.org, linux@arm.linux.org.uk
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
 arch/arm/mach-mxs/mach-mxs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 8dabfe8..5c91870 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -14,7 +14,6 @@
 #include <linux/clkdev.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/init.h>
 #include <linux/irqdomain.h>
 #include <linux/micrel_phy.h>
 #include <linux/mxsfb.h>

