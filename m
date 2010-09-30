Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0I3Czh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:55:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab0I3Czg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:55:36 -0400
Date: Wed, 29 Sep 2010 19:56:17 -0700
From: Greg KH <gregkh@suse.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org, dsd@laptop.org,
        jon.nettleton@gmail.com, linux-geode@lists.infradead.org,
        linux-kernel@vger.kernel.org, cjb@laptop.org,
        David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 3/4] cs5535: add some additional cs5535-specific GPIO
	functionality
Message-ID: <20100930025617.GA4877@suse.de>
References: <20100925190712.6aa5c2fc@debxo> <20100930010501.GA28145@kroah.com> <20100929194650.7283174c@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929194650.7283174c@debxo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 07:46:50PM -0700, Andres Salomon wrote:
> On Wed, 29 Sep 2010 18:05:01 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Sat, Sep 25, 2010 at 07:07:12PM -0700, Andres Salomon wrote:
> > > 
> > > This adds (well, re-adds actually) handling for events/IRQs through
> > > cs5535 GPIOs.  In the wild and wooly world of CS5535, setup_event()
> > > is for assigning an IRQ to a GPIO filter/event pair, and set_irq()
> > > sets up the pair to trigger IRQs.
> > > 
> > > These should really only be used in highly platform-specific
> > > drivers (such as OLPC's DCON driver).  Sadly, because set_irq()
> > > uses MSRs, this causes the driver to become X86-specific.
> > > 
> > > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > > ---
> > >  drivers/gpio/Kconfig       |    2 +-
> > >  drivers/gpio/cs5535-gpio.c |   52
> > > ++++++++++++++++++++++++++++++++++++++++++++
> > > include/linux/cs5535.h     |    2 +
> > 
> > I can't take this change without the gpio subsystem maintainer acking
> > it.  Can you get that approval from them?
> 
> 
> I believe the GPIO subsystem is unmaintained (please correct me if
> I'm wrong).   David Brownell had some good input on my original
> cs5535-gpio driver patches that I sent, so I'll Cc him.  I
> think that's as close to a maintainer as we're going to get. :)

Fair enough, get his ack and agreement that I can take this through the
staging tree, and I'll be glad to do it.

> If I recall correctly, the past few of my (and others') cs5535-gpio
> patches have gone in by way of the -mm tree.

Ah, that means there's no real maintainer :(

thanks,

greg k-h
