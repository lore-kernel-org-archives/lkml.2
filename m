Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2LLQkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:40:55 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50510 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab2LLQky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:40:54 -0500
Date: Wed, 12 Dec 2012 08:40:52 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 1/5] ARM: arm-soc: Non-critical bug fixes
Message-ID: <20121212164052.GA16288@quad.lixom.net>
References: <20121212163942.GA16036@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212163942.GA16036@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Simple bug fixes that were not considered important enough for inclusion
into 3.7, especially those that arrived late during the merge window.

There's also a MAINTAINERS update for the Renesas platforms in here,
marking Simon Horman as a maintainer and changing the git url to his tree.


No conflicts.

----------------------------------------------------------------

The following changes since commit 1ebaf4f4e6912199f8a4e30ba3ab55da2b71bcdf:

  Merge branch 'x86-timers-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-non-critical

for you to fetch changes up to 0a9995e46f3f9cb28360c89892b939420ac3fa2e:

  Merge branch 'maintainers' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/fixes-non-critical

----------------------------------------------------------------

Alexander Shiyan (1):
      ARM: Fix Kconfig symbols typo for LEDS

Andrea Adami (2):
      ARM: pxa: fix pxa25x gpio wakeup setting
      ARM: pxa: add dummy SA1100 rtc clock in pxa25x

Arnd Bergmann (4):
      Merge branch 'vexpress-fixes' of git://git.linaro.org/people/pawelmoll/linux into next/fixes-non-critical
      ARM: vexpress: fix ll debug code when building multiplatform
      Merge tag 'omap-for-v3.8/fixes-non-critical-v4-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge tag 'ixp4xx_fixes_for_3.7' of git://git.infradead.org/users/jcooper/linux into fixes

Colin Cross (1):
      ARM: OMAP4: retrigger localtimers after re-enabling gic

Henrique Camargo (1):
      ARM: davinci: serial.h: fix uart number in the comment

Imre Kaloz (1):
      ARM: cns3xxx: drop unnecessary symbol selection

Kevin Hilman (1):
      ARM: OMAP4: PM: fix errata handling when CONFIG_PM=n

Olof Johansson (4):
      Merge tag 'davinci-for-v3.8/fixes' of git://gitorious.org/linux-davinci/linux-davinci into next/fixes-non-critical
      Merge branch 'armsoc/fix' of git://github.com/hzhuang1/linux into next/fixes-non-critical
      Merge branch 'armsoc/fix' of git://github.com/hzhuang1/linux into next/fixes-non-critical
      Merge branch 'maintainers' of git://git.kernel.org/.../horms/renesas into next/fixes-non-critical

Pawel Moll (1):
      ARM: vexpress: Make the debug UART detection more specific

Santosh Shilimkar (1):
      ARM: OMAP4460: Workaround for ROM bug because of CA9 r2pX GIC control register change.

Sekhar Nori (1):
      ARM: davinci: uncompress.h: bail out if uart not initialized

Simon Horman (1):
      Update ARM/SHMOBILE section of MAINTAINERS

Tero Kristo (1):
      ARM: OMAP4: PM: add errata support

Tony Lindgren (1):
      Merge tag 'for_3.8-fixes-pm' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-for-v3.8/fixes-non-critical-v2

Wei Yongjun (2):
      ARM: davinci: dm644x evm: move pointer dereference below NULL check
      ARM: davinci: fix return value check by using IS_ERR in tnetv107x_devices_init()


 MAINTAINERS                                     |  4 +-
 arch/arm/include/debug/vexpress.S               | 11 +++--
 arch/arm/mach-cns3xxx/Kconfig                   |  1 -
 arch/arm/mach-davinci/board-dm644x-evm.c        |  5 ++-
 arch/arm/mach-davinci/devices-tnetv107x.c       |  2 +-
 arch/arm/mach-davinci/include/mach/serial.h     |  2 +-
 arch/arm/mach-davinci/include/mach/uncompress.h |  6 +++
 arch/arm/mach-omap2/common.h                    |  4 ++
 arch/arm/mach-omap2/omap-headsmp.S              | 38 ++++++++++++++++++
 arch/arm/mach-omap2/omap-mpuss-lowpower.c       |  9 ++++-
 arch/arm/mach-omap2/omap-smp.c                  | 41 ++++++++++++++++++-
 arch/arm/mach-omap2/omap4-common.c              | 42 +++++++++++++++++++-
 arch/arm/mach-omap2/pm.h                        |  9 +++++
 arch/arm/mach-pxa/pxa25x.c                      |  6 +++
 arch/arm/mach-s3c24xx/Kconfig                   |  2 +-
 arch/arm/plat-versatile/Kconfig                 |  2 +-
 16 files changed, 168 insertions(+), 16 deletions(-)
