Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1LAPZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:25:54 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38895 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab1LAPZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:25:52 -0500
Message-ID: <1322753145.11611.1.camel@phoenix>
Subject: [PATCH 2/2] ARM: exynos4: Fix build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Date: Thu, 01 Dec 2011 23:25:45 +0800
In-Reply-To: <1322753070.11611.0.camel@phoenix>
References: <1322753070.11611.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial fix to fix below build error:

  CC      arch/arm/mach-exynos/mach-universal_c210.o
arch/arm/mach-exynos/mach-universal_c210.c:24: error: expected identifier or '(' before '<' token

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-exynos/mach-universal_c210.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index 48e85b0..cfc7d50 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -21,7 +21,7 @@
 #include <linux/mmc/host.h>
 #include <linux/i2c-gpio.h>
 #include <linux/i2c/mcs.h>
- <linux/i2c/atmel_mxt_ts.h>
+#include <linux/i2c/atmel_mxt_ts.h>
 
 #include <asm/mach/arch.h>
 #include <asm/hardware/gic.h>
-- 
1.7.5.4



