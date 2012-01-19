Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab2ASHwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:52:22 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:38845 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2ASHwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:52:21 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dhc1bhc31hc1ah2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Shijie <b32955@freescale.com>
To: <shawn.guo@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <u.kleine-koenig@pengutronix.de>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH resent v2 0/2] ARM/mxs : add GPMI-NAND support for imx23/imx28
Date: Thu, 19 Jan 2012 15:53:38 +0800
Message-ID: <1326959620-25920-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set has two patches:
[1] Add a new DEFINE_RES_DMA_SIZE_NAMED macro which used by the dma resource
    that has more then one dma source.
 
[2] add GPMI-NAND support for imx23/imx28

Huang Shijie (2):
  ioport : add DEFINE_RES_DMA_SIZE_NAMED macro
  ARM: mxs: add GPMI-NAND support for imx23/imx28

 arch/arm/mach-mxs/clock-mx23.c                  |    1 +
 arch/arm/mach-mxs/clock-mx28.c                  |    1 +
 arch/arm/mach-mxs/devices-mx23.h                |    4 +
 arch/arm/mach-mxs/devices-mx28.h                |    4 +
 arch/arm/mach-mxs/devices/Kconfig               |    3 +
 arch/arm/mach-mxs/devices/Makefile              |    1 +
 arch/arm/mach-mxs/devices/platform-gpmi-nand.c  |   79 +++++++++++++++++++++++
 arch/arm/mach-mxs/include/mach/devices-common.h |   10 +++
 include/linux/ioport.h                          |    4 +-
 9 files changed, 106 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mxs/devices/platform-gpmi-nand.c


