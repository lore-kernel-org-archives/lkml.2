Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab1EZEfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 00:35:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57799 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1EZEfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 00:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fii3yy75iAEjwNYeU+AKW9rSEWi3E/TBCNZkQ38saHdRp3DF4xoco35ukUg6/uBKTc
         mSLumqqnpKThnRZ+HjK/fj15QptkKKTqzMuSdYM8rSNayAJRl539LYhZG/w+VVYU3l9W
         wpqCWXNFj7DE6DXkIhrzhzLgiHe7P6yCTzIdo=
Date: Thu, 26 May 2011 07:33:44 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, hsweeten@visionengravers.com,
        ryan@bluewatersys.com, Dan Williams <dan.j.williams@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi mailing list <spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20110526043344.GA2749@acer>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
 <BANLkTi=3z3kO5VEe2up8Mfm+bNXkY3baUw@mail.gmail.com>
 <20110525195413.GC2996@acer>
 <BANLkTin8Trn-44Op+GbxrgocFrnPuXUZ2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin8Trn-44Op+GbxrgocFrnPuXUZ2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 10:47:14PM +0200, Linus Walleij wrote:
> 
> > IMHO it is better to have ep93xx implementation on its own driver since it is
> > not a real AMBA PL022 peripheral but some weird hack made by Cirrus (although
> > my opinions are bit biased).
> 
> I disagree because it's IMO at first sight no more deviant than our "PL023"
> variants that still use the same pl022 driver.

Ok.

Do you think that we can go forward with this patch series if I drop the last
patch (spi/ep93xx: add DMA support)? This way we will have dmaengine
implementation in place, whatever SPI driver we choose to use with ep93xx.

We can then try to use amba-pl022 driver with ep93xx and see if it works or
not, and how much work is needed. I would like some comments from Hartley and
Ryan also.

> Is there some inexepensive hardware with EP93xx I can get to fix this
> myself?

Check for example Technologic Systems (embeddedarm.com), I have their TS-7260
board which has ep9302.
