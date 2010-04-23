Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0DWQTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:19:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab0DWQS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:18:59 -0400
Date: Fri, 23 Apr 2010 09:11:57 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: platform_bus: Allow runtime PM by default
Message-ID: <20100423161157.GA20971@suse.de>
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100422235353.GA16310@kroah.com>
 <20100423105750.GA27232@rakim.wolfsonmicro.main>
 <20100423150528.GB7648@suse.de>
 <20100423155721.GG27232@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423155721.GG27232@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 04:57:21PM +0100, Mark Brown wrote:
> On Fri, Apr 23, 2010 at 08:05:28AM -0700, Greg KH wrote:
> > On Fri, Apr 23, 2010 at 11:57:51AM +0100, Mark Brown wrote:
> 
> > > > Care to fix it up?
> 
> > > This depends on "PM: Provide generic subsystem-level callbacks" which is
> > > in Linus' tree - which kernel version are you building against and with
> > > what config?  Things work fine for me in -next...
> 
> > I was using Linus's latest tree as of yesterday when this failed.  Are
> > you relying on something in -next that is not in Linus's tree?
> 
> Turns out it's commit ad53012 "i2c: Fix bus-level power management
> callbacks" in the PM tree that it depends on.  Does it make sense to
> merge this via there rather than via your tree?

Why would an i2c specific patch be needed here?  Do you have a pointer
to that patch?

And yes, if it depends on something else in the PM tree, feel free to
send this patch also through it, I have no objection to that.  Rafael,
care to pick it up?  Mark, you might have to resend it to him.

thanks,

greg k-h
