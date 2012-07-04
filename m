Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803Ab2GDJiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:38:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1100 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab2GDJhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:37:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 04 Jul 2012 02:36:38 -0700
From: Wei Ni <wni@nvidia.com>
To: <swarren@nvidia.com>, <olof@lixom.net>, <ccross@android.com>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <ldewangan@nvidia.com>, <arnd@arndb.de>, <grant.likely@secretlab.ca>,
        <cjb@laptop.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 0/5] ARM: tegra: enable wlan for t20 and t30
Date: Wed, 4 Jul 2012 17:34:43 +0800
Message-ID: <1341394488-13169-1-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up clocks, pinmux, gpios and configs to enable wlan for
following tegra boards:
Tegra30: Cardhu.
Tegra20: Seaboard, Ventana.

Wei Ni (5):
  ARM: tegra: set up wlan clocks for tegra dt
  ARM: dt: t20 seaboard: add pinmux, gpio for wlan
  ARM: dt: t20 ventana: add pinmux, gpio for wlan
  ARM: dt: t30 cardhu: add pinmux, gpio for wlan
  ARM: tegra: enable wireless in defconfig

 arch/arm/boot/dts/tegra20-seaboard.dts |    5 +++++
 arch/arm/boot/dts/tegra20-ventana.dts  |   20 ++++++++++++++++++--
 arch/arm/boot/dts/tegra30-cardhu.dts   |   30 ++++++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig       |    6 ++++--
 arch/arm/mach-tegra/board-dt-tegra20.c |    1 +
 arch/arm/mach-tegra/board-dt-tegra30.c |    1 +
 6 files changed, 59 insertions(+), 4 deletions(-)

