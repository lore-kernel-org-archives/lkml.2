Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1JXVKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:10:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42588 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab1JXVKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:10:02 -0400
Date: Mon, 24 Oct 2011 23:09:52 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20111024210952.GQ23421@pengutronix.de>
References: <20111025072013.1824cfd24495819777ad2660@canb.auug.org.au>
 <20111024203041.GA32545@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024203041.GA32545@flint.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:46:02 up 5 days,  3:21, 17 users,  load average: 0.15, 1.93, 2.79
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 09:30:41PM +0100, Russell King wrote:
> On Tue, Oct 25, 2011 at 07:20:13AM +1100, Stephen Rothwell wrote:
> > Hi Arnd,
> > 
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/plat-mxc/include/mach/memory.h between commit c039bad00f21
> > ("ARM: plat-mxc: remove mach/memory.h") from the arm tree and commits
> > ae4fa7f66e54 ("ARM i.MX: allow to compile together ARMv4 and ARMv5 based
> > SoCs") and 7409cd1cd554 ("ARM i.MX: allow to compile together all i.MX5
> > based SoCs") from the arm-soc tree.
> > 
> > The former removed the file, so I did that.
> 
> Stephen - thanks.
> 
> ARM guys, we need to be smarter about this stuff - if we're consolidating
> code across the ARM tree, committing changes to files which we're going
> to remove really isn't a good idea.  It probably means something else has
> changed elsewhere to accomodate the deletion of the file, which this
> kind of resolution won't fix up.

In this case deleting the file is the correct solution. I removed some
definitions of PLAT_PHYS_OFFSET which got unused due to "ARM i.MX: allow
to compile together..." and Nicolas removed the need for PLAT_PHYS_OFFSET
at all.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
