Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1D2LD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 07:03:27 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:35783 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751995Ab1D2LD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 07:03:26 -0400
X-Greylist: delayed 2796 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Apr 2011 07:03:26 EDT
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+S2c6u9mLyxlPLsLwazqV
Date: Fri, 29 Apr 2011 03:16:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.39-rc5
Message-ID: <20110429101647.GW3755@atomide.com>
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

Most of the diffstat is fixing clock related flags, the kind
of stuff that will be eventually coming from device tree as
discussed earlier. Anyways necessariy fixes for correct clocking
for the -rc cycle.  

The other patches are quite trivial one liner fixes.

Regards,

Tony


The following changes since commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58:
  Linus Torvalds (1):
        Linux 2.6.39-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Avinash.H.M (1):
      OMAP2/3: hwmod: fix gpio-reset timeouts seen during bootup.

Benoit Cousson (1):
      OMAP2+: hwmod data: Fix wrong dma_system end address

Eduardo Valentin (2):
      OMAP2+: PM: Fix the saving of CM_AUTOIDLE_PLL register on scratchpad area
      OMAP3: PM: Do not rely on ROM code to restore CM_AUTOIDLE_PLL.AUTO_PERIPH_DPLL

Felipe Contreras (1):
      omap: rx51: mark reserved memory earlier

Nishanth Menon (1):
      OMAP3+: voltage: remove initial voltage

Oskar Andero (1):
      arm: omap2: enable smc instruction for sleep34xx

Shweta Gulati (1):
      OMAP4: Intialize IVA Device in addition to DSP device.

Tomi Valkeinen (1):
      OMAP4: clock data: Change DSS clock aliases

Tony Lindgren (1):
      Merge branch 'for_tony_a_2.6.39rc' of git://git.pwsan.com/linux-2.6 into devel-fixes

omar ramirez (1):
      OMAP3: l3: fix for "irq 10: nobody cared" message

 arch/arm/mach-omap2/Makefile               |    2 +-
 arch/arm/mach-omap2/board-rx51.c           |    9 +++++++--
 arch/arm/mach-omap2/clock44xx_data.c       |    9 ++-------
 arch/arm/mach-omap2/cm2xxx_3xxx.c          |   17 +++++++++++++++++
 arch/arm/mach-omap2/control.c              |    8 +++++++-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c |    6 +++++-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c |    7 ++++++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    8 +++++++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    2 +-
 arch/arm/mach-omap2/omap_l3_smx.c          |    4 ++--
 arch/arm/mach-omap2/pm.c                   |    1 +
 arch/arm/mach-omap2/voltage.c              |    1 -
 12 files changed, 56 insertions(+), 18 deletions(-)
