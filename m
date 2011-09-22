Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1IVSbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:31:52 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43242 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370Ab1IVSbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:31:51 -0400
X-Sasl-enc: B8N404mV0I8gKvgXPH+zQPDEEIC/8X/XmMdswXius5FK 1316716311
Date: Thu, 22 Sep 2011 11:31:39 -0700
From: Greg KH <greg@kroah.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Message-ID: <20110922183139.GA7217@kroah.com>
References: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
 <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
 <20110922162953.GA31282@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 09:12:21PM +0300, Winkler, Tomas wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Thursday, September 22, 2011 7:30 PM
> > To: Weil, Oren jer
> > Cc: gregkh@suse.de; devel@driverdev.osuosl.org; Winkler, Tomas; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
> > 
> > On Wed, Sep 21, 2011 at 04:45:31PM +0300, Oren Weil wrote:
> > > Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> > > Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
> > > ---
> > >  drivers/staging/mei/TODO |   10 ----------
> > >  1 files changed, 0 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/staging/mei/TODO b/drivers/staging/mei/TODO index
> > > 3b6a667..7d9a13b 100644
> > > --- a/drivers/staging/mei/TODO
> > > +++ b/drivers/staging/mei/TODO
> > > @@ -1,14 +1,4 @@
> > >  TODO:
> > > -	- Create in-kernel Client API. Examples of in-kernel clients are
> > watchdog and AMTHI.
> > 
> > Did you really do this?
> We came to conclusion, this is not really necessary.

Why?  Where was that discussion?

> > > -	- ME Watchdog Driver to expose standard Linux watchdog interface
> 
> Yes, this was submitted in the previous batch and it doesn't required
> really decupling as we previously estimated.

Ok, good.

> > And this?
> > 
> > > -	- Rewrite AMTHI to use in-kernel client interface
> > 
> > And this?
> This would be only use case for creating API and in this case it would
> just bloat the driver for little benefit.

Again, where was that discussion?

> Since this le

???

> > 
> > > -	- Cleanup init and probe functions
> > > -	- Review BUG/BUG_ON usage
> > > -	- Cleanup and reorganize header files
> > > -	- Rewrite client data structure
> > 
> > And this?
> 
> This was mostly done, you can judge if this is enough.

Ok, will look at this later.

> > > -	- Make state machine more readable
> > > -	- Add mei.txt with driver explanation and it's driver
> > 
> > You really don't describe the kernel/user api here, that needs to be well
> > documented as it is a ABI you are creating and we need to know how it
> > works.
> 
> The API is described in the mei.txt that is present in the driver folder.

Really?  I see no description of the ioctls and the structures used in
them, no any explaination of any of the sysfs files used in the driver
in that file.  Please fix this up.  The proper format for all sysfs
files is described in Documentation/ABI/README and the ioctls you can
also use the same format.

> There was also lengthy discussion about it In LKML during our first
> try to submit the driver. If it is still not clear enough please let
> us know we would happy to fix it as any other gaps.

It's not clear at all.  Where is the userspace tools that interact with
this driver that allows me to test that the code works properly?  That
would be a good first step as I do have access to this hardware around
here to test with.  Do any distros already have it packaged anywhere?

thanks,

greg k-h
