Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2CCIat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 03:30:49 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:49804 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab2CCIar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 03:30:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.236.161.103 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
From: Mike Turquette <mturquette@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v5 2/4] clk: Kconfig: add entry for HAVE_CLK_PREPARE
Date: Sat,  3 Mar 2012 00:28:59 -0800
Message-Id: <1330763341-3437-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common clk framework provides clk_prepare and clk_unprepare
implementations.  Create an entry for HAVE_CLK_PREPARE so that
COMMON_CLK can select it.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Mike Turquette <mturquette@ti.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Deepak Saxena <dsaxena@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Lunn <andrew@lunn.ch>
---
 drivers/clk/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 9b3cd08..3912576 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -8,3 +8,6 @@ config HAVE_CLK_PREPARE
 
 config HAVE_MACH_CLKDEV
 	bool
+
+config HAVE_CLK_PREPARE
+	bool
-- 
1.7.5.4

