Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1HCK1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:27:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:1874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab1HCK1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:27:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,309,1309762800"; 
   d="scan'208";a="37412576"
Date: Wed, 3 Aug 2011 12:28:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>, akpm <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] regulator: aat2870-regulator.c needs module.h
Message-ID: <20110803102852.GD26275@sortiz-mobl>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
 <20110729211309.92e8b744.rdunlap@xenotime.net>
 <20110801001523.GA20641@opensource.wolfsonmicro.com>
 <20110801103304.e77887ff2e60f4f6d5c9f91f@canb.auug.org.au>
 <20110801110507.7ca032b85a285d1f9e755146@canb.auug.org.au>
 <20110801092518.GA26275@sortiz-mobl>
 <1312222186.5170.8.camel@CNA0741383>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312222186.5170.8.camel@CNA0741383>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Mon, Aug 01, 2011 at 07:09:46PM +0100, Liam Girdwood wrote:
> Hi Samuel,
> 
> On Mon, 2011-08-01 at 11:25 +0200, Samuel Ortiz wrote:
> > Hi Stephen, Liam,
> > 
> > On Mon, Aug 01, 2011 at 11:05:07AM +1000, Stephen Rothwell wrote:
> > > On Mon, 1 Aug 2011 10:33:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > >
> > > > On Mon, 1 Aug 2011 01:15:24 +0100 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > > > >
> > > > > On Fri, Jul 29, 2011 at 09:13:09PM -0700, Randy Dunlap wrote:
> > > > > > From: Randy Dunlap <rdunlap@xenotime.net>
> > > > > > 
> > > > > > aat2870-regulator.c needs to include linux/module.h to fix multiple
> > > > > > build errors.
> > > > > 
> > > > > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > > > > 
> > > > > but if the breakage isn't in mainline yet to minimize the breaks
> > > > > bisection someone should figure out which tree introduced the change
> > > > > with module.h and either get the fix merged along with that.  If neither
> > > > > the module.h change nor the driver is in Linus' tree yet I rather
> > > > > suspect this should go via MFD as I seem to recall that the driver is
> > > > > going in via there.
> > > > 
> > > > It is indeed.  I have this patch set to apply to my tree today after the
> > > > mfd tree.  Hopefully Samuel will put it in his tree for tomorrow (and
> > > > before he asks Linus to pull.
> > > 
> > > Too late :-)
> > Sorry about that. I thought I would hear about any breakage after I pushed my
> > bits on Friday morning.
> > Anyway, Liam, are you going to push this fix through your tree ?
> > 
> 
> I can if required, however I've just done my pull request (sorry didn't
> see this in time). I have to do another pull request with misc fixes in
> rc1 time frame so I can add it there if OK. 
That's fine with me, thanks in advance.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
