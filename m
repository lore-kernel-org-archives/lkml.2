Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0HZXKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:10:41 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:63145 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0HZXKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:10:39 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Vi/LAtMmkguRNAIZtbFHF
Date: Thu, 26 Aug 2010 16:10:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.36
Message-ID: <20100826231035.GE12567@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap-fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit 76be97c1fc945db08aae1f1b746012662d643e97:

  Linux 2.6.36-rc2 (2010-08-22 17:43:29 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Kevin Hilman (1):
      OMAP3: PM: ensure IO wakeups are properly disabled

Nishanth Menon (1):
      omap3: id: fix 3630 rev detection

Tony Lindgren (3):
      omap: Fix sev instruction usage for multi-omap
      omap: Use CONFIG_SMP for test_for_ipi and test_for_ltirq
      omap: Fix omap_4430sdp_defconfig for make oldconfig

stanley.miao (1):
      OMAP3: Fix a cpu type check problem

 arch/arm/configs/omap_4430sdp_defconfig        |    3 +++
 arch/arm/mach-omap2/Makefile                   |    1 +
 arch/arm/mach-omap2/clock3xxx_data.c           |   14 +++++++-------
 arch/arm/mach-omap2/id.c                       |    2 +-
 arch/arm/mach-omap2/include/mach/entry-macro.S |    6 ++++--
 arch/arm/mach-omap2/omap-smp.c                 |    3 +--
 arch/arm/mach-omap2/pm34xx.c                   |    4 +++-
 arch/arm/plat-omap/include/plat/smp.h          |    7 -------
 8 files changed, 20 insertions(+), 20 deletions(-)
