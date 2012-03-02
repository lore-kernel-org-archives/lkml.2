Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab2CBU6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:58:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42922 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab2CBU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:58:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.116.195 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v2 0/6] ARM: Tegra: cleanup patches from Arnd Bergmann
Date: Fri,  2 Mar 2012 15:58:04 -0500
Message-Id: <1330721884-8495-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the mess yesterday....
This is V2 of Arnd's Patch series from yesterday. Hopefully this one will be
smoother.

Changes:
	* set_irq_flags() removal patch is out
	* driver-only patch has been moved to another set
	* Distribution list should be cleaner
	* Added proper sign-off
	* Select CPU_FREQ_TABLE for ARCH_TEGRA_3x_SOC as well
	* Fixed spacing on the localtimer patch
	* added linux/export.h to the export usb phy symbols patch

Arnd Bergmann (6):
  ARM: tegra: do not hide dma declarations
  ARM: tegra: select CPU_FREQ_TABLE
  ARM: tegra: build localtimer support only when needed
  ARM: tegra: work around tegra THUMB2_KERNEL bug
  ARM: tegra: USB_ULPI needs USB
  ARM: tegra: export usb phy symbols

 arch/arm/Kconfig                       |    1 +
 arch/arm/mach-tegra/Kconfig            |    3 +++
 arch/arm/mach-tegra/Makefile           |    3 ++-
 arch/arm/mach-tegra/include/mach/dma.h |    4 ----
 arch/arm/mach-tegra/usb_phy.c          |   11 +++++++++++
 5 files changed, 17 insertions(+), 5 deletions(-)

