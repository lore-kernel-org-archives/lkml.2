Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1IVWbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:31:13 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:54116 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754237Ab1IVWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:31:10 -0400
From: Mike Turquette <mturquette@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: [PATCH v2 7/7] x86: Enable generic clk API on x86
Date: Thu, 22 Sep 2011 15:27:02 -0700
Message-Id: <1316730422-20027-8-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316730422-20027-1-git-send-email-mturquette@ti.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Enable the generic clk API on x86, enabling use of the API by drivers for
x86 modules and also improving build coverage for clock API using devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
No change since v1

 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..571b2c5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -73,6 +73,7 @@ config X86
 	select HAVE_BPF_JIT if (X86_64 && NET)
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CLK
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
-- 
1.7.4.1

