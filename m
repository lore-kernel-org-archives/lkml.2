Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2ASGP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:15:26 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:47052
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060Ab2ASGPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:15:13 -0500
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
Subject: [PATCH 02/10] MXS-DMA : change the header
Date: Thu, 19 Jan 2012 14:15:59 +0800
Message-ID: <1326953767-24155-3-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1326953767-24155-1-git-send-email-b32955@freescale.com>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change the header for MXS-DMA driver.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/dma/mxs-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index b06cd4c..c80fbed 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -22,10 +22,10 @@
 #include <linux/platform_device.h>
 #include <linux/dmaengine.h>
 #include <linux/delay.h>
+#include <linux/mxs-dma.h>
 
 #include <asm/irq.h>
 #include <mach/mxs.h>
-#include <mach/dma.h>
 #include <mach/common.h>
 
 /*
-- 
1.7.0.4


