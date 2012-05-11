Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499Ab2EKGoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:44:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14487 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760686Ab2EKGmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:42:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 May 2012 23:42:39 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <linux@arm.linux.org.uk>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <olof@lixom.net>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/4] regulator: tps62360: support dts and enable for tegra-cardhu
Date: Fri, 11 May 2012 12:08:41 +0530
Message-ID: <1336718325-8372-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for dt on regulator device tps62360. Also  enable this regulator for Nvidia's
Tegra platform - cardhu.
This series:
- Make the regulator_init_data as pointer type from platform data.
- enable config variable in tegra defconfig
- add entry for tps62360 in dts file of tegra-cardhu.

Changes from V1:
	Patch 1 did not compile when not defining CONFIG_OF. Fixed it.

Changes from V2:
	Taken care of Grant's review comments.

Laxman Dewangan (4):
  regulator: tps62360: make init_data of platform data to pointer.
	Make the regulator init data as pointer type in platform.
  regulator: tps62360: add dt support
	Ad dt support.
  ARM: tegra: config: enable REGULATOR_TPS62360
  ARM: dt: tegra: cardhu: register core regulator tps62360

 .../bindings/regulator/tps62360-regulator.txt      |   45 ++++++++++++
 arch/arm/boot/dts/tegra-cardhu.dts                 |   14 ++++
 arch/arm/configs/tegra_defconfig                   |    1 +
 drivers/regulator/tps62360-regulator.c             |   74 +++++++++++++++++++-
 include/linux/regulator/tps62360.h                 |    4 +-
 5 files changed, 133 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps62360-regulator.txt

