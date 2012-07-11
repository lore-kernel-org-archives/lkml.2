Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab2GKTes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:34:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58845 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GKTeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:34:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for 3.5-rc6
Date: Wed, 11 Jul 2012 19:34:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111934.35953.arnd@arndb.de>
X-Provags-ID: V02:K0:c5F6MnXn6/mN6bCFrUDBHzgWfXALyKUJuwH6y7bjRBB
 O4sZpGxRsZPSXvfB1QNJKUyks5uFBAmz7NqeeDISIY5LiYJBHe
 ZtOVR0kwh7b8x/OHDLqZV0dY01KGkiFSGaGrTiqQ+TR4o9HV13
 gwNda2Lo8kT/gYl4h5rLf3EDE2Y4GrzhU6xjS36B6ISuTVAcfQ
 mbyR9u0H/pJ4aw8cKAcMcBi6VZCnyRXaR1H7JLWNfhccPtiWMd
 oWkVB2cjW8lnZHQ7bx+eckAKXByt5bp7EcdV9q7XhVRuX1ZiCA
 bZ9JKu+iomTDyRXze0Y5tNdmRiueSxgEhrQyCeI/RYqyvOjpXD
 qVTIsmtLhBse8fZ23XHM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Another set of fixes, this time with a proper URL. For some reason the last
time I sent the pull request it would use the "fixes" branch when I gave
it the regular git URL and the signed tag when I gave it the ra.kernel.org
URL, and I forgot that this would not be a world-readable URL. This time
it worked either way, so here is the normal one.
The branch is based on top of the previous changeset that you already
pulled, not based on an -rc this time.

	Arnd

The following changes since commit e15ebe05cce44c5164dbf8489841c18a887bcfc2:

  Merge tag 'omap-fixes-for-v3.5-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2012-07-05 12:16:13 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 9861e9551f443bb2e8dacd4b9572cb8dab0f3ad7:

  Merge tag 'omap-fixes-for-v3.5-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2012-07-10 16:12:39 +0200)

----------------------------------------------------------------

ARM: SoC fixes for 3.5-rc

* multiple omap2+ bug fixes
* a regression on ux500 dt support
* a build failure on shmobile

----------------------------------------------------------------
Arnd Bergmann (2):
      Merge branch 'ux500/fixes-3.5' into fixes
      Merge tag 'omap-fixes-for-v3.5-rc6' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Kevin Hilman (1):
      ARM: OMAP2+: omap2plus_defconfig: EHCI driver is not stable, disable it

Lee Jones (3):
      of: address: Don't fail a lookup just because a node has no reg property
      ARM: ux500: Fix build errors/warnings when MACH_UX500_DT is not set
      ARM: ux500: Over-ride the DT device naming scheme for pinctrl

Magnus Damm (1):
      ARM: shmobile: fix platsmp.c build when ARCH_SH73A0=n

Paul Walmsley (1):
      ARM: OMAP2+: hwmod code/clockdomain data: fix 32K sync timer

Tony Lindgren (1):
      Merge branch 'for_3.5/fixes/pm-3' of git://git.kernel.org/.../khilman/linux-omap-pm into fixes

 arch/arm/configs/omap2plus_defconfig             |    1 -
 arch/arm/mach-omap2/clockdomain.h                |    4 +++
 arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c |    1 +
 arch/arm/mach-omap2/clockdomains44xx_data.c      |    2 +-
 arch/arm/mach-omap2/omap_hwmod.c                 |   32 ++++++++++++++++------
 arch/arm/mach-shmobile/platsmp.c                 |    5 ++++
 arch/arm/mach-ux500/board-mop500.c               |   12 ++++----
 arch/arm/mach-ux500/timer.c                      |    2 ++
 drivers/of/platform.c                            |    7 ++---
 9 files changed, 47 insertions(+), 19 deletions(-)
