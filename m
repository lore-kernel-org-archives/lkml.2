Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2KWPKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:10:10 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:45175 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab2KWPKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:10:06 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH 6/8] mmc: use the new <linux/sizes.h>
Date: Fri, 23 Nov 2012 16:08:28 +0100
Message-Id: <1353683310-23654-7-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Rubini <rubini@gnudd.com>

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/mmc/host/mmci.c     |    2 +-
 drivers/mmc/host/msm_sdcc.c |    2 +-
 drivers/mmc/host/mvsdio.c   |    2 +-
 drivers/mmc/host/mxcmmc.c   |    2 +-
 drivers/mmc/host/pxamci.c   |    3 +--
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 5e39b31..731d98e 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -34,10 +34,10 @@
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/sizes.h>
 
 #include <asm/div64.h>
 #include <asm/io.h>
-#include <asm/sizes.h>
 
 #include "mmci.h"
 
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 7c0af0e..aa61b79 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -37,10 +37,10 @@
 #include <linux/memory.h>
 #include <linux/gfp.h>
 #include <linux/gpio.h>
+#include <linux/sizes.h>
 
 #include <asm/cacheflush.h>
 #include <asm/div64.h>
-#include <asm/sizes.h>
 
 #include <linux/platform_data/mmc-msm_sdcc.h>
 #include <mach/msm_iomap.h>
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index de4c20b..e313cd9 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -22,8 +22,8 @@
 #include <linux/clk.h>
 #include <linux/gpio.h>
 #include <linux/mmc/host.h>
+#include <linux/sizes.h>
 
-#include <asm/sizes.h>
 #include <asm/unaligned.h>
 #include <linux/platform_data/mmc-mvsdio.h>
 
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index a72936e..8ce7e73 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -34,10 +34,10 @@
 #include <linux/regulator/consumer.h>
 #include <linux/dmaengine.h>
 #include <linux/types.h>
+#include <linux/sizes.h>
 
 #include <asm/dma.h>
 #include <asm/irq.h>
-#include <asm/sizes.h>
 #include <linux/platform_data/mmc-mxcmmc.h>
 
 #include <linux/platform_data/dma-imx.h>
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 3f9d6d5..af3604a 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -33,8 +33,7 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/of_device.h>
-
-#include <asm/sizes.h>
+#include <linux/sizes.h>
 
 #include <mach/hardware.h>
 #include <mach/dma.h>
-- 
1.7.10.4

