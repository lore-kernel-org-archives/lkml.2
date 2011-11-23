Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab1KWSYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:24:08 -0500
Received: from [213.95.27.120] ([213.95.27.120]:42265 "EHLO
	ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab1KWSYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:24:06 -0500
Date: Wed, 23 Nov 2011 19:22:09 +0100
From: Harald Welte <HaraldWelte@viatech.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Marc Vertes <marc.vertes@sigfox.com>, w.sang@pengutronix.de, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111123182209.GF5315@prithivi.gnumonks.org>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173029.GA14349@pengutronix.de>
 <4ecbe56d.0B7WEVDKkK1s88MJ%marc.vertes@sigfox.com>
 <4ecbf011.dZASXe6D5kH4Uxve%marc.vertes@sigfox.com>
 <20111123121051.GA18320@rainbow>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123121051.GA18320@rainbow>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<disclaimer>
I used to do some work for VIA some years ago but am not anymore, the
email alias mostly exists because I don't want to leave the community
completely in the rain if I can still help with some VIA related issues.
</disclaimer>

On Wed, Nov 23, 2011 at 04:10:51PM +0400, Dmitry Artamonow wrote:

> "via_wdt" seems to be a too generic name. What if someone will want to
> write driver for some incompatible watchdog also made by VIA?
> Maybe it's worth to use something more specific - say, "via_vx8xx_wdt"?

In fact, to the best of my knowledge, all previous VIA x86 chipsets use
the exact same watchdog, i.e. you can go back to Athlon or even earlier
chipsets and will likely find the exact same interface.

> > + * The only way to activate the watchdog timer or to set its period is
> > + * through BIOS setup.
> 
> Why is to rely on BIOS setup? Is there really no information on what
> registers to write to start watchdog? Or you was just lazy to find it?
> It took me less than a minute to google up a datasheet[1] on VX800/VX820
> and it seems to have all needed information to implement proper start()
> and stop() functions. I suppose info on watchdog registers should be
> applicable to VX855 as well - but it's better to check on your hardware
> anyway.

Unfortunately it simply doesn't work.  When I originally implemented a
via_wdt driver some years ago, I couldn't start the watchdog no matter
how hard I tried.  My inquiries into VIA at that point didn't provide
any response either.  In fact, I even feared that nobody might ever have
used that watchdog hardware before ;)

I can ask again, but I'm not sure if it will be any different at that
time..

Regards,
	Harald
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
