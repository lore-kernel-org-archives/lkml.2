Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1IVSMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:12:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:54640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab1IVSM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:12:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,424,1312182000"; 
   d="scan'208";a="61915943"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <greg@kroah.com>, "Weil, Oren jer" <oren.jer.weil@intel.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 22 Sep 2011 21:12:21 +0300
Subject: RE: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Thread-Topic: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
Thread-Index: Acx5ROFFs6B0A+ReQI2dg5OcVbEroAACXWdw
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401CB6A334F@hasmsx504.ger.corp.intel.com>
References: <1316612731-20905-1-git-send-email-oren.jer.weil@intel.com>
 <1316612731-20905-2-git-send-email-oren.jer.weil@intel.com>
 <20110922162953.GA31282@kroah.com>
In-Reply-To: <20110922162953.GA31282@kroah.com>
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
> Sent: Thursday, September 22, 2011 7:30 PM
> To: Weil, Oren jer
> Cc: gregkh@suse.de; devel@driverdev.osuosl.org; Winkler, Tomas; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] staging: mei: clean the TODO file from done tasks.
> 
> On Wed, Sep 21, 2011 at 04:45:31PM +0300, Oren Weil wrote:
> > Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> > Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
> > ---
> >  drivers/staging/mei/TODO |   10 ----------
> >  1 files changed, 0 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/staging/mei/TODO b/drivers/staging/mei/TODO index
> > 3b6a667..7d9a13b 100644
> > --- a/drivers/staging/mei/TODO
> > +++ b/drivers/staging/mei/TODO
> > @@ -1,14 +1,4 @@
> >  TODO:
> > -	- Create in-kernel Client API. Examples of in-kernel clients are
> watchdog and AMTHI.
> 
> Did you really do this?
We came to conclusion, this is not really necessary.
> 
> > -	- ME Watchdog Driver to expose standard Linux watchdog interface

Yes, this was submitted in the previous batch and it doesn't required really decupling as we previously estimated.
 
> And this?
> 
> > -	- Rewrite AMTHI to use in-kernel client interface
> 
> And this?
This would be only use case for creating API and in this case it would just bloat the driver for little benefit.

Since this le
> 
> > -	- Cleanup init and probe functions
> > -	- Review BUG/BUG_ON usage
> > -	- Cleanup and reorganize header files
> > -	- Rewrite client data structure
> 
> And this?

This was mostly done, you can judge if this is enough.

> 
> > -	- Make state machine more readable
> > -	- Add mei.txt with driver explanation and it's driver
> 
> You really don't describe the kernel/user api here, that needs to be well
> documented as it is a ABI you are creating and we need to know how it
> works.

The API is described in the mei.txt that is present in the driver folder. There was also lengthy discussion about it 
In LKML during our first try to submit the driver. If it is still not clear enough please let us know we would happy to fix it 
as any other gaps.

Thanks
Tomas
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

