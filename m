Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2H0K00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 06:26:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5888 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab2H0K0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 06:26:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 27 Aug 2012 03:20:04 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>, <brudley@broadcom.com>, <rvossen@broadcom.com>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list@broadcom.com>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 0/6] ARM: tegra: enable wlan for t20 and t30
Date: Mon, 27 Aug 2012 18:25:08 +0800
Message-ID: <1346063114-30361-1-git-send-email-wni@nvidia.com>
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

Wei Ni (6):
  ARM: tegra: set up wlan clocks for tegra dt
  brcmfmac: Handling the interrupt in ISR directly for non-OOB
  ARM: dt: t20 seaboard: turn on the power for wlan
  ARM: dt: t20 ventana: set pinmux and power for wlan
  ARM: dt: t30 cardhu: set pinmux and power for wlan
  ARM: tegra: enable wireless in defconfig

 arch/arm/boot/dts/tegra20-seaboard.dts             |    5 +++
 arch/arm/boot/dts/tegra20-ventana.dts              |   15 +++++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |   32 ++++++++++++++++++++
 arch/arm/configs/tegra_defconfig                   |    4 ++
 arch/arm/mach-tegra/board-dt-tegra20.c             |    4 ++
 arch/arm/mach-tegra/board-dt-tegra30.c             |    4 ++
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 ++++-
 8 files changed, 73 insertions(+), 1 deletions(-)

