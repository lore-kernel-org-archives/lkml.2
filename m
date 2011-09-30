Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1I3Pdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:33:32 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42045 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1I3Pdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:33:31 -0400
Date: Fri, 30 Sep 2011 11:33:21 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v4)
Message-ID: <20110930153321.GA31760@hmsreliant.think-freely.org>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1317307129-11579-1-git-send-email-nhorman@tuxdriver.com>
 <20110930143211.5ab39c02@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930143211.5ab39c02@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: 0.2 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 02:32:11PM +0200, Stefan Richter wrote:
> On Sep 29 Neil Horman wrote:
> > (v4)
> > Fixed up some spelling mistakes, and added a scissors line with a good
> > commitlog, so that git-am drops all the version logging
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Greg Kroah-Hartman <gregkh@suse.de>
> > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > CC: linux-pci@vger.kernel.org
> 
> It drops these last 5 lines then too, doesn't it?
> 
I would have thought so, but I tested a git-format-patch / git-am operation here
on a temporary branch, and it worked properly.

> > --- a/Documentation/ABI/testing/sysfs-bus-pci
> > +++ b/Documentation/ABI/testing/sysfs-bus-pci
> > @@ -66,6 +66,24 @@ Description:
> >  		re-discover previously removed devices.
> >  		Depends on CONFIG_HOTPLUG.
> >  
> > +What:		/sys/bus/pci/devices/.../msi_irqs/
> > +Date:		September, 2011
> > +Contact:	Neil Horman <nhorman@tuxdriver.com>
> > +Description:
> > +		The /sys/devices/.../msi_irqs directory contains a variable set
> > +		sub-directories, with each sub-directory being named after a
> > +		corresponding msi irq vector allocated to that device.
> 
> "contains a variable set _of_ sub-directories"?
Gah, bad ispell foo on my part.  Bjorn, can you add that in, or shall I repost?
Neil

> -- 
> Stefan Richter
> -=====-==-== =--= ====-
> http://arcgraph.de/sr/
> 
