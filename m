Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1EPLnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:43:24 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56891 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753969Ab1EPLnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:43:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+C51e5VHO4m6hiRfKoDB4c
Date: Mon, 16 May 2011 04:43:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] Two omap fixes for v2.6.39-rc7
Message-ID: <20110516114318.GB1780@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

This contains one iommu regression fix and one clock fix.

Regards,

Tony


The following changes since commit 693d92a1bbc9e42681c42ed190bd42b636ca876f:
  Linus Torvalds (1):
        Linux 2.6.39-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Avinash H.M (1):
      OMAP3: set the core dpll clk rate in its set_rate function

Laurent Pinchart (1):
      omap: iommu: Return IRQ_HANDLED in fault handler when no fault occured

 arch/arm/mach-omap2/clkt34xx_dpll3m2.c |    1 +
 arch/arm/plat-omap/iommu.c             |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)
