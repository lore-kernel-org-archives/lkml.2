Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2IUI4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:56:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11362 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab2IUI4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:56:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 21 Sep 2012 01:56:02 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v2 0/5] ARM: tegra: enable wlan for t20 and t30
Date: Fri, 21 Sep 2012 16:54:55 +0800
Message-ID: <1348217700-12309-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable wlan for following tegra board:
Tegra30: Cardhu.
Tegra20: Seaboard, Ventana.

Note that this series depends on specific brcmfmac patches:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/97337.

V2: -Since Broadcom restructure the dpc routine with above link,
     it can fix non-OOB issue, so we remove the patches for brcmfmac driver.
    -Support Cardhu a02 and a04 board.
    -Remove the config WLAN and WIRELESS in the patch,
     because they are default=y
    -Add bus-width for sdhci in the dts file

Wei Ni (5):
  ARM: tegra: set up wlan clocks for tegra dt
  ARM: dt: t20 seaboard: turn on the power for wlan
  ARM: dt: t20 ventana: set pinmux and power for wlan
  ARM: dt: t30 cardhu: set pinmux and power for wlan
  ARM: tegra: enable brcmfmac in defconfig

 arch/arm/boot/dts/tegra20-seaboard.dts   |    6 ++++++
 arch/arm/boot/dts/tegra20-ventana.dts    |   16 ++++++++++++++++
 arch/arm/boot/dts/tegra30-cardhu-a02.dts |    6 ++++++
 arch/arm/boot/dts/tegra30-cardhu-a04.dts |    6 ++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi    |   27 +++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig         |    2 ++
 arch/arm/mach-tegra/board-dt-tegra20.c   |    4 ++++
 arch/arm/mach-tegra/board-dt-tegra30.c   |    4 ++++
 8 files changed, 71 insertions(+), 0 deletions(-)

