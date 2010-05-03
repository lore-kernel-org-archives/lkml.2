Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab0ECK2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 06:28:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46016 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab0ECK2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 06:28:47 -0400
Date: Mon, 3 May 2010 12:28:32 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>,
       Dinh Nguyen <Dinh.Nguyen@freescale.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Fix build error for i.MX51 (mx51_defconfig)
Message-ID: <20100503102832.GA31199@pengutronix.de>
References: <20100421211707.GC2951@matterhorn.lan> <20100501101811.GI12172@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100501101811.GI12172@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:26:23 up 7 days,  3:52, 46 users,  load average: 0.58, 0.73,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 01, 2010 at 11:18:11AM +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 22, 2010 at 12:17:07AM +0300, Amit Kucheria wrote:
> > Please apply the following patch to fix build failure for i.MX51 in
> > 2.6.34-rc5.
> 
> It would be preferable to have an acked-by from Sascha, but given this
> is a build error I'll take it via the patch system; thanks.
> 

I sent the following pull request you probably missed while being
offline. It contains the same patch from Dinh Nguyen.

Sascha


The following changes since commit 2ba3abd8186f24c7fb418927025b4e2120e3a362:
  Linus Torvalds (1):
        Merge branch 'pm-fixes' of
git://git.kernel.org/.../rafael/suspend-2.6

are available in the git repository at:

  git://git.pengutronix.de/git/imx/linux-2.6.git for-rmk

Dinh Nguyen (1):
      mx5: Fix build error for mx51_defconfig

 arch/arm/mach-mx5/clock-mx51.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
