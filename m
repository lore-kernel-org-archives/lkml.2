Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1BBQcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:32:25 -0500
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:39108 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557Ab1BBQcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:32:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/2] arm: Kconfig: allow OMAP to use sparse IRQ numbering
Date: Wed,  2 Feb 2011 18:31:55 +0200
Message-Id: <1296664315-32108-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1296664315-32108-1-git-send-email-balbi@ti.com>
References: <1296664315-32108-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select HAVE_SPARSE_IRQ to allow OMAP to use
sparse IRQ numbering scheme. The main difference
is that irq_descs will be added to a radix tree
instead of a static array.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 09a5c11..2ca24ad 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -857,6 +857,7 @@ config ARCH_DAVINCI
 config ARCH_OMAP
 	bool "TI OMAP"
 	select HAVE_CLK
+	select HAVE_SPARSE_IRQ
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
 	select GENERIC_CLOCKEVENTS
-- 
1.7.4.rc2

