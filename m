Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1EWHTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:19:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40997 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1EWHTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:19:12 -0400
Date: Mon, 23 May 2011 09:19:09 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the i.MX tree with the  tree
Message-ID: <20110523071909.GD20715@pengutronix.de>
References: <20110523114542.9868cba1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523114542.9868cba1.sfr@canb.auug.org.au>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:15:43 up 2 days, 20:55, 31 users,  load average: 1.36, 0.90, 0.56
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, May 23, 2011 at 11:45:42AM +1000, Stephen Rothwell wrote:
> Hi Sascha,
> 
> Today's linux-next merge of the i.MX tree got a conflict in
> arch/arm/mach-imx/Kconfig arch/arm/plat-mxc/Kconfig between the "same"
> commits from the arm tree and the i.MX tree.
> 
> Please don't rearrange commits when upstreaming them - or if you do, then
> update the source tree as well.  I am assuming that the commits that are
> in the arm tree amount to the same as what has been int the i.MX tree for
> some time.  There are a couple of extra commits in the i.MX tree, so I
> just used the i.MX version of those files.   This may not work.

I have forgotten that my tree shows up in -next twice once rmk pulled
from me. I removed these patches from my -next queue and will hopefully
remember it next time aswell.

Thanks
 Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
