Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab2FAJNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:13:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4358 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab2FAJNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:13:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 01 Jun 2012 02:11:17 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <olof@lixom.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 0/9] Add clk_prepare/clk_unprepare
Date: Fri, 1 Jun 2012 14:42:39 +0530
Message-ID: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds use of clk_prepare/clk_unprepare as
required by generic clock framework.

Tested on Ventana and Cardhu.

Prashant Gaikwad (9):
  ARM: tegra: add clk_prepare/clk_unprepare
  i2c: tegra: Add clk_prepare/clk_unprepare
  mmc: tegra: add clk_prepare/clk_unprepare
  USB: ehci-tegra: add clk_prepare/clk_unprepare
  Input: tegra-kbc - add clk_prepare/clk_unprepare
  spi/tegra: add clk_prepare/clk_unprepare
  staging: nvec: add clk_prepare/clk_unprepare
  ASoC: tegra: add clk_prepare/clk_unprepare
  crypto: add clk_prepare/clk_unprepare

 arch/arm/mach-tegra/cpu-tegra.c    |    6 +++---
 arch/arm/mach-tegra/dma.c          |    2 +-
 arch/arm/mach-tegra/pcie.c         |    6 +++---
 arch/arm/mach-tegra/powergate.c    |    4 ++--
 arch/arm/mach-tegra/timer.c        |    4 ++--
 arch/arm/mach-tegra/usb_phy.c      |   16 ++++++++--------
 drivers/crypto/tegra-aes.c         |   12 ++++++------
 drivers/i2c/busses/i2c-tegra.c     |   10 +++++-----
 drivers/input/keyboard/tegra-kbc.c |    4 ++--
 drivers/mmc/host/sdhci-tegra.c     |    6 +++---
 drivers/spi/spi-tegra.c            |    4 ++--
 drivers/staging/nvec/nvec.c        |    8 ++++----
 drivers/usb/host/ehci-tegra.c      |   20 ++++++++++----------
 sound/soc/tegra/tegra20_i2s.c      |    4 ++--
 sound/soc/tegra/tegra20_spdif.c    |    4 ++--
 sound/soc/tegra/tegra30_ahub.c     |    8 ++++----
 sound/soc/tegra/tegra30_i2s.c      |    4 ++--
 sound/soc/tegra/tegra_asoc_utils.c |   12 ++++++------
 18 files changed, 67 insertions(+), 67 deletions(-)

-- 
1.7.4.1

