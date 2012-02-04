Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2BDAzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 19:55:46 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:14587 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2BDAzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 19:55:44 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+4jzGf/LEfcJkVEIDnF4QY
Date: Fri, 3 Feb 2012 16:55:39 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Dong Aisheng <dongas86@gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: Add simple pinmux driver using device
 tree data
Message-ID: <20120204005539.GI20333@atomide.com>
References: <20120203205049.4089.74610.stgit@kaulin.local>
 <20120203205508.4089.35304.stgit@kaulin.local>
 <CACRpkdaDOZ3X0AkWH4B4ZGCXHPxh0CkSg3xi=jHC5L+kJr1d=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaDOZ3X0AkWH4B4ZGCXHPxh0CkSg3xi=jHC5L+kJr1d=w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [120203 14:18]:
> On Fri, Feb 3, 2012 at 9:55 PM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > Add simple pinmux driver using device tree data.
> >
> > Currently this driver only works on omap2+ series of
> > processors, where there is either an 8 or 16-bit mux
> > register for each pin. Support for other similar pinmux
> > controllers could be added.
> 
> So since it's not named pinctrl-omap I guess you intend it
> to be fully generic for simple muxes, which is nice!
> If people start ACK:ing this I will be happy with it too,
> because it's very easy to understand.

Yes the idea is that it should stay generic. I don't know
how easy or hard it would be to enhance it to support
also other type mux cases, like multiple mux registers per
pin, but I guess we'll see.
 
> > Note that this patch does not yet support pinconf_ops
> > or GPIO. Further, alternative mux modes are not yet
> > handled.
> 
> Do you want to evolve the patch for these features
> or do you want to refactor it in later?

Well I'd like to test it a bit more first as I've only
done minimal testing so far. So maybe let's assume there
will be one more iteration at least.

Regards,

Tony
