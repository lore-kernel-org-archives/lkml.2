Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059Ab2CBWYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:24:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38171 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964787Ab2CBWYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:24:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.185.42 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v3 0/5] ARM: Tegra: cleanup patches from Arnd Bergmann
Date: Fri,  2 Mar 2012 17:24:35 -0500
Message-Id: <1330727075-10974-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330721884-8495-1-git-send-email-alan@signal11.us>
References: <1330721884-8495-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 3 of the patch set.

Changes:
	* change of logic (and commit message change) for
	  "select USB_ULPI if USB is selected"
	* dropped THUMB2 patch

Arnd Bergmann (5):
  ARM: tegra: do not hide dma declarations
  ARM: tegra: select CPU_FREQ_TABLE
  ARM: tegra: build localtimer support only when needed
  ARM: tegra: select USB_ULPI if USB is selected
  ARM: tegra: export usb phy symbols

 arch/arm/mach-tegra/Kconfig            |    6 ++++--
 arch/arm/mach-tegra/Makefile           |    3 ++-
 arch/arm/mach-tegra/include/mach/dma.h |    4 ----
 arch/arm/mach-tegra/usb_phy.c          |   11 +++++++++++
 4 files changed, 17 insertions(+), 7 deletions(-)

