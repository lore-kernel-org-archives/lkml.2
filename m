Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844Ab2CMIpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:45:11 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:59242
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756113Ab2CMIpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:45:07 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <cjb@laptop.org>, <rdunlap@xenotime.net>,
        <vinod.koul@linux.intel.com>
Subject: [PATCH v1 0/5] dt: add basic imx28 support
Date: Tue, 13 Mar 2012 16:47:03 +0800
Message-ID: <1331628428-24017-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds basic imx28 dt support including fec, mmc and dma.

Tested on mx28evk.

TODO:
Convert the remaining devices to support dt.
mxs-auart, mxs-gpio, i2c, flexcan, saif, rtc, pwm, fb.

Dong Aisheng (5):
  ARM: imx28: add basic dt support
  mmc: mxs-mmc: add dt probe support
  ARM: imx28evk: add mmc dt support
  dma: mxs-dma: add dt probe support
  ARM: mxs: add mxs dma dt support

 Documentation/devicetree/bindings/arm/fsl.txt      |    4 +
 .../devicetree/bindings/dma/fsl-mxs-dma.txt        |   17 +++
 .../devicetree/bindings/mmc/fsl-mxs-mmc.txt        |   23 ++++
 arch/arm/boot/dts/imx28-evk.dts                    |   45 +++++++
 arch/arm/boot/dts/imx28.dtsi                       |  131 ++++++++++++++++++++
 arch/arm/mach-mxs/Kconfig                          |    9 ++
 arch/arm/mach-mxs/Makefile                         |    1 +
 arch/arm/mach-mxs/devices-mx23.h                   |    2 +
 arch/arm/mach-mxs/devices-mx28.h                   |    2 +
 arch/arm/mach-mxs/devices/platform-dma.c           |    3 +-
 arch/arm/mach-mxs/imx28-dt.c                       |   71 +++++++++++
 arch/arm/mach-mxs/include/mach/devices-common.h    |    3 +
 arch/arm/mach-mxs/mach-apx4devkit.c                |    1 +
 arch/arm/mach-mxs/mach-m28evk.c                    |    1 +
 arch/arm/mach-mxs/mach-mx23evk.c                   |    1 +
 arch/arm/mach-mxs/mach-mx28evk.c                   |    1 +
 arch/arm/mach-mxs/mach-stmp378x_devb.c             |    1 +
 arch/arm/mach-mxs/mach-tx28.c                      |    1 +
 drivers/dma/mxs-dma.c                              |   44 +++++--
 drivers/mmc/host/mxs-mmc.c                         |   82 ++++++++++++-
 20 files changed, 424 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/dma/fsl-mxs-dma.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt
 create mode 100644 arch/arm/boot/dts/imx28-evk.dts
 create mode 100644 arch/arm/boot/dts/imx28.dtsi
 create mode 100644 arch/arm/mach-mxs/imx28-dt.c


