Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab2CAT10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:27:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64617 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab2CAT1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:27:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.180.193 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 0/8] ARM: Tegra: cleanup patches from Arnd Bergmann
Date: Thu,  1 Mar 2012 14:26:42 -0500
Message-Id: <1330630010-11241-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm helping Arnd Bergmann get some of his cleanup patches upstream. This
set covers the Tegra.

Thanks,

Alan.

Arnd Bergmann (8):
  ARM: tegra: export tegra_gpio_{en,dis}able
  ARM: tegra: do not hide dma declarations
  ARM: tegra: select CPU_FREQ_TABLE
  ARM: tegra: build localtimer support only when needed
  ARM: tegra: work around tegra THUMB2_KERNEL bug
  ARM: tegra: USB_ULPI needs USB
  ARM: tegra: export usb phy symbols
  ARM: tegra: HACK: remove set_irq_flags() from driver

 arch/arm/Kconfig                       |    1 +
 arch/arm/mach-tegra/Kconfig            |    2 ++
 arch/arm/mach-tegra/Makefile           |    3 ++-
 arch/arm/mach-tegra/include/mach/dma.h |    4 ----
 arch/arm/mach-tegra/usb_phy.c          |   10 ++++++++++
 drivers/gpio/gpio-tegra.c              |    2 ++
 drivers/usb/host/ehci-tegra.c          |    1 -
 7 files changed, 17 insertions(+), 6 deletions(-)

