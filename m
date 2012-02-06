Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2BFVFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:05:11 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21052 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2BFVFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:05:09 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19/x1EPuHjMPibDUA7GxgeN
Date: Mon, 6 Feb 2012 13:04:56 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Dong Aisheng <dongas86@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: An extremely simplified pinctrl bindings proposal
Message-ID: <20120206210456.GV1426@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
 <CACRpkdahin4srDh7dphgvq306gjz7CGP=h4dVkUY+w0z0wpXRQ@mail.gmail.com>
 <4F2F6AE2.1040504@nvidia.com>
 <CACRpkdbtTPSoX1x4aBtNVGZ2Qex9t77D09V9JgON_jfShQdx6w@mail.gmail.com>
 <20120206190315.GU1426@atomide.com>
 <CACRpkdZthbejmTqRJAWHb8jU-p8LPT_+zj_CY1q0voMb4FKz2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZthbejmTqRJAWHb8jU-p8LPT_+zj_CY1q0voMb4FKz2Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [120206 11:25]:
> On Mon, Feb 6, 2012 at 8:03 PM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > So far the only
> > change needed for pinctrl drivers containing no data is that
> > we should make the string names optional and structure debugfs
> > around the physical register addresses instead. I'm basically
> > just setting the mux register physcal address as the pin name
> > for now to work around this.
> 
> OK please make a patch to do it really optional in the core if
> you find the time, it seems like a good change anyway, because
> it will make it possible to reduce some current pin name lists
> quite easily.

OK, will take a look at that.

> If you need to change the layout of debugfs just do it.
> 
> I actually had something like unnamed pins in the early patches
> to register a bunch of anonymous pins ranges, so why not bring
> it back in.

Yeah it seems that the mux registers should be listed, it might
require a little bit of thinking for cases where one register
controls multiple pins. So maybe we need just a new entry for
mux registers?

Regards,

Tony
