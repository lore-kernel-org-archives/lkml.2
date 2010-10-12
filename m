Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab0JLV0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:26:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63677 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0JLV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:26:16 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ff0FgS+KPAJGinJGJ2K1Z
Date: Tue, 12 Oct 2010 14:08:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] one omap fix for 2.6.36
Message-ID: <20101012210839.GB25462@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a one-liner from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit cb655d0f3d57c23db51b981648e452988c0223f9:

  Linux 2.6.36-rc7 (2010-10-06 13:39:52 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Hari Kanigeri (1):
      omap: iommu-load cam register before flushing the entry

 arch/arm/plat-omap/iommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
