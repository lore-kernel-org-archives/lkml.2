Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab2HZBsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:48:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35061 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2HZBsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:48:39 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:48:39 +0800
Message-ID: <CAPgLHd972bujPnZ-Pj_a13gychY+z3SVag4tLaxqZh+2kuh+dQ@mail.gmail.com>
Subject: [PATCH] ARM: LPC32xx: remove duplicated include from phy3250.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linux@arm.linux.org.uk
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
 arch/arm/mach-lpc32xx/phy3250.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index b07dcc9..ed0a50d 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -23,7 +23,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/dma-mapping.h>
-#include <linux/device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
 #include <linux/gpio.h>

