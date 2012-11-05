Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab2KEPey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:34:54 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45177 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932841Ab2KEPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:34:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/+aY12YHpLBre4wsronGLj
Date: Mon, 5 Nov 2012 07:34:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>, Felipe Balbi <balbi@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
Message-ID: <20121105153444.GG4953@atomide.com>
References: <E4EE0D1F-C7AC-4620-86F2-D9C7C56E279F@antoniou-consulting.com>
 <50924DA3.1060901@ti.com>
 <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
 <50925C49.7060004@ti.com>
 <CBDE21C5-1980-4BDC-9153-7653A07D0024@dominion.thruhere.net>
 <50938108.5040507@ti.com>
 <40797D3D-D62C-4E15-B0DF-75636C1637EE@antoniou-consulting.com>
 <CACxGe6s8qrP0itLgCyv1mBnekc-7K1n_q-kTKUR=MOJ57W_a1w@mail.gmail.com>
 <C9F4DFD1-4BF4-423C-B749-74E37D51192A@antoniou-consulting.com>
 <CACxGe6ubcRqDEGyRbNmwvAMGg5ujAKvPRWe9Vmd9tiHeB7=qNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6ubcRqDEGyRbNmwvAMGg5ujAKvPRWe9Vmd9tiHeB7=qNw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [121105 06:36]:
> On Mon, Nov 5, 2012 at 1:25 PM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
> >
> > On Nov 5, 2012, at 1:22 AM, Grant Likely wrote:
> >
> >> On Fri, Nov 2, 2012 at 8:43 AM, Pantelis Antoniou
> >> <panto@antoniou-consulting.com> wrote:
> >>> Assuming that we do work on a DT object format, and that the runtime resolution mechanism is approved,
> >>> then I agree that this part of the capebus patches can be dropped and the functionality assumed by generic
> >>> DT core.
> >>>
> >>> The question is that this will take time, with no guarantees that this would be acceptable from
> >>> the device tree maintainers. So I am putting them in the CC list, to see what they think about it.
> >>
> >> This is actually exactly the direction I want to go with DT, which the
> >> ability to load supplemental DT data blobs from either a kernel module
> >> or userspace using the firmware loading infrastructure.
> >>
> >> g.
> >
> > Hi Grant,
> >
> > That's pretty much our use case.
> >
> > Regards
> 
> Good. I'm about 80% though putting together a project plan of what is
> required to implement this. I'll post it for RFC shortly. I would
> appreciate feedback and help on flushing out the design.

Great, sounds like almost-a-plan then :)

Regards,

Tony
