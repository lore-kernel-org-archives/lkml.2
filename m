Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab2BDRP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 12:15:28 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59037 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2BDRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 12:15:27 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Tqi0fwUBFfKwNWG/tnNeL
Date: Sat, 4 Feb 2012 09:15:15 -0800
From: Tony Lindgren <tony@atomide.com>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
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
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120204171515.GJ20333@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120201143530.GA2203@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF178E124AC5@HQMAIL01.nvidia.com>
 <CAA+hA=RpkP-FFAr8wqVPjSKEMvO_sRHmOK_9nUYfuW=ps0O_=Q@mail.gmail.com>
 <20120203173205.GB1426@atomide.com>
 <CAA+hA=QFB7x0yv65LMuLx1exmiUAuB98D+9Fyyk9oeVu+7F2QQ@mail.gmail.com>
 <20120203210545.GE1426@atomide.com>
 <CAA+hA=ThTuGnedNk_KnYLpquZ7EG+b6yU+GSoiS8qiWUB=_0fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA+hA=ThTuGnedNk_KnYLpquZ7EG+b6yU+GSoiS8qiWUB=_0fw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dong Aisheng <dongas86@gmail.com> [120204 08:24]:
> On Sat, Feb 4, 2012 at 5:05 AM, Tony Lindgren <tony@atomide.com> wrote:
> ....
> >> I'm think the new way which i sent in this thread after the mail you replied.
> >> You can refer to them to see if it's reasonable for you too.
> >
> > Hmm, sorry now I'm confused. Got a link for that mail as so
> > many have been posted?
> >
> Pls see:
> https://lkml.org/lkml/2012/2/3/276
> 
> For a simple example, you can refer to.
> https://lkml.org/lkml/2012/2/2/405

Thanks for clarifying. Yes I'm using something that's a subset
of that already, except I'm creating the functions and groups
automatically.

> Shawn and me will attend Linaro connect meeting on Feb 6th.
> If you also attend, we may discuss it together with Linus and Stephen.

Yes let's talk more there, I won't be there until on Tuesday
the 7th though.

Regards,

Tony
