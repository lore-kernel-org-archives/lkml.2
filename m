Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2LSN7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:59:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60240 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2LSN7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:59:16 -0500
Message-ID: <1355925504.5273.26.camel@cumari.coelho.fi>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
From: Luciano Coelho <coelho@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
CC: <balbi@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, <svenkatr@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <cjb@laptop.org>, <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, <r.sricharan@ti.com>
Date: Wed, 19 Dec 2012 15:58:24 +0200
In-Reply-To: <50D1C652.3050607@ti.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
	 <20121218095450.GB27751@arwen.pp.htv.fi>
	 <20121219094552.GN4985@opensource.wolfsonmicro.com>
	 <50D19040.5090404@ti.com>
	 <20121219100909.GO4985@opensource.wolfsonmicro.com>
	 <50D19463.5010605@ti.com>
	 <20121219103206.GQ4985@opensource.wolfsonmicro.com>
	 <1355913954.5273.21.camel@cumari.coelho.fi> <50D19D54.2000307@ti.com>
	 <20121219130128.GC17993@arwen.pp.htv.fi> <50D1C652.3050607@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 14:51 +0100, Benoit Cousson wrote:
> On 12/19/2012 02:01 PM, Felipe Balbi wrote:
> > On Wed, Dec 19, 2012 at 11:56:20AM +0100, Peter Ujfalusi wrote:
> >> BTW: have you happened to ubdate u-boot recently? There is a nice easter egg
> >> added there:
> >> f3f98bb ARM: OMAP4/5: Do not configure non essential pads, clocks, dplls.
> >>
> >> Which means that _essential_ clocks and pads are no longer configured.
> > 
> > anything essential you can list ?
> 
> Yeah, that u-boot version is just unusable at all with any mainline
> kernel, since we are still missing pads conf for every drivers.
> 
> Regarding the 32k clock, I noticed as well that the OMAP4460 panda
> u-boot is the only one to enable it at boot time, and thus this is the
> only board that can probe the wilink chip properly as of today.

Do you mean that with the latest mainline u-boot all boards will have
trouble except panda?

I'm still reorganizing everything and update my stuff with the latest
mainline u-boot, but at least blaze and panda now boot and recognize
their wilink chips (with the patches I mentioned reverted).

Now I'll try to remove my reverts and see what happens.

--
Luca.

