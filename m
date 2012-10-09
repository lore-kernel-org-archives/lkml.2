Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2JIPem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:34:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2JIPeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:34:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 0/3] new ARM-soc warning fixes
Date: Tue,  9 Oct 2012 17:34:18 +0200
Message-Id: <1349796861-31164-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
X-Provags-ID: V02:K0:sH82+jroFmNIDLaO0VJBtG/fJhV7s7LaOGpCcp0DxZe
 O8Zd9eiZPCX6iSAPSP0bfJLY1oJTnpEtholkQQSzqEa+KZaG6l
 KtolqcDUNZ3dkhZ0PElAf/h0Xed8hAYF0ymdRtvsKuUMPzwimf
 Tq36E4lBGVLBRCR4pv1ic2CEOWSQimWsHj5UWKm4EwTNnYrQ7C
 NjHjxWXHKK7tYIYl+vgG4xfnDA/Xgk987QLfbXNYwIBVSIii5X
 aVGqEtr3BcDmwFns2u/PSKjp1Kt3SgTGFSJyXWRFsCB15IycBu
 4AkUB1XANeLcq4Vlzd9pab/XHcC+G886aGG3TVl1V8jmweJ9E/
 4fvkjGn8qpLrxmxlkgf5ZsC9EaSL0B9YzbFykKwnpTioDhmH1J
 LIQCui+Gldi50OC6HwiVOZ3mqrKKCAVaK8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

Here are three more fixes that I'd like to merge through the arm-soc
as time permits. All of them should be completely harmless and they
only fix harmless gcc warnings.

I don't know what your plans are for sending the next fixes branch.
I've uploaded these into a new "fixes2" branch on top of the patches
that are already in "fixes". We can either send them all together,
or you send the ones that are already queued first and these ones
with the next batch. Feel free to rebase if necessary.

	Arnd

Arnd Bergmann (3):
  ARM: shmobile: mark shmobile_init_late as __init
  ARM: assabet: fix bogus warning in get_assabet_scr (again)
  ARM: integrator: use __iomem pointers for MMIO, part 2

 arch/arm/mach-integrator/include/mach/cm.h       |    2 +-
 arch/arm/mach-integrator/include/mach/platform.h |    6 +++---
 arch/arm/mach-integrator/integrator_ap.c         |    2 +-
 arch/arm/mach-integrator/integrator_cp.c         |    4 ++--
 arch/arm/mach-sa1100/assabet.c                   |    2 +-
 arch/arm/mach-shmobile/include/mach/common.h     |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

-- 
1.7.10

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Magnus Damm <damm@opensource.se>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Simon Horman <horms@verge.net.au>
