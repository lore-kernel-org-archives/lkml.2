Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2J2HWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:22:02 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3006 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2J2HWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:22:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 29 Oct 2012 00:21:59 -0700
From: Danny Huang <dahuang@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Danny Huang <dahuang@nvidia.com>
Subject: [PATCH 0/2] ARM: tegra: add speedo identification for T20/T30
Date: Mon, 29 Oct 2012 15:21:53 +0800
Message-ID: <1351495315-3282-1-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.8.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds speedo identification functionality for tegra
T20 and T30. It reads speedo value from fuse and chooses CPU and core 
process ID by checking speedo corner tables.

Danny Huang (2):
  ARM: tegra: Add speedo-based process identification
  ARM: tegra: T30 speedo-based identification

 arch/arm/mach-tegra/Makefile         |   2 +
 arch/arm/mach-tegra/fuse.c           |  35 +++--
 arch/arm/mach-tegra/fuse.h           |  16 ++
 arch/arm/mach-tegra/tegra20_speedo.c | 102 ++++++++++++
 arch/arm/mach-tegra/tegra30_speedo.c | 290 +++++++++++++++++++++++++++++++++++
 5 files changed, 433 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm/mach-tegra/tegra20_speedo.c
 create mode 100644 arch/arm/mach-tegra/tegra30_speedo.c

-- 
1.8.0

