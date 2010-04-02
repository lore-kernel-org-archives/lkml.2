Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab0DBL34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 07:29:56 -0400
Received: from mga06.intel.com ([134.134.136.21]:43931 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932351Ab0DBL3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:29:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,352,1267430400"; 
   d="scan'208";a="505821800"
Date: Fri, 2 Apr 2010 13:30:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Add WM8994 interrupt controller support
Message-ID: <20100402113027.GF8010@sortiz.org>
References: <1269894525-21530-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100330141201.GA17007@sirena.org.uk>
 <20100402101754.GD8010@sortiz.org>
 <20100402102422.GA32467@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402102422.GA32467@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 11:24:22AM +0100, Mark Brown wrote:
> On Fri, Apr 02, 2010 at 12:17:55PM +0200, Samuel Ortiz wrote:
> > Hi Mark,
> > 
> > On Tue, Mar 30, 2010 at 03:12:02PM +0100, Mark Brown wrote:
> > > On Mon, Mar 29, 2010 at 09:28:45PM +0100, Mark Brown wrote:
> > > 
> > > > +	printk(KERN_CRIT "%x %x\n", status[0], status[1]);
> > > 
> > > Clearly this is debug code and shouldn't be there in an actual version.
> > > I'll remove this when resubmitting after review & merge path are sorted
> > > out.
> 
> > All right, I won't merge it for now.
> 
> Did you see the question in the original posting about where this should
> be merged?  
Sorry, I missed that part.

> The bulk of the code using these interrupts will be the
> CODEC driver for the device, but the CODEC driver needs to be able to
> check if interrupts are set up at all (since commonly CODECs don't have
> an IRQ line wired up) so it'd be nice if it were possible to merge via
> ASoC.
I'm fine with that, please carry this patch. During the next merge window I'll
wait for your code to be merged upstream, fix any potential merge conflicts
and send my pull request.
Also, I had a look at the code and feel free to add my:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to it.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
