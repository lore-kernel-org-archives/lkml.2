Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2JOVzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:55:08 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:64287 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2JOVzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:55:00 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 07/10] ARM: FIQ: Should include asm/mach/irq.h
Date: Mon, 15 Oct 2012 14:51:31 -0700
Message-Id: <1350337894-9744-7-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <20121015214954.GA3352@lizard>
References: <20121015214954.GA3352@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes the following sparse warnings:

  CHECK   arch/arm/kernel/fiq.c
arch/arm/kernel/fiq.c:71:6: warning: symbol 'show_fiq_list' was not declared. Should it be static?
arch/arm/kernel/fiq.c:129:13: warning: symbol 'init_FIQ' was not declared. Should it be static?

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/kernel/fiq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index bd369c5..7be2e74 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -46,6 +46,7 @@
 #include <asm/fiq.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
+#include <asm/mach/irq.h>
 
 static unsigned long no_fiq_insn;
 
-- 
1.7.12.3

