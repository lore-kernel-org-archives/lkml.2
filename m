Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1CKRYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:24:04 -0500
Received: from kroah.org ([198.145.64.141]:49885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab1CKRYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:24:03 -0500
Date: Fri, 11 Mar 2011 09:23:45 -0800
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311172345.GA10876@kroah.com>
References: <201103111331.13932.arnd@arndb.de>
 <20110311152938.GB29920@sirena.org.uk>
 <201103111654.04089.arnd@arndb.de>
 <20110311160308.GQ1760@opensource.wolfsonmicro.com>
 <20110311161421.GA7843@kroah.com>
 <20110311162759.GS1760@opensource.wolfsonmicro.com>
 <20110311163522.GA9291@kroah.com>
 <20110311164850.GT1760@opensource.wolfsonmicro.com>
 <20110311165642.GA9996@kroah.com>
 <20110311170807.GV1760@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311170807.GV1760@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 05:08:07PM +0000, Mark Brown wrote:
> On Fri, Mar 11, 2011 at 08:56:42AM -0800, Greg KH wrote:
> > On Fri, Mar 11, 2011 at 04:48:50PM +0000, Mark Brown wrote:
> 
> > > USB itself is discoverable but the when the USB bus you're looking at is
> > > one that's soldered down onto a board in a specific design all bets are
> > > off regarding how complete the information you get will be.  On a basic
> > > level the designers may have done things like omit the configuration
> > > EEPROMs that would set the device IDs that the driver should be relying
> > > on to identify the hardware configuration.  There may be other, nastier,
> > > things going on.
> 
> > Then you use the existing platform data for your USB host controller
> > driver.  Doesn't that work today just fine?
> 
> Wrong end of the bus.  This stuff is simple enough to deal with in a
> system specific fashion, the standard solution would be to patch the
> relevant drivers to hard code whatever is required.

What drivers need this?  Specifics please.

> > > You really can't make this assumption about discoverable buses on
> > > embedded devices.  The discoverability will get you most of the way
> > > there but not always all of the way there.
> 
> > Then the bus is not really USB, sorry.  USB is discoverable, _and_ can
> > support enumeration in non-deterministic ways.  If people are using it
> > in other ways then it is not USB and is something else.
> 
> That's certainly a valid way of looking at things but it doesn't really
> move mainline support for systems which do stuff like this forward.

I would brand these types of systems "extremely broken" :)

Anyway, specifics are the best way forward if anyone has such a messed
up system.

thanks,

greg k-h
