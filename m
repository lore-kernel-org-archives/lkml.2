Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab0ERNhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:37:05 -0400
Received: from kroah.org ([198.145.64.141]:60953 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab0ERNhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:37:01 -0400
Date: Tue, 18 May 2010 06:33:36 -0700
From: Greg KH <greg@kroah.com>
To: CaT <cat@zip.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, bzolnier@gmail.com,
       stable@kernel.org, ben@decadent.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34 (rt2860 regression)
Message-ID: <20100518133336.GA23591@kroah.com>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org>
 <20100518114426.GY2657@zip.com.au>
 <20100518125539.GA23181@kroah.com>
 <20100518131706.GZ2657@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518131706.GZ2657@zip.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 11:17:06PM +1000, CaT wrote:
> On Tue, May 18, 2010 at 05:55:39AM -0700, Greg KH wrote:
> > I do not understand.  The firmware is now part of the linux-firmware
> > tree, and if you install that, it is working just fine, right?  We moved
> > the firmware out of the kernel tree on purpose.
> > 
> > So what is the problem here?
> 
> Well, the driver used to work and appears to be useless without it. I guess
> I'm wondering why it was kept out of the firmware directory where all the
> other firmware lives (and so allow the driver to simply continue to work
> and allow it to be compiled in).

Because we are not adding new firmware to the kernel tree wherever
possible, but instead, putting it in the separate linux-firmware tree.

> At the moment all the change appears to have done is break things that have
> been working without issue since before the driver was even in staging.

Just update the linux-firmware package and all will be working again.
We've been moving the firmware out of the staging drivers for a while
now, as they don't belong in the kernel tree.

thanks,

greg k-h
