Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab1HASKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:10:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35018 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1HASKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:10:33 -0400
Subject: Re: [PATCH -next] regulator: aat2870-regulator.c needs module.h
From: Liam Girdwood <lrg@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>, akpm <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110801092518.GA26275@sortiz-mobl>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
	 <20110729211309.92e8b744.rdunlap@xenotime.net>
	 <20110801001523.GA20641@opensource.wolfsonmicro.com>
	 <20110801103304.e77887ff2e60f4f6d5c9f91f@canb.auug.org.au>
	 <20110801110507.7ca032b85a285d1f9e755146@canb.auug.org.au>
	 <20110801092518.GA26275@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 1 Aug 2011 19:09:46 +0100
Message-ID: <1312222186.5170.8.camel@CNA0741383>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Mon, 2011-08-01 at 11:25 +0200, Samuel Ortiz wrote:
> Hi Stephen, Liam,
> 
> On Mon, Aug 01, 2011 at 11:05:07AM +1000, Stephen Rothwell wrote:
> > On Mon, 1 Aug 2011 10:33:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > On Mon, 1 Aug 2011 01:15:24 +0100 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > > >
> > > > On Fri, Jul 29, 2011 at 09:13:09PM -0700, Randy Dunlap wrote:
> > > > > From: Randy Dunlap <rdunlap@xenotime.net>
> > > > > 
> > > > > aat2870-regulator.c needs to include linux/module.h to fix multiple
> > > > > build errors.
> > > > 
> > > > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > > 
> > > > but if the breakage isn't in mainline yet to minimize the breaks
> > > > bisection someone should figure out which tree introduced the change
> > > > with module.h and either get the fix merged along with that.  If neither
> > > > the module.h change nor the driver is in Linus' tree yet I rather
> > > > suspect this should go via MFD as I seem to recall that the driver is
> > > > going in via there.
> > > 
> > > It is indeed.  I have this patch set to apply to my tree today after the
> > > mfd tree.  Hopefully Samuel will put it in his tree for tomorrow (and
> > > before he asks Linus to pull.
> > 
> > Too late :-)
> Sorry about that. I thought I would hear about any breakage after I pushed my
> bits on Friday morning.
> Anyway, Liam, are you going to push this fix through your tree ?
> 

I can if required, however I've just done my pull request (sorry didn't
see this in time). I have to do another pull request with misc fixes in
rc1 time frame so I can add it there if OK. 

Thanks

Liam

