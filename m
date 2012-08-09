Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab2HILQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:16:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1458 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab2HILQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:16:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 09 Aug 2012 04:10:51 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH v2 0/3] ARM: dt: tegra: cardhu: add entry for regulators
Date: Thu, 9 Aug 2012 16:30:36 +0530
Message-ID: <1344510039-17754-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add the PMIC and fixed regulators for 
cardhu board. There is multiple versions of cardhu baord named
as A01, A02, A03..and so on. Cardhu A01 and A03 are not supported.
Cardhu A02 and A04 have different sets of GPIO for regualtors.
The cardhu A04 is compatible for A05, A06 and A07 in GPIOs.
This patch series split the cardhu dts file to cardhu-a02 and 
carchu-a04 and then add entry for different fixed regualtors.

In patch 1, it enabled the PMIC tps65910 which is main pmu for 
the cardhu.
In Patch 2, split the cardhu support for cardhu-a02 and cardhu-a04.
In Patch 3, add different regulators.

Changes from V1-->V2:
- Remove the vdd_sdmmc1 regulator registration.
- Fix the pex_hvdd_3v3 regulator registration.
- Set panel regulator to be always on.
- Add i2c eeprom address in board-identification paragraph.


Laxman Dewangan (3):
  ARM: dt: tegra: cardhu: add entry for PMIC TPS65911.
  ARM: dt: tegra: cardhu: split dts file for support multiple board
    versions
  ARM: tegra: cardhu: add dt entry for fixed regulators

 arch/arm/boot/dts/tegra30-cardhu-a02.dts |   87 ++++++
 arch/arm/boot/dts/tegra30-cardhu-a04.dts |   98 ++++++
 arch/arm/boot/dts/tegra30-cardhu.dts     |  171 -----------
 arch/arm/boot/dts/tegra30-cardhu.dtsi    |  473 ++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/Makefile.boot        |    3 +-
 5 files changed, 660 insertions(+), 172 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra30-cardhu-a02.dts
 create mode 100644 arch/arm/boot/dts/tegra30-cardhu-a04.dts
 delete mode 100644 arch/arm/boot/dts/tegra30-cardhu.dts
 create mode 100644 arch/arm/boot/dts/tegra30-cardhu.dtsi

