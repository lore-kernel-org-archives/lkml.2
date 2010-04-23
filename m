Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab0DWQiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:38:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:35641 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab0DWQiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:38:13 -0400
Date: Fri, 23 Apr 2010 09:36:29 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: platform_bus: Allow runtime PM by default
Message-ID: <20100423163629.GA5916@suse.de>
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100422235353.GA16310@kroah.com>
 <20100423105750.GA27232@rakim.wolfsonmicro.main>
 <20100423150528.GB7648@suse.de>
 <20100423155721.GG27232@rakim.wolfsonmicro.main>
 <20100423161157.GA20971@suse.de>
 <20100423162811.GA31231@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423162811.GA31231@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 05:28:12PM +0100, Mark Brown wrote:
> On Fri, Apr 23, 2010 at 09:11:57AM -0700, Greg KH wrote:
> > On Fri, Apr 23, 2010 at 04:57:21PM +0100, Mark Brown wrote:
> 
> > > Turns out it's commit ad53012 "i2c: Fix bus-level power management
> > > callbacks" in the PM tree that it depends on.  Does it make sense to
> > > merge this via there rather than via your tree?
> 
> > Why would an i2c specific patch be needed here?  Do you have a pointer
> > to that patch?
> 
> Despite the patch title being I2C specific it actually includes exposing
> some of the runtime PM implementation to external users - I2C being the
> first user of the generic PM runtime callbacks that I'm trying to use in
> the platform device implementation.
> 
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=ad530128cd302e5df930b6eb4d4c7e162c40fcb2;hp=b938b00444e900f1c86e754539e3d00f172c184e
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=d690b2cd222afc75320b9b8e9da7df02e9e630ca
> 
> > And yes, if it depends on something else in the PM tree, feel free to
> > send this patch also through it, I have no objection to that.  Rafael,
> > care to pick it up?  Mark, you might have to resend it to him.
> 
> OK, Raphael please let me know if you need a resend.  Greg, I guess I
> can add your Acked-by to that?

Yes, please feel free to add it.

thanks,

greg k-h
