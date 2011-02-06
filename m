Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1BFTNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:13:50 -0500
Received: from kroah.org ([198.145.64.141]:41559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1BFTNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:13:49 -0500
Date: Sun, 6 Feb 2011 11:14:21 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] PM: Do not create wakeup sysfs files for devices that
 cannot wake up (v2)
Message-ID: <20110206191421.GB7818@kroah.com>
References: <Pine.LNX.4.44L0.1102061024150.20379-100000@netrider.rowland.org>
 <201102061953.17433.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102061953.17433.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 07:53:17PM +0100, Rafael J. Wysocki wrote:
> On Sunday, February 06, 2011, Alan Stern wrote:
> > On Sun, 6 Feb 2011, Rafael J. Wysocki wrote:
> > 
> > > Hi,
> > > 
> > > Below is the next version of the patch changing the PM core to only create
> > > wakeup sysfs files for devices that are wakeup-capable.  It contains a change
> > > in drivers/usb/core/hub.c that should avoid the problem described in the thread
> > > at https://lkml.org/lkml/2011/2/5/108 , but I'm not 100% it's the right
> > > approach.  Please have a look.
> > 
> > Yes, that's right -- in fact, it's exactly the same as what I was going
> > to do.  Of course, it should be separated out into a separate patch, to
> > be applied before the other wakeup changes.
> 
> OK, I'll split it out.
> 
> Greg, any objections to me putting the change below into the suspend tree as
> a separate commit:

No objection from me at all:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
