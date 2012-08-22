Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab2HVPN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:13:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab2HVPNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:13:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Artem Bityutskiy <dedekind1@gmail.com>,
        Eric Miao <eric.miao@linaro.org>, Kevin Hilman <khilman@ti.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Yong Shen <yong.shen@linaro.org>
Subject: [PATCH 0/6] ARM: randconfig bugs
Date: Wed, 22 Aug 2012 17:13:04 +0200
Message-Id: <1345648390-4234-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
X-Provags-ID: V02:K0:RmdIHCsOWp2Ap9nDAU6LpdW9eWg8S7nhXXq2b4xB8+6
 6F7AuRgzspZ35TQvBZ7NQTB+83D7iKLl6cgvU1YGyn+XZl42c6
 uP2S1lB0odZqn+4TGnwJ4VCB9Rk1u1fDKCQJ025chp9lyPsUOz
 ZoDsyCF1AhOcl0Xreezi62Z2EUdiAY1q7GbN6BTyRCIuzu+J2I
 jKejwhYH3oFB2yYk/vAjwBqSBJ9LWYOx5c6827QJ7zyLeGb1GT
 KOJArKmq4bV/KNHgRCZOKUIK15DdVbZiwM6R65y+gnp1CzUJMd
 7DimNFQnuMDv5qtZInt6XhbsJDxFTArektZQgtscN9YwHnSwgk
 XmNo8OGmPDpOBWwUvcwI8A1WAdbsaawcOzJSH79dP+0yhJdR03
 9jfefvNe0uTzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Here are some more patches for bugs I found using
'make randconfig' in v3.6-rc+multiplatform. I can
to merge them through the arm-soc tree, but please
have a look and provide Acks.

	Arnd

---
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Eric Miao <eric.miao@linaro.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yong Shen <yong.shen@linaro.org>


Arnd Bergmann (6):
  ARM: ux500: don't select LEDS_GPIO for snowball
  ARM: omap: allow building omap44xx without SMP
  ARM: imx: build pm-imx5 code only when PM is enabled
  ARM: imx: fix ksz9021rn_phy_fixup
  ARM: imx: select CPU_FREQ_TABLE when needed
  ARM: imx: select ARM_CPU_SUSPEND when necessary

 arch/arm/Kconfig                  |    1 +
 arch/arm/mach-imx/Kconfig         |    1 +
 arch/arm/mach-imx/Makefile        |    3 ++-
 arch/arm/mach-imx/mach-imx6q.c    |    4 ++--
 arch/arm/mach-omap2/Kconfig       |    2 +-
 arch/arm/mach-omap2/cpuidle44xx.c |    3 ++-
 arch/arm/mach-ux500/Kconfig       |    1 -
 include/linux/cpuidle.h           |    4 ++++
 8 files changed, 13 insertions(+), 6 deletions(-)

-- 
1.7.10

