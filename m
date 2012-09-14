Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2INQZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:25:33 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:36422 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab2INQZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:25:31 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH 6/8] mmc: use the new <linux/sizes.h>
Date: Fri, 14 Sep 2012 18:24:01 +0200
Message-Id: <1347639843-32119-7-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
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
index 263102c..8e3f33e 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -33,10 +33,10 @@
 #include <linux/amba/mmci.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
+#include <linux/sizes.h>
 
 #include <asm/div64.h>
 #include <asm/io.h>
-#include <asm/sizes.h>
 
 #include "mmci.h"
 
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 1d14cda..0718469 100644
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
 
 #include <mach/mmc.h>
 #include <mach/msm_iomap.h>
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index a61cb5f..898550b 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -22,8 +22,8 @@
 #include <linux/clk.h>
 #include <linux/gpio.h>
 #include <linux/mmc/host.h>
+#include <linux/sizes.h>
 
-#include <asm/sizes.h>
 #include <asm/unaligned.h>
 #include <plat/mvsdio.h>
 
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 28ed52d..f9ccac3 100644
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
 #include <mach/mmc.h>
 
 #include <mach/dma.h>
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 11df800..2635550 100644
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
1.7.9.1

