Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1AaSFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:05:05 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31407 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1AaSFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:05:03 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18GwhO1d0OpYz0NaMSfqjav
Date: Mon, 31 Jan 2011 10:04:56 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.38-rc2
Message-ID: <20110131180456.GA3358@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

This is mostly to fix few compiler warning that sneaked in during the
merge window. Also included is one trivial omap1 related cleanup patch
to keep the code consistent with omap2+, and one PTR_ERR fix.

Regards,

Tony


The following changes since commit 6fb1b304255efc5c4c93874ac8c066272e257e28:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2011-01-26 16:31:44 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Felipe Balbi (1):
      arm: omap2: mux: fix compile warning

Julia Lawall (1):
      arch/arm/mach-omap2/dma.c: Convert IS_ERR result to PTR_ERR

Russell King (1):
      omap2+: Fix unused variable warning for omap_irq_base

Tony Lindgren (1):
      omap1: Simplify use of omap_irq_flags

 arch/arm/mach-omap1/include/mach/entry-macro.S |   13 -------------
 arch/arm/mach-omap1/irq.c                      |    2 +-
 arch/arm/mach-omap2/dma.c                      |    2 +-
 arch/arm/mach-omap2/include/mach/entry-macro.S |   14 --------------
 arch/arm/mach-omap2/io.c                       |    6 ++----
 arch/arm/mach-omap2/mux.c                      |    2 +-
 6 files changed, 5 insertions(+), 34 deletions(-)
