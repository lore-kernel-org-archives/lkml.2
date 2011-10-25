Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1JYQyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:54:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9234 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1JYQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:54:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 25 Oct 2011 09:54:24 -0700
From: <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 0/6] Add support for tegra30 and cardhu
Date: Tue, 25 Oct 2011 19:53:54 +0300
Message-ID: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter De Schrijver <pdeschrijver@nvidia.com>

This patchset adds support for the tegra30 SoC and the cardhu development
board.

Peter De Schrijver (6):
  arm/tegra: initial device tree for tegra30
  arm/tegra: prepare pinmux code for multiple tegra variants
  arm/tegra: prepare early init for multiple tegra variants
  arm/tegra: implement support for tegra30
  arm/tegra: pinmux tables and definitions for tegra30
  arm/tegra: add support for tegra30 based board cardhu

 arch/arm/boot/dts/tegra-cardhu.dts                |   37 ++
 arch/arm/boot/dts/tegra30.dtsi                    |  128 +++++++
 arch/arm/mach-tegra/Kconfig                       |   24 +-
 arch/arm/mach-tegra/Makefile                      |    3 +-
 arch/arm/mach-tegra/Makefile.boot                 |    1 +
 arch/arm/mach-tegra/board-dt.c                    |   21 ++
 arch/arm/mach-tegra/board-harmony-pcie.c          |    1 +
 arch/arm/mach-tegra/board-harmony-pinmux.c        |    1 +
 arch/arm/mach-tegra/board-harmony.c               |    2 +-
 arch/arm/mach-tegra/board-paz00-pinmux.c          |    1 +
 arch/arm/mach-tegra/board-paz00.c                 |    2 +-
 arch/arm/mach-tegra/board-seaboard-pinmux.c       |    2 +-
 arch/arm/mach-tegra/board-seaboard.c              |    6 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c      |    1 +
 arch/arm/mach-tegra/board-trimslice.c             |    2 +-
 arch/arm/mach-tegra/board.h                       |    5 +-
 arch/arm/mach-tegra/common.c                      |   28 ++-
 arch/arm/mach-tegra/include/mach/pinmux-t2.h      |  184 ----------
 arch/arm/mach-tegra/include/mach/pinmux-tegra20.h |  184 ++++++++++
 arch/arm/mach-tegra/include/mach/pinmux-tegra30.h |  320 ++++++++++++++++++
 arch/arm/mach-tegra/include/mach/pinmux.h         |   92 +++++-
 arch/arm/mach-tegra/pinmux-t2-tables.c            |  228 -------------
 arch/arm/mach-tegra/pinmux-tegra20-tables.c       |  239 +++++++++++++
 arch/arm/mach-tegra/pinmux-tegra30-tables.c       |  376 +++++++++++++++++++++
 arch/arm/mach-tegra/pinmux.c                      |  148 ++++++---
 25 files changed, 1540 insertions(+), 496 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra-cardhu.dts
 create mode 100644 arch/arm/boot/dts/tegra30.dtsi
 delete mode 100644 arch/arm/mach-tegra/include/mach/pinmux-t2.h
 create mode 100644 arch/arm/mach-tegra/include/mach/pinmux-tegra20.h
 create mode 100644 arch/arm/mach-tegra/include/mach/pinmux-tegra30.h
 delete mode 100644 arch/arm/mach-tegra/pinmux-t2-tables.c
 create mode 100644 arch/arm/mach-tegra/pinmux-tegra20-tables.c
 create mode 100644 arch/arm/mach-tegra/pinmux-tegra30-tables.c

-- 
1.7.7.rc0.72.g4b5ea.dirty

