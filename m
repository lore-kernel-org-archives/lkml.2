Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab0JANFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:05:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:10465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab0JANFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:05:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,266,1283756400"; 
   d="scan'208";a="663055438"
Date: Fri, 1 Oct 2010 15:06:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH 3/4] mfd/mc13xxx: add support for mc13892
Message-ID: <20101001130600.GD3064@sortiz-mobl>
References: <20100929162315.GG29811@pengutronix.de>
 <1285777427-2887-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <20101001104250.GB3064@sortiz-mobl>
 <20101001110233.GG784@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101001110233.GG784@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:02:33PM +0200, Uwe Kleine-König wrote:
> On Fri, Oct 01, 2010 at 12:42:51PM +0200, Samuel Ortiz wrote:
> > Hi Uwe,
> > 
> > On Wed, Sep 29, 2010 at 06:23:46PM +0200, Uwe Kleine-König wrote:
> > > mc13892 is the companion PMIC for Freescale's i.MX51.  It's similar enough
> > > to mc13782 to support it in a single driver.
> > > 
> > > This patch introduces enough compatibility cruft to keep all users of the
> > > superseded mc13783 driver unchanged.
> > All 4 patches applied, thanks.
> Thanks.
>  
> > I have one comment though:
> > 
> > > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > > index db51ea1..1868d9b 100644
> > > --- a/drivers/mfd/Kconfig
> > > +++ b/drivers/mfd/Kconfig
> > > @@ -408,11 +408,16 @@ config MFD_PCF50633
> > >  	  so that function-specific drivers can bind to them.
> > >  
> > >  config MFD_MC13783
> > > -	tristate "Support Freescale MC13783"
> > > +	tristate
> > > +
> > I don't think it's worth keeping this symbol around.
> That's part of the compatibility cruft because some drivers depend on
> it.  
Right, there are 4 of them left, I didnt see that.

> This will be removed when all other drivers are converted together
> with (e.g.) include/mfd/mc13783.h.
It would be nice to have them ready for the next merge window, and I suppose
this should go through my tree then.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
