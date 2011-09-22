Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1IVTGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 15:06:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:41308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab1IVTGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 15:06:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="54167931"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <greg@kroah.com>
CC: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 22 Sep 2011 22:06:14 +0300
Subject: RE: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Thread-Topic: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Thread-Index: Acx5VeeMiyBEJmDYTciZ7Yu72YRIXAAACYaQ
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401CB6A3370@hasmsx504.ger.corp.intel.com>
References: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
 <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
 <20110922162953.GA31282@kroah.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
 <20110922183139.GA7217@kroah.com>
In-Reply-To: <20110922183139.GA7217@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, September 22, 2011 9:32 PM
> To: Winkler, Tomas
> Cc: Weil, Oren jer; gregkh@suse.de; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
> 
> On Thu, Sep 22, 2011 at 09:12:21PM +0300, Winkler, Tomas wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Thursday, September 22, 2011 7:30 PM
> > > To: Weil, Oren jer
> > > Cc: gregkh@suse.de; devel@driverdev.osuosl.org; Winkler, Tomas;
> > > linux- kernel@vger.kernel.org
> > > Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done
> tasks.
> > >
> > > On Wed, Sep 21, 2011 at 04:45:31PM +0300, Oren Weil wrote:
> > > > Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> > > > Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
> > > > ---
> > > >  drivers/staging/mei/TODO |   10 ----------
> > > >  1 files changed, 0 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/drivers/staging/mei/TODO b/drivers/staging/mei/TODO
> > > > index 3b6a667..7d9a13b 100644
> > > > --- a/drivers/staging/mei/TODO
> > > > +++ b/drivers/staging/mei/TODO
> > > > @@ -1,14 +1,4 @@
> > > >  TODO:
> > > > -	- Create in-kernel Client API. Examples of in-kernel clients are
> > > watchdog and AMTHI.
> > >
> > > Did you really do this?
> > We came to conclusion, this is not really necessary.
> 
> Why?  Where was that discussion?

You're right about it  we did it only internally, yet we also produced this requirement internally. Not sure how to address it in this  stage.
> 
> > > > -	- ME Watchdog Driver to expose standard Linux watchdog interface
> >
> > Yes, this was submitted in the previous batch and it doesn't required
> > really decupling as we previously estimated.
> 
> Ok, good.
> 
> > > And this?
> > >
> > > > -	- Rewrite AMTHI to use in-kernel client interface
> > >
> > > And this?
> > This would be only use case for creating API and in this case it would
> > just bloat the driver for little benefit.
> 
> Again, where was that discussion?
> 
> > Since this le
> 
> ???
> 
> > >
> > > > -	- Cleanup init and probe functions
> > > > -	- Review BUG/BUG_ON usage
> > > > -	- Cleanup and reorganize header files
> > > > -	- Rewrite client data structure
> > >
> > > And this?
> >
> > This was mostly done, you can judge if this is enough.
> 
> Ok, will look at this later.
> 
> > > > -	- Make state machine more readable
> > > > -	- Add mei.txt with driver explanation and it's driver
> > >
> > > You really don't describe the kernel/user api here, that needs to be
> > > well documented as it is a ABI you are creating and we need to know
> > > how it works.
> >
> > The API is described in the mei.txt that is present in the driver folder.
> 
> Really?  I see no description of the ioctls and the structures used in them, no
> any explaination of any of the sysfs files used in the driver in that file.  Please
> fix this up.  The proper format for all sysfs files is described in
> Documentation/ABI/README and the ioctls you can also use the same
> format.

We don't really use sysfs anymore this is just legacy named wrappers for adding device class, we should fix that.
We will address the IOCTLs as well.

> > There was also lengthy discussion about it In LKML during our first
> > try to submit the driver. If it is still not clear enough please let
> > us know we would happy to fix it as any other gaps.
> 
> It's not clear at all.  Where is the userspace tools that interact with this driver
> that allows me to test that the code works properly?  That would be a good
> first step as I do have access to this hardware around here to test with.  Do
> any distros already have it packaged anywhere?

In the mei.txt file are links to  freely available APIs. The user space is usually developed by  third parties
yet you can get  AMT Configuration Utility from http://software.intel.com/. We will send the patch to mei.txt that add the link.

I personally don't working with distros, but I believe that SUSE has major deployment of iAMT (MEI).  Oren may have more info about it.

Thanks
Tomas



> thanks,
> 
> greg k-h
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

