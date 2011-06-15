Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab1FOTh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:37:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36839 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1FOTh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:37:57 -0400
Subject: [PATCH 1/2] gpio/tegra: Move Tegra gpio driver to drivers/gpio
To: Erik Gilling <konkers@android.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Warren <swarren@nvidia.com>
Date: Wed, 15 Jun 2011 13:37:54 -0600
Message-ID: <20110615193734.23641.8004.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the gpio driver consolidation, this patch moves the Tegra driver
into drivers/gpio

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

If there are no objections, I'll merge this via gpio/next

g.

 arch/arm/mach-tegra/Makefile |    1 -
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/gpio-tegra.c    |    0 
 3 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/arm/mach-tegra/gpio.c => drivers/gpio/gpio-tegra.c (100%)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 823c703..ed58ef9 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -4,7 +4,6 @@ obj-y                                   += io.o
 obj-y                                   += irq.o
 obj-y                                   += clock.o
 obj-y                                   += timer.o
-obj-y                                   += gpio.o
 obj-y                                   += pinmux.o
 obj-y                                   += powergate.o
 obj-y					+= fuse.o
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 68e3bfd..0fbdd75 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
 obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
 obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
 obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
+obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= gpio-timberdale.o
 obj-$(CONFIG_GPIO_TPS65910)	+= gpio-tps65910.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
diff --git a/arch/arm/mach-tegra/gpio.c b/drivers/gpio/gpio-tegra.c
similarity index 100%
rename from arch/arm/mach-tegra/gpio.c
rename to drivers/gpio/gpio-tegra.c

