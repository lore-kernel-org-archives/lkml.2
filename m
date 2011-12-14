Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab1LND6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:58:47 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50120 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754807Ab1LND6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:58:35 -0500
From: Mike Turquette <mturquette@linaro.org>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        paul@pwsan.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@linaro.org, mturquette@ti.com,
        andrew@lunn.ch
Subject: [PATCH v4 1/6] clk: Kconfig: add entry for HAVE_CLK_PREPARE
Date: Tue, 13 Dec 2011 19:53:53 -0800
Message-Id: <1323834838-2206-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common clk framework provides clk_prepare and clk_unprepare
implementations.  Create an entry for HAVE_CLK_PREPARE so that
GENERIC_CLK can select it.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/clk/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 3530927..7a9899bd 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -5,3 +5,6 @@ config CLKDEV_LOOKUP
 
 config HAVE_MACH_CLKDEV
 	bool
+
+config HAVE_CLK_PREPARE
+	bool
-- 
1.7.5.4

