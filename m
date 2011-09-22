Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1IVV3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:29:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45808 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911Ab1IVV26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:28:58 -0400
X-Sasl-enc: TI8WVtzvTZjYsY3wrsnYMa1/a33g/p1sj0qFTIP6WBlO 1316726937
Date: Thu, 22 Sep 2011 14:26:50 -0700
From: Greg KH <greg@kroah.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Message-ID: <20110922212650.GA14094@kroah.com>
References: <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
 <20110922183139.GA7217@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A3370@hasmsx504.ger.corp.intel.com>
 <20110922193805.GA8140@kroah.com>
 <20110922194310.GA8919@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33A3@hasmsx504.ger.corp.intel.com>
 <20110922195449.GA9433@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33C0@hasmsx504.ger.corp.intel.com>
 <20110922201805.GA13274@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33EC@hasmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F0401CB6A33EC@hasmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 12:10:53AM +0300, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, September 22, 2011 11:18 PM
> > To: Winkler, Tomas
> > Cc: Weil, Oren jer; gregkh@suse.de; devel@driverdev.osuosl.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
> > 

Oh come on, I'm getting tired of this crap.

Again, learn to trim properly.  And wrap your lines correctly.  This
isn't rocket science, and while I do realize it is September, the month
is almost over so your excuses are about to run out.

> > > Anyhow this one should be the latest one
> > > http://software.intel.com/en-us/articles/download-the-latest-intel-amt
> > > -open-source-drivers/?wapkw=%28Linux+AMT%29
> > > It also provides ACU.
> > 
> > What is "ACU"?
> This is actually cli to work with ME,  all the docs can be found through that links.

"CLI"?

"Colluder of Linux Internals"?

"ME"?

"Millennium Edition"?

I can guess, but again, please spell it out, as I probably got it wrong.

> I guess this is all quite complex, there is  Linux Enablement Guide on
> the link above it should be useful, yet we probably need to think to
> make something simple for reviewer also run the code in simple way...

Yes you do.

> > Anyway, we want a good description of just what this driver is exporting to
> > userspace, and how it is doing it.  That's the important part here, and is what
> > we need to be able to properly review the code if you wish to start the
> > process to move out of drivers/staging/
> 
> Yes I understand that and hoped we addressed that in mei.txt and patch0. 

patch0?

What are you referring to here?

Again, mei.txt does not describe what the api is in any form, please be
explicit and see the links I pointed you to (Documentation/ABI/) for how
to do this properly for your sysfs files.

> Can you please comment directly on mei.txt what is not clear there or are you suggesting 
> other form of documentation. We will also review it again and will address your ABI comments.

I just did.

> Briefly since this is all in mei.txt 
> 
> MEI provides nothing mere just a tunnel between user space and MEI firmware.
> There are many features that MEI firmware can provide and each has its own rich API (we call it also protocol)

Where is the protocol documentated?

> The specific API documentation is available from link in the mei.txt
> (we need to fill the place holder actually)

That would help :)

> The exceptions are Watchdog which is in kernel, talking to MEI
> firmware watchdog feature. Now it exposes standard Watchdog Linux API,
> and AMTHI which just provides multiplexing between more than one user
> space application for AMTHI feature.
> 
> There is only one in/out ioctl  IOCTL_MEI_CONNECT_CLIENT, which after
> opening /dev/mei specifies which firmware feature we are going talk
> to.
> Client is specified by UUID.  List of UUIDs is not part of the kernel
> API  (only the wd and amthi are visible in the code), this is up to
> the application to to know what client it want to talk to it. 

So this is a pass-through to the hardware almost directly?  Again,
document the heck out of this so as to make it obvious as to what
exactly is going on here, as that is not the case today.

And again, we need a link to a working tool that we can test this with.

greg k-h
