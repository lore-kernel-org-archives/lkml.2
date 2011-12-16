Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab1LPPlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:41:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51937 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759804Ab1LPPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:41:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for 3.2, part 4
Date: Fri, 16 Dec 2011 15:41:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112161541.18525.arnd@arndb.de>
X-Provags-ID: V02:K0:epNa/QxoBn9iXZ6+TRbfKWUzXGt/PfFum8wgCTaDYMH
 gLN7SBIMFR3bKybhbVGfVkX7AlBQ/11Wj8dADsAe+xNaS2M5vY
 wy7NafQcjotRIteDOREVZ6DbmWguCBo+BSs54sO07l00TigHy4
 g3CrUb3Ip00QJR3PgEqu5vAifdak1UHTNPnB3FXlJoab2tkHW8
 GIsk883xTBGZGyffKimXevR1aU9DdU+VxBvte1fvw8ZJoZQ/8v
 l6SpCbYf1etPXfapK6bAcaLgHZND9WDZexcmVbGZ/e/TkgR9bu
 QRb7oXPRrEKiNTwWccUF3dUz6KZRR7QXaI7BAEIliD5oEZH3gh
 4m1KSbZ7yl8TDkVE6Rus=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the current set of fixes for v3.2. The majority of these are
i.mx platform fixes that came slightly too late for the previous round.

	Arnd
---
The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

Amit Daniel Kachhap (1):
      ARM: EXYNOS: Fix for stall in case of cpu hotplug or sleep

Arnd Bergmann (1):
      Merge branch 'imx-fixes-for-arnd' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes

Dong Aisheng (1):
      ARM: mx5: add __initconst for fec pdata

Felipe Contreras (1):
      ARM: OMAP: rx51: fix USB

Jarkko Nikula (1):
      ARM: OMAP: mcbsp: Fix possible memory corruption

Jason Chen (1):
      MXC PWM: should active during DOZE/WAIT/DBG mode

Jingoo Han (2):
      ARM: SAMSUNG: remove duplicated header include
      ARM: S5PV210: Set 1000ns as PWM backlight period on SMDKV210

Kukjin Kim (1):
      ARM: EXYNOS: Fix build error without CONFIG_LOCAL_TIMERS

Olof Johansson (2):
      Merge branch 'fixes' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'samsung-fixes-3' of git://git.kernel.org/.../kgene/linux-samsung into fixes

Richard Zhao (1):
      ARM: imx: fix cpufreq build errors

Shawn Guo (1):
      arm/imx: fix power button on imx51 babbage board

 arch/arm/mach-exynos/mct.c                   |   13 ++++++++++---
 arch/arm/mach-mx5/board-mx51_babbage.c       |    2 +-
 arch/arm/mach-mx5/board-mx53_evk.c           |    2 +-
 arch/arm/mach-mx5/board-mx53_loco.c          |    2 +-
 arch/arm/mach-mx5/board-mx53_smd.c           |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 arch/arm/mach-omap2/mcbsp.c                  |    6 +++---
 arch/arm/mach-s5pv210/mach-smdkv210.c        |    1 +
 arch/arm/plat-mxc/cpufreq.c                  |    1 +
 arch/arm/plat-mxc/pwm.c                      |    7 ++++++-
 arch/arm/plat-samsung/dev-backlight.c        |    1 -
 11 files changed, 26 insertions(+), 13 deletions(-)
