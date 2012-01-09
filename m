Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457Ab2AIWQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:16:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51482 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893Ab2AIWOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:14:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 01/11] Non-critical bug fixes
Date: Mon,  9 Jan 2012 22:12:41 +0000
Message-Id: <1326147171-13752-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:++aoLRdta2Tg9PbjBxxor5f9ZNqcqRsU7sWtfmokQ3y
 NFbx2hb3832ruGi7kbwPfJWZ1gGDlmOUTevs965zblsmaO8y6o
 2bU2mrcOb8HddVxAQmmrRtLJn8p0OcyHIH2SsJ3SmnbU5ie7BU
 Ar8Sm8DGu3prclVVDipJN7hMAuBmPse3TSOw/vTwh8L/eIhUMO
 3nP/rfiOzVibSyaDVCTHShodf4mxS7OH75aILDTds6ZeFfQmXn
 LYLoOUg1CqSCrS6aRlKYipY+vImE2Ga53T4IpaB7lwzmgs7W67
 7rKC6ep3fApdJWAo9TOFgtS9InDuyzhFZrwOGCCAEOoOqHnNBj
 GpgYUPvx3u5qNqEa7btGQqKhkrsJeEda1RcmrD/pUw+yVQ2Wzx
 533SIMEX7hIMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple bug fixes that were not considered important enough for inclusion
into 3.2.

The following changes since commit 7b9dd47136c07ffd883aff6926c7b281e4c1eea4:

  Merge branch 'restart' into for-linus (2012-01-05 13:25:27 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/fixes-non-critical

Aaro Koskinen (1):
      ARM: OMAP: hwmod data: fix the panic on Nokia RM-680 during boot

Arnd Bergmann (1):
      Merge branch 'pxa/fixes-non-critical' into next/fixes-non-critical

Axel Lin (1):
      ARM: pxa: Include linux/export.h in balloon3.c

Benoit Cousson (1):
      ARM: OMAP4: hwmod: Don't wait for the idle status if modulemode is not supported

Haojian Zhuang (1):
      MAINTAINERS: update pxa and mmp

Olof Johansson (4):
      Merge branch 'fixes-non-critical' of git://git.kernel.org/.../tmlind/linux-omap into omap/fixes-non-critical
      Merge branch 'omap/fixes-non-critical' into next/fixes-non-critical
      Merge branch 'omap/fixes-hwmod' into next/fixes-non-critical
      Merge branch 'omap/fixes-non-critical-part2' into next/fixes-non-critical

Paul Walmsley (1):
      ARM: OMAP: AM3517/3505: fix crash on boot due to incorrect voltagedomain data

Peter Ujfalusi (2):
      ARM: OMAP2+: DMA: Workaround for invalid source position
      ARM: OMAP2+: DMA: Workaround for invalid destination position

Santosh Shilimkar (1):
      ARM: OMAP4: clock: Add CPU local timer clock node

Tony Lindgren (1):
      Merge branch 'hwmod_data_fixes_3.2rc' of git://git.pwsan.com/linux-2.6 into fixes-hwmod

 MAINTAINERS                                   |   22 ++----
 arch/arm/mach-omap2/clock44xx_data.c          |    9 ++
 arch/arm/mach-omap2/omap_hwmod.c              |   98 ++++++++++++------------
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c    |   14 +++-
 arch/arm/mach-omap2/voltagedomains3xxx_data.c |   40 +++++++++--
 arch/arm/mach-pxa/balloon3.c                  |    1 +
 arch/arm/plat-omap/dma.c                      |   22 +++++-
 7 files changed, 134 insertions(+), 72 deletions(-)
