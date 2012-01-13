Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2AMNZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:25:06 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55462 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2AMNZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:25:01 -0500
Date: Fri, 13 Jan 2012 21:35:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Stephen Warren <swarren@nvidia.com>, Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Message-ID: <20120113133552.GB17029@S2101-09.ap.freescale.net>
References: <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A76A@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788508E7B0@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D1DD6@HQMAIL01.nvidia.com>
 <20120113035506.GB12184@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC605788508FD9C@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7FE21149F4667147B645348EC605788508FD9C@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 08:07:35AM +0000, Dong Aisheng-B29396 wrote:
> > > But, one thought on doing this in pinmux_get(). I'd simply implement a
> > > Function that read a DT node's pinmux property/node, converted it to a
> > > pinmux mapping table, and registered it with the pinctrl core. Then,
> > > pinmux_get() could simply call this before doing anything else at all.
> > > I don't think you'd need to modify how pinmux_get() worked at all.
> > >
> > This sounds like a pretty good idea to me.
> > 
> This does not fix the inconsistency issue.
> Additionally as I said before, for better support dynamically register pinmux
> Map, it looks we'd better change the pinmux_maps array to a list.
> However this is for dt case.
> But for non-dt case, the static array is just ok.
> So there's conflict.
> Not sure if any better idea to fix this.
> 
My guess is that Linus.W did not get any chance to take the dt case
into account with his first design of pinctrl core.  But I guess he
is open to any reasonable change to pinctrl core for dt adoption.
Linus?

-- 
Regards,
Shawn
