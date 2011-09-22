Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1IVTiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:38:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54970 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201Ab1IVTio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:38:44 -0400
X-Sasl-enc: VpVXFfrJcaA2lth3Cyl/hv9o/Kh8dmoLvKDspeVKftTn 1316720323
Date: Thu, 22 Sep 2011 12:38:05 -0700
From: Greg KH <greg@kroah.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Message-ID: <20110922193805.GA8140@kroah.com>
References: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
 <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
 <20110922162953.GA31282@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
 <20110922183139.GA7217@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A3370@hasmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F0401CB6A3370@hasmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 10:06:14PM +0300, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, September 22, 2011 9:32 PM
> > To: Winkler, Tomas
> > Cc: Weil, Oren jer; gregkh@suse.de; devel@driverdev.osuosl.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.

Please get a better email client.

Or at least learn to trim stuff that is not needed at all...

> > > > > --- a/drivers/staging/mei/TODO
> > > > > +++ b/drivers/staging/mei/TODO
> > > > > @@ -1,14 +1,4 @@
> > > > >  TODO:
> > > > > -	- Create in-kernel Client API. Examples of in-kernel clients are
> > > > watchdog and AMTHI.
> > > >
> > > > Did you really do this?
> > > We came to conclusion, this is not really necessary.
> > 
> > Why?  Where was that discussion?
> 
> You're right about it  we did it only internally, yet we also produced
> this requirement internally. Not sure how to address it in this
> stage.

Once you listed this as an external TODO item, I would hope that you
would be willing to discuss it externally.  Internal discussions are not
how Linux kernel development works at all, which of course you know.

> > > > > -	- ME Watchdog Driver to expose standard Linux watchdog interface
> > >
> > > Yes, this was submitted in the previous batch and it doesn't required
> > > really decupling as we previously estimated.
> > 
> > Ok, good.
> > 
> > > > And this?
> > > >
> > > > > -	- Rewrite AMTHI to use in-kernel client interface
> > > >
> > > > And this?
> > > This would be only use case for creating API and in this case it would
> > > just bloat the driver for little benefit.
> > 
> > Again, where was that discussion?
> > 
> > > Since this le
> > 
> > ???

Again, you didn't finish this sentence.

> > > > > -	- Cleanup init and probe functions
> > > > > -	- Review BUG/BUG_ON usage
> > > > > -	- Cleanup and reorganize header files
> > > > > -	- Rewrite client data structure
> > > >
> > > > And this?
> > >
> > > This was mostly done, you can judge if this is enough.
> > 
> > Ok, will look at this later.
> > 
> > > > > -	- Make state machine more readable
> > > > > -	- Add mei.txt with driver explanation and it's driver
> > > >
> > > > You really don't describe the kernel/user api here, that needs to be
> > > > well documented as it is a ABI you are creating and we need to know
> > > > how it works.
> > >
> > > The API is described in the mei.txt that is present in the driver folder.
> > 
> > Really?  I see no description of the ioctls and the structures used in them, no
> > any explaination of any of the sysfs files used in the driver in that file.  Please
> > fix this up.  The proper format for all sysfs files is described in
> > Documentation/ABI/README and the ioctls you can also use the same
> > format.
> 
> We don't really use sysfs anymore this is just legacy named wrappers
> for adding device class, we should fix that.
> We will address the IOCTLs as well.

Please do.

> > > There was also lengthy discussion about it In LKML during our first
> > > try to submit the driver. If it is still not clear enough please let
> > > us know we would happy to fix it as any other gaps.
> > 
> > It's not clear at all.  Where is the userspace tools that interact with this driver
> > that allows me to test that the code works properly?  That would be a good
> > first step as I do have access to this hardware around here to test with.  Do
> > any distros already have it packaged anywhere?
> 
> In the mei.txt file are links to  freely available APIs.

Links grow stale.  Please document exactly the interface in the kernel
otherwise we have no idea os what happens here.

> The user space is usually developed by  third parties yet you can get
> AMT Configuration Utility from http://software.intel.com/.

Do you have a direct link to it?  I tried:
	http://search.intel.com/Default.aspx?q=amt+configuration+manager&submit=+&c=en_US&results=10&offset=0&categories=&filetypes=&q2=&q3=&q4=&method=edit#q=amt+configuration+manager&submit=+&c=en_US&results=10&categories=93581&method=edit&m=search

yet did not find any software to download.

> We will send the patch to mei.txt that add the link.

Please provide one that actually works :)

> I personally don't working with distros, but I believe that SUSE has
> major deployment of iAMT (MEI).  Oren may have more info about it.

Ah, this one:
	https://build.opensuse.org/package/show?package=intel-iamt&project=openSUSE%3A11.4
If so, that package has been dropped by SUSE as it seems to no longer be
maintained upstream.  Is this incorrect?

Care to point to the proper download location for the lms tarball?

thanks,

greg k-h
