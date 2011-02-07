Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1BGQua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:50:30 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59325 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab1BGQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:50:29 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Mqok/GBsl5DMmiI0ncaQW
Date: Mon, 7 Feb 2011 08:50:25 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.38-rc3
Message-ID: <20110207165024.GL20795@atomide.com>
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

This is mostly board specific and PM related fixes.

Regards,

Tony


The following changes since commit ebf53826e105f488f4f628703a108e98940d1dc5:

  Linux 2.6.38-rc3 (2011-02-01 13:05:49 +1000)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Aaro Koskinen (3):
      arm: mach-omap2: voltage: debugfs: fix memory leak
      arm: mach-omap2: board-rm680: fix rm680_vemmc regulator constraints
      arm: mach-omap2: mux: free allocated memory on error exit

Huang Weiyi (1):
      omap1: remove duplicated #include

Julia Lawall (1):
      OMAP: PM: SmartReflex: Add missing IS_ERR test

Kevin Hilman (1):
      OMAP3: PM: fix save secure RAM to restore MPU power state

Marek Vasut (1):
      OMAP1: Fix non-working LCD on OMAP310

Ming Lei (1):
      arm: omap4: panda: remove usb_nop_xceiv_register(v1)

Stefan Weil (2):
      OMAP: PM: SmartReflex: Fix possible memory leak
      OMAP: PM: SmartReflex: Fix possible null pointer read access

Thomas Weber (1):
      OMAP3: Devkit8000: Change lcd power pin

Tony Lindgren (1):
      Merge branch 'for_2.6.38/pm-fixes' of ssh://master.kernel.org/.../khilman/linux-omap-pm into devel-fixes

 arch/arm/mach-omap1/lcd_dma.c          |   24 ++++++++++++------------
 arch/arm/mach-omap1/time.c             |    1 -
 arch/arm/mach-omap2/board-devkit8000.c |   27 ++++++++++++++++-----------
 arch/arm/mach-omap2/board-omap4panda.c |    2 --
 arch/arm/mach-omap2/board-rm680.c      |    3 ---
 arch/arm/mach-omap2/mux.c              |    1 +
 arch/arm/mach-omap2/pm34xx.c           |    7 ++++---
 arch/arm/mach-omap2/smartreflex.c      |   11 +++++------
 arch/arm/mach-omap2/voltage.c          |    1 +
 9 files changed, 39 insertions(+), 38 deletions(-)
