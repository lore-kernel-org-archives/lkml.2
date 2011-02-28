Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1B1TmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:42:04 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15429 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab1B1Tlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:41:55 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Nhzd5+8BhTTSkNQ1b2uLy
Date: Mon, 28 Feb 2011 11:41:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.38-rc6
Message-ID: <20110228194151.GJ20560@atomide.com>
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

This contains one more timer regression fix, a DPLL rate fix,
and a mailbox NULL pointer fix that would be good to get
in for 2.6.38. The series also removes world-writable flag for
some debugfs entries.

Other than I believe that's it for omap fixes for v2.6.38.

Regards,

Tony


The following changes since commit f5412be599602124d2bdd49947b231dd77c0bf99:

  Linux 2.6.38-rc6 (2011-02-21 17:25:52 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

John Ogness (1):
      OMAP2/3: clock: fix fint calculation for DPLL_FREQSEL

Kevin Hilman (2):
      OMAP2420: mailbox: fix IVA vs DSP IRQ numbering
      OMAP2+: mailbox: fix lookups for multiple mailboxes

Paul Walmsley (1):
      OMAP2+: clocksource: fix crash on boot when !CONFIG_OMAP_32K_TIMER

Santosh Shilimkar (1):
      omap4: prcm: Fix the CPUx clockdomain offsets

Tony Lindgren (1):
      Merge branch 'patches_for_2.6.38rc' of git://git.pwsan.com/linux-2.6 into devel-fixes

Vasiliy Kulikov (3):
      mach-omap2: mux: world-writable debugfs files
      mach-omap2: pm: world-writable debugfs timer files
      mach-omap2: smartreflex: world-writable debugfs voltage files

 arch/arm/mach-omap2/clkt_dpll.c    |    2 +-
 arch/arm/mach-omap2/mailbox.c      |    2 +-
 arch/arm/mach-omap2/mux.c          |    2 +-
 arch/arm/mach-omap2/pm-debug.c     |    8 ++++----
 arch/arm/mach-omap2/prcm_mpu44xx.h |    4 ++--
 arch/arm/mach-omap2/smartreflex.c  |    4 ++--
 arch/arm/mach-omap2/timer-gp.c     |   13 +++++++++++++
 arch/arm/plat-omap/mailbox.c       |   11 +++++++----
 8 files changed, 31 insertions(+), 15 deletions(-)
