Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1ETKTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 06:19:45 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:21442
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753389Ab1ETKTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 06:19:44 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 20 May 2011 18:24:11 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <kernel@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>
Subject: Re: [PATCH 0/4] add gpio driver gpio-mxs
Message-ID: <20110520102410.GD27251@S2100-06.ap.freescale.net>
References: <1305885089-27343-1-git-send-email-shawn.guo@linaro.org>
 <20110520100242.GA10403@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110520100242.GA10403@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 12:02:42PM +0200, Sascha Hauer wrote:
> Hi Shawn,
> 
Hi Sascha,

> On Fri, May 20, 2011 at 05:51:25PM +0800, Shawn Guo wrote:
> > The patch set is to move Freescale MXS gpio driver from mach-mxs
> > into drivers/gpio.  Different from u300 gpio driver that all gpio
> > ports are registered as one device, gpio-mxs expects every single
> > port is a gpio device.
> > 
> > The first 3 patches are just to ease review and can be squashed into
> > the last one.
> > 
> > Shawn Guo (4):
> >       gpio: gpio-mxs: add file gpio-mxs.c
> >       gpio: gpio-mxs: drop mach-specific accessors
> >       gpio: gpio-mxs: remove gpio port definition and registration
> >       gpio: gpio-mxs: add gpio driver for Freescale MXS architecture
> 
> Your series should be bisectible. So please either:
> 
> - Add the driver the way you want it (no need to modify a new file in
>   four steps)

As I said above, I split it into 4 patches just to ease the review,
and they can be squashed into one when applying.

> - atomically switch to the new driver
> - remove old driver
> 
These two steps happened in the patch set '[PATCH 0/3] remove mach-mxs
gpio driver'.  The patch order should be reworked though.

BTW, are you looking at moving plat-mxc/gpio.c, or I can give a hand
there?

-- 
Regards,
Shawn

