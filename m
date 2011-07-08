Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1GHLwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 07:52:54 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54341 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752189Ab1GHLwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 07:52:53 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18lhxf21tkCF4E3Ip4ntwxe
Date: Fri, 8 Jul 2011 04:52:49 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fix for v3.0
Message-ID: <20110708115249.GZ5783@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull one fix from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

This fixes an embarassing segfault by dropping __initdata from data that
should not be marked __initdata.

Regards,

Tony


The following changes since commit fe0d42203cb5616eeff68b14576a0f7e2dd56625:
  Linus Torvalds (1):
        Linux 3.0-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Janusz Krzysztofik (1):
      omap: drop __initdata tags from static struct platform_device declarations

 arch/arm/mach-omap1/board-ams-delta.c        |    8 ++++----
 arch/arm/mach-omap1/gpio15xx.c               |    4 ++--
 arch/arm/mach-omap1/gpio16xx.c               |   10 +++++-----
 arch/arm/mach-omap1/gpio7xx.c                |   14 +++++++-------
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 5 files changed, 19 insertions(+), 19 deletions(-)
