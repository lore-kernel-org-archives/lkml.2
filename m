Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2LQMId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:08:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4858 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2LQMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:08:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 17 Dec 2012 04:08:31 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] ARM: tegra: add support for highspeed serial driver
Date: Mon, 17 Dec 2012 17:38:17 +0530
Message-ID: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add the infrastruture for supporting
highspeed serial driver for Nvidia's Tegra SOCs.

Laxman Dewangan (4):
  ARM: tegra30: Add support for Uart clock source divider as 15.1
  ARM: tegra: add connection name for uart clock table
  ARM: tegra: Add OF_DEV_AUXDATA for uart driver in board dt
  ARM: tegra: dts: add dma requestor and port numbers for serial
    controller

 arch/arm/boot/dts/tegra20.dtsi            |   10 ++++
 arch/arm/boot/dts/tegra30.dtsi            |   10 ++++
 arch/arm/mach-tegra/board-dt-tegra20.c    |    8 +++
 arch/arm/mach-tegra/board-dt-tegra30.c    |    9 ++++
 arch/arm/mach-tegra/clock.h               |    3 +-
 arch/arm/mach-tegra/tegra20_clocks_data.c |   12 +++---
 arch/arm/mach-tegra/tegra30_clocks.c      |   70 ++++++++++++++++++++++------
 arch/arm/mach-tegra/tegra30_clocks_data.c |   10 ++--
 8 files changed, 105 insertions(+), 27 deletions(-)

