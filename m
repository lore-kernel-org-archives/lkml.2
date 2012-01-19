Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2ASRBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:01:17 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:60850 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2ASRBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:01:13 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/qfoR966KjdmZ9+DiN4kOu
Date: Thu, 19 Jan 2012 09:01:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: Pinmux bindings proposal
Message-ID: <20120119170101.GH22818@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <CAJuYYwSNuMAcjaTNeCq=LmeP8KrvGNjcn1FP6VY0NarEhkY_aA@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEB8@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAEB8@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [120118 11:21]:
> Thomas Abraham wrote at Wednesday, January 18, 2012 5:16 AM:
> > On 14 January 2012 02:09, Stephen Warren <swarren@nvidia.com> wrote:
> > > I thought a bit more about pinmux DT bindings. I came up with something
> > > that I like well enough, and is pretty similar to the binding that Dong
> > > posted recently. I think it'll work for both Tegra's and IMX's needs.
> > > Please take a look!
> ...
> > The pinmux_get() function checks if there is an active user of the
> > pinmux and declines requests if the pinmux has been taken. With the dt
> > bindings that you have listed, can such a check be still enforced.
> 
> I believe so.
> 
> I see these bindings as simply providing the data to populate the same
> pinmux mapping table that's currently used by the pinctrl subsystem.
> therefore, there are no changes to the operation of the pinctrl subsystem
> (beyond a little extra code to parse the map from DT instead of receiving
> a static table from a board file), and no changes to the way drivers
> use the pinctrl APIs. Hence, all that error-checking will still operate
> as-is.

FYI I have the pinmux maps dynamically created based on the driver pins
requested in .dts file and so far don't see a need for static stables
except to support legacy drivers. I'll update my pinmux-simple.c to
use one phandle per controller instance and post it when I'm back home,
so hopefully next week at some point. Sorry it's been dragging, but it's
been looking "just few more things" to fix for a while now..

Cheers,

Tony
