Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab1J1UTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:19:13 -0400
Received: from mail.df.lth.se ([194.47.250.12]:46818 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387Ab1J1UTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:19:12 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org, Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, swarren@nvidia.com, olof@lixom.net,
        ben@decadent.org.uk, arnaud.patard@rtp-net.org,
        grant.likely@secretlab.ca, w.sang@pengutronix.de, bs14@csr.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] ARM: mark empty gpio.h files empty
Date: Fri, 28 Oct 2011 22:19:02 +0200
Message-Id: <1319833142-4764-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is generally a better idea to make intentionally empty files
contain the human-readable /* empty */ comment, also it makes
the files play nice with "make distclean".

Reported-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-lpc32xx/include/mach/gpio.h |    1 +
 arch/arm/mach-tegra/include/mach/gpio.h   |    1 +
 arch/arm/mach-u300/include/mach/gpio.h    |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/include/mach/gpio.h b/arch/arm/mach-lpc32xx/include/mach/gpio.h
index e69de29..40a8c17 100644
--- a/arch/arm/mach-lpc32xx/include/mach/gpio.h
+++ b/arch/arm/mach-lpc32xx/include/mach/gpio.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/arm/mach-tegra/include/mach/gpio.h b/arch/arm/mach-tegra/include/mach/gpio.h
index e69de29..40a8c17 100644
--- a/arch/arm/mach-tegra/include/mach/gpio.h
+++ b/arch/arm/mach-tegra/include/mach/gpio.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/arm/mach-u300/include/mach/gpio.h b/arch/arm/mach-u300/include/mach/gpio.h
index e69de29..40a8c17 100644
--- a/arch/arm/mach-u300/include/mach/gpio.h
+++ b/arch/arm/mach-u300/include/mach/gpio.h
@@ -0,0 +1 @@
+/* empty */
-- 
1.7.3.2

