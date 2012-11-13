Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab2KMFGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:06:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6455 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2KMFGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:06:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Nov 2012 21:06:30 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/3] ARM: tegra: dt: Add entry for tegra20 sflash controller.
Date: Tue, 13 Nov 2012 10:33:38 +0530
Message-ID: <1352783021-25393-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add the dt entry for tegra20 sflash controller,
add AUXDATA in board dt file for driver name and enable in tegra_defconfig.

Laxman Dewangan (3):
  ARM: tegra: dts: add sflash controller dt entry
  ARM: tegra: Add OF_DEV_AUXDATA for sflash driver in board dt
  ARM: config: tegra: enable SFLASH controller driver

 arch/arm/boot/dts/tegra20.dtsi         |   10 ++++++++++
 arch/arm/configs/tegra_defconfig       |    1 +
 arch/arm/mach-tegra/board-dt-tegra20.c |    2 ++
 3 files changed, 13 insertions(+), 0 deletions(-)

