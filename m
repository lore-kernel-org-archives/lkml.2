Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab0JLKfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:35:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42830 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab0JLKfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:35:11 -0400
Date: Tue, 12 Oct 2010 12:35:05 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>
Subject: Re: linux-next: manual merge of the arm tree with the arm-current
	tree
Message-ID: <20101012103505.GD28242@pengutronix.de>
References: <20101012103314.41b00cbe.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012103314.41b00cbe.sfr@canb.auug.org.au>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:26:17 up 101 days,  1:37, 35 users,  load average: 0.74, 0.80,
	0.82
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 10:33:14AM +1100, Stephen Rothwell wrote:
> Hi Russell,
> 
> Today's linux-next merge of the arm tree got a conflict in
> arch/arm/mach-imx/mach-cpuimx27.c between commit
> 4793ca4028e4dcdbf2740db50995c9378ded3cf8 ("cpuimx27: fix i2c bus
> selection") from the arm-current tree and commit
> 77a406da5a5b76445a816d5f043fc9aef4026ff1 ("ARM: imx: fix name of macros
> to add imx-i2c devices") from the arm tree.
> 
> I fixed it up (see below) can can carry the fix for a while.

This is because the imx-for-next branch still contained a patch which
I was hoping to get into 2.6.36. This patch conflicts with another patch
in the 2.6.37 branch (I resolved this manually in my next branch).
As all patches for next are now in Russells branch I just scrubbed
my for-next branch and this merge conflict should be gone now.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
