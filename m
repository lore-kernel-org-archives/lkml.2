Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1CZTA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:00:57 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:17965 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1CZTA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:00:56 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX198YqRNV6D8V5mnEqgT6B7n
Date: Sat, 26 Mar 2011 12:00:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap-fixes for -rc1
Message-ID: <20110326190052.GB571@atomide.com>
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

This series includes a fix for GPMC (General Purpose Memory Controller)
interrupts to work for omap2 and 4 in addition to omap3, and get
rid of the related warnings. It also fixes a mystery shutdown issue
on Panda board by removing unused regulators. Other fixes are quite
trivial, also included is the change to make hwspinlock depend on
ARCH_OMAP4.

Regards,

Tony


The following changes since commit 16c29dafcc86024048f1dbb8349d31cb22c7c55a:

  Merge branch 'syscore' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6 (2011-03-25 21:07:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Aaro Koskinen (2):
      arm: mach-omap2: devices: fix omap3_l3_init() return value
      arm: mach-omap2: omap_l3_smx: fix irq handler setup

Balaji T K (1):
      ARM: OMAP2+: Fix warnings for GPMC interrupt

David Anders (1):
      OMAP4: PandaBoard: remove unused power regulators

Ohad Ben-Cohen (1):
      hwspinlock: depend on OMAP4

 arch/arm/mach-omap2/board-omap4panda.c |   28 ----------------------------
 arch/arm/mach-omap2/devices.c          |    2 +-
 arch/arm/mach-omap2/gpmc.c             |   13 ++++++++-----
 arch/arm/mach-omap2/omap_l3_smx.c      |   11 ++++-------
 arch/arm/plat-omap/include/plat/irqs.h |    2 +-
 drivers/hwspinlock/Kconfig             |    1 +
 6 files changed, 15 insertions(+), 42 deletions(-)
