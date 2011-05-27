Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab1E0DPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:15:36 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:59462 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1E0DPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:15:35 -0400
Date: Thu, 26 May 2011 21:15:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 0/4] add gpio driver gpio-mxs
Message-ID: <20110527031533.GI5032@ponder.secretlab.ca>
References: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
 <20110520100242.GA10403@pengutronix.de>
 <20110520102410.GD27251@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520102410.GD27251@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 06:24:11PM +0800, Shawn Guo wrote:
> On Fri, May 20, 2011 at 12:02:42PM +0200, Sascha Hauer wrote:
> > Hi Shawn,
> > 
> Hi Sascha,
> 
> > On Fri, May 20, 2011 at 05:51:25PM +0800, Shawn Guo wrote:
> > > The patch set is to move Freescale MXS gpio driver from mach-mxs
> > > into drivers/gpio.  Different from u300 gpio driver that all gpio
> > > ports are registered as one device, gpio-mxs expects every single
> > > port is a gpio device.
> > > 
> > > The first 3 patches are just to ease review and can be squashed into
> > > the last one.
> > > 
> > > Shawn Guo (4):
> > >       gpio: gpio-mxs: add file gpio-mxs.c
> > >       gpio: gpio-mxs: drop mach-specific accessors
> > >       gpio: gpio-mxs: remove gpio port definition and registration
> > >       gpio: gpio-mxs: add gpio driver for Freescale MXS architecture
> > 
> > Your series should be bisectible. So please either:
> > 
> > - Add the driver the way you want it (no need to modify a new file in
> >   four steps)
> 
> As I said above, I split it into 4 patches just to ease the review,
> and they can be squashed into one when applying.

If you use the -M flag when posting the patch, then the diff will show
both that the file has moved, and also only show the changes made to
the file when it was moved.  That way you can squash the series into
one.

g.

