Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2EZHXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:23:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63447 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EZHXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:23:03 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/8] arm-soc: defconfig updates
Date: Sat, 26 May 2012 00:22:31 -0700
Message-Id: <1338016958-7887-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1338016958-7887-1-git-send-email-olof@lixom.net>
References: <1338016958-7887-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the first time, we have one branch that collects just updates to
defconfig files, mostly for adapting to changes in other subsystems.

----------------------------------------------------------------

The following changes since commit 786f02b719f2285e2c0350b6a04dab4a1a0871a1:

  Merge tag 'x86-mce-merge' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/defconfig

for you to fetch changes up to 4a230408e83698a3d7ff0a9988a58675c2c92cb9:

  ARM: PRIMA2: add prima2_defconfig for CSR SiRFprimaII

----------------------------------------------------------------

Arnd Bergmann (2):
      Merge tag 'imx-defconfig' of git://git.pengutronix.de/git/imx/linux-2.6 into next/defconfig
      Merge branch 'for-3.5/defconfig2' of git://git.kernel.org/.../swarren/linux-tegra into next/defconfig

Barry Song (1):
      ARM: PRIMA2: add prima2_defconfig for CSR SiRFprimaII

Fabio Estevam (2):
      ARM: imx_v4_v5_defconfig: Let CONFIG_MACH_IMX27_DT be built by default
      ARM: imx_v6_v7_defconfig: Add SPI NOR support

Laxman Dewangan (1):
      ARM: tegra: update defconfig

Olof Johansson (1):
      Merge branch 'for-3.5/defconfig' of git://git.kernel.org/.../swarren/linux-tegra into next/defconfig

Stephen Warren (1):
      ARM: tegra: update defconfig


 arch/arm/configs/imx_v4_v5_defconfig |  1 +
 arch/arm/configs/imx_v6_v7_defconfig |  6 +++
 arch/arm/configs/prima2_defconfig    | 69 +++++++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig     | 11 ++++-
 4 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/configs/prima2_defconfig
