Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab0JFVBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:01:41 -0400
Received: from kroah.org ([198.145.64.141]:56500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933107Ab0JFVBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:01:39 -0400
Date: Wed, 6 Oct 2010 13:59:37 -0700
From: Greg KH <greg@kroah.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Thomas Renninger <trenn@suse.de>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, jbaron@redhat.com
Subject: Re: Dynamic Debug module.ddebug fake param enhancements V4
Message-ID: <20101006205937.GA6184@kroah.com>
References: <20100920184441.GA2915@redhat.com>
 <201009270909.18490.bjorn.helgaas@hp.com>
 <201009281425.19070.trenn@suse.de>
 <201009280822.11675.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009280822.11675.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 08:22:11AM -0600, Bjorn Helgaas wrote:
> On Tuesday, September 28, 2010 06:25:18 am Thomas Renninger wrote:
> > Greg: Do you mind pushing the first (1/4, V4) and the last (4/4)
> > patch into your tree for linux-next and leave the two PNP patches
> > out, please.

I've applied them now.

> > More PNP related discussion, below.
> > 
> > On Monday 27 September 2010 17:09:18 Bjorn Helgaas wrote:
> > > On Monday, September 27, 2010 02:25:46 am Thomas Renninger wrote:
> > > 
> > > > What do you think (dev_dbg vs printk(KERN_DEBUG...)?
> > ...
> > > With the exception of the ones in pnp/resource.c that I want to convert
> > > to dev_printk(KERN_DEBUG), I think all the pnp_dbg() uses are things
> > > I used during PNP development and haven't ever needed since.
> > 
> > Ok. Sounds sane.
> > I used the PNP parts as it nicely showed what the
> > module.ddebug boot param is doing, but I agree it hasn't much
> > advantage for PNP.
> > 
> > Whatabout compiling pnp in one module namespace, the first
> > of the two PNP patches?
> 
> [2/4] looks reasonable to me.

And this one.

> 
> > E.g. attached patch would be an on top patch which provides no
> > functional change, just that a pnp.debug would be a module param:
> > cat /sys/module/pnp/parameters/debug
> 
> As does the one below.

And this one.

So that left 3/4 out of the series applied to my tree.

If this is incorrect, please let me know.

thanks,

greg k-h
