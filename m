Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1FQLNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:13:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53006 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755466Ab1FQLNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:13:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19jzo+jHhQVBGCJAWUY/6tW
Date: Fri, 17 Jun 2011 04:13:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v3.0-rc3
Message-ID: <20110617111330.GD23145@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git fixes

This set contains regression fixes for PM and pandora board.

Regards,

Tony


The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:
  Linus Torvalds (1):
        Linux 3.0-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git fixes

Grazvydas Ignotas (1):
      omap: pandora: fix NAND support

Kevin Hilman (2):
      OMAP: PM: omap_device: fix device power domain callbacks
      OMAP1: PM: register notifiers with generic clock ops even when !PM_RUNTIME

Russell King (1):
      OMAP: PM debug: fix section mismatch warnings

Tony Lindgren (2):
      Merge branch 'for_3.0/pm-fixes' of ssh://master.kernel.org/.../khilman/linux-omap-pm into fixes
      Merge branch 'fixes-v3.0-rc3' into devel-fixes

 arch/arm/mach-omap1/Makefile             |    4 ++--
 arch/arm/mach-omap1/pm_bus.c             |    8 ++++++--
 arch/arm/mach-omap2/board-omap3pandora.c |    3 ++-
 arch/arm/mach-omap2/pm-debug.c           |    4 ++--
 arch/arm/plat-omap/omap_device.c         |   19 +++++++++++++++++--
 5 files changed, 29 insertions(+), 9 deletions(-)
