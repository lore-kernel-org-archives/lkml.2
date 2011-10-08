Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1JHUlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 16:41:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57354 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1JHUlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 16:41:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, linus.walleij@linaro.org
Subject: [GIT PULL] final arm-soc fixes for 3.1
Date: Sat, 08 Oct 2011 22:40:39 +0200
Message-ID: <2473979.6NMHgbd7Ss@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iNKMDWaeaLNidLTjljHj7LJwewf8oRPNGug5G8epPHW
 SQRDb7QdOPE7GRGvWSTdEzhFQcEXaG0/Ack3jQzVb/n+tlN/LM
 YJ+e3Ch0J/DLJha771Kgz0Ur1SQ0zUfkhNBsf6VjRt3c1ps3Fr
 clwg3H2qHBEHUZ0HRaFyx1aqpUi9pJZ8EPx3iPs3zwfBM5PbM/
 7/db1W/JfiUI00rpIRizwFAl15EuT/Un2HI83A/KyObBz+G4p/
 m5n0pZD16+Um4qIgD1367E4VrAr1x5szJLQ3pvo8g+SgqMpUHk
 bDkbck0NGvwhEdjlhA85SKgRt3LXaBCAAktRRtdV0Ip8GH2mGb
 yRxi88fqmc69cq8Dn2Ic=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some last fixes from my side, please consider merging them into 3.1.
The majority of fixes that I received is now queued up in my next branch
for 3.2, but these are the ones that we agreed should still be merged before
the release.

	Arnd

The following changes since commit a102a9ece5489e1718cd7543aa079082450ac3a2:

  Linux 3.1-rc8 (2011-09-27 15:48:34 -0700)

are available in the git repository at:
  git://git.linaro.org/people/arnd/arm-soc.git fixes

Arnd Bergmann (1):
      Merge branch 'omap/fixes-for-3.1' into fixes

Axel Lin (1):
      ARM: OMAP: musb: Remove a redundant omap4430_phy_init call in usb_musb_init

Bryan Buckley (1):
      ARM: OMAP4: MMC: fix power and audio issue, decouple USBC1 from MMC1

Tony Lindgren (1):
      ARM: OMAP: Fix i2c init for twl4030

srinidhi kasagar (1):
      ARM: mach-ux500: enable fix for ARM errata 754322

 arch/arm/mach-omap2/board-2430sdp.c |    3 ++-
 arch/arm/mach-omap2/hsmmc.c         |   12 ++++--------
 arch/arm/mach-omap2/usb-musb.c      |    3 ---
 arch/arm/mach-ux500/Kconfig         |    1 +
 4 files changed, 7 insertions(+), 12 deletions(-)

