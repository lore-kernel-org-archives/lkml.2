Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2EIUtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:49:31 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:19566 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab2EIUta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:49:30 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/EDLdDJ04r/BvVs5vBBZIQ
Date: Wed, 9 May 2012 13:49:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120509204925.GV5088@atomide.com>
References: <20120503065131.GA3738@game.jcrosoft.org>
 <20120503152708.GC5140@atomide.com>
 <4FA30805.5050804@wwwdotorg.org>
 <20120504044305.GD7788@game.jcrosoft.org>
 <20120504150342.GI5140@atomide.com>
 <20120504153251.GE7788@game.jcrosoft.org>
 <20120504163420.GA5613@atomide.com>
 <4FA42631.6060304@wwwdotorg.org>
 <20120504220809.GW5613@atomide.com>
 <4FAAD141.3090306@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAAD141.3090306@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [120509 13:22]:
> On 05/04/2012 04:08 PM, Tony Lindgren wrote:
> > * Stephen Warren <swarren@wwwdotorg.org> [120504 11:59]:
> >> On 05/04/2012 10:34 AM, Tony Lindgren wrote:
> >>> * Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120504 08:58]:
> >>>> On 08:03 Fri 04 May     , Tony Lindgren wrote:
> >>>>>>
> >>>>>> so I was thinking to do like on gpio
> >>>>>>
> >>>>>> uart {
> >>>>>> 	pin = < &pioA 12 {pararms} >
> >>>>>>
> >>>>>> }
> >>>>>
> >>>>> Hmm I assume the "12" above the gpio number?
> >>>> no pin number in the bank because it could not be gpio
> >>>
> >>> Yes OK, but pin number 12 in the gpio bank, not in the mux register.
> >>> Got it.
> >>
> >> I'd prefer to avoid any references to GPIOs here; not all muxable pins
> >> are GPIOs and not all GPIOs are muxable pins. Lets keep the two concepts
> >> independent.
> > 
> > And it seems that &pioA 12 is not always enough information for the pinctrl
> > driver to request a GPIO. So it's best to specify it separately.
> 
> Why would a pinctrl driver "request a GPIO"?

Hmm what would pinctrl_request_gpio do if the GPIO driver is separate driver?

Tony
