Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0F3LjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:39:13 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62589 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0F3LjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 07:39:11 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18wHjJbdMCTxoI+A82+zIj/
Date: Wed, 30 Jun 2010 14:39:19 +0300
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] omap fixes for 2.6.35-rc3
Message-ID: <20100630113919.GB2822@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

These all should match your "major bugs or regressions" criteria for
various omaps :)

Regards,

Tony


The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes

Amit Kucheria (1):
      omap: fix build failure due to missing include dma-mapping.h

Benoit Cousson (1):
      OMAP: hwmod: Fix the missing braces

Kevin Hilman (2):
      omap: GPIO: fix auto-disable of debounce clock
      OMAP3: PM: fix IO daisy chain enable to use PM_WKEN reg

Santosh Shilimkar (2):
      omap: Stalker board: switch over to gpio_set_debounce
      OMAP4: clock: Fix multi-omap boot with reset un-used clocks

Satish (1):
      omap iommu: Fix Memory leak

Tero Kristo (1):
      omap: DMTIMER: Ack pending interrupt always when stopping a timer

Tony Lindgren (1):
      Merge branch 'for_2.6.35rc' of git://git.pwsan.com/linux-2.6 into omap-fixes-for-linus

 arch/arm/mach-omap2/board-omap3stalker.c |    4 +---
 arch/arm/mach-omap2/clock44xx_data.c     |    2 ++
 arch/arm/mach-omap2/omap_hwmod.c         |    9 ++++++---
 arch/arm/mach-omap2/pm34xx.c             |    4 ++--
 arch/arm/mach-omap2/usb-ehci.c           |    2 ++
 arch/arm/plat-omap/dmtimer.c             |    6 +++---
 arch/arm/plat-omap/gpio.c                |    1 +
 arch/arm/plat-omap/iovmm.c               |    4 +++-
 8 files changed, 20 insertions(+), 12 deletions(-)
