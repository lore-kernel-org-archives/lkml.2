Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1CGSrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:47:45 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:35871 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab1CGSro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:47:44 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/C2m9IZLhQVLMDrfSP0cl3
Date: Mon, 7 Mar 2011 10:47:33 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] Remaining omap fixes for 2.6.37-r7
Message-ID: <20110307184733.GA23877@atomide.com>
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

This contains the remaining PM related fixes that were missing from the
last pull request and one new fix for a mailbox hang.

Regards,

Tony


The following changes since commit dd9c1549edef02290edced639f67b54a25abbe0e:

  Linux 2.6.38-rc7 (2011-03-01 13:55:12 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Aaro Koskinen (1):
      arm: mach-omap2: smartreflex: fix another memory leak

Hari Kanigeri (1):
      omap: mailbox: resolve hang issue

Shweta Gulati (1):
      OMAP2+: PM: SmartReflex: fix memory leaks in Smartreflex driver

Tony Lindgren (1):
      Merge branch 'for_2.6.38/pm-fixes' of ssh://master.kernel.org/.../khilman/linux-omap-pm into devel-fixes

 arch/arm/mach-omap2/mailbox.c     |   10 ++++++----
 arch/arm/mach-omap2/smartreflex.c |   33 +++++++++++++++------------------
 2 files changed, 21 insertions(+), 22 deletions(-)
