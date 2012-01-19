Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2ASGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:16:56 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:59469
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345Ab2ASGP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:15:26 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275bhz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <alsa-devel@alsa-project.org>,
        <b29396@freescale.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 05/10] ASoc : change the DMA header file
Date: Thu, 19 Jan 2012 14:16:02 +0800
Message-ID: <1326953767-24155-6-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1326953767-24155-1-git-send-email-b32955@freescale.com>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change these files to use the new DMA header file.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 sound/soc/mxs/mxs-pcm.c  |    2 +-
 sound/soc/mxs/mxs-pcm.h  |    2 +-
 sound/soc/mxs/mxs-saif.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mxs/mxs-pcm.c b/sound/soc/mxs/mxs-pcm.c
index 105f42a..7eb186f 100644
--- a/sound/soc/mxs/mxs-pcm.c
+++ b/sound/soc/mxs/mxs-pcm.c
@@ -28,6 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
+#include <linux/mxs-dma.h>
 
 #include <sound/core.h>
 #include <sound/initval.h>
@@ -35,7 +36,6 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 
-#include <mach/dma.h>
 #include "mxs-pcm.h"
 
 static struct snd_pcm_hardware snd_mxs_hardware = {
diff --git a/sound/soc/mxs/mxs-pcm.h b/sound/soc/mxs/mxs-pcm.h
index f55ac4f..3ac9956 100644
--- a/sound/soc/mxs/mxs-pcm.h
+++ b/sound/soc/mxs/mxs-pcm.h
@@ -19,7 +19,7 @@
 #ifndef _MXS_PCM_H
 #define _MXS_PCM_H
 
-#include <mach/dma.h>
+#include <linux/mxs-dma.h>
 
 struct mxs_pcm_dma_params {
 	int chan_irq;
diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index dccfb37..ada6344 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -24,12 +24,12 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/time.h>
+#include <linux/mxs-dma.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/saif.h>
-#include <mach/dma.h>
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <mach/mxs.h>
-- 
1.7.0.4


