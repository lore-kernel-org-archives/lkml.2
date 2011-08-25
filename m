Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1HYC17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:27:59 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:53803 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab1HYC16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:27:58 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Greg KH <greg@kroah.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
	mod_devicetable.h
Thread-Topic: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
	mod_devicetable.h
Thread-Index: AQHMYqgP9D942x98wEOArdtRLDNz7pUsz65g
Date: Thu, 25 Aug 2011 02:27:56 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B2AF2@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
	<1310752065-27895-1-git-send-email-kys@microsoft.com>
	<1310752065-27895-3-git-send-email-kys@microsoft.com>
	<20110823224157.GA9641@kroah.com>
	<6E21E5352C11B742B20C142EB499E048081B236E@TK5EX14MBXC126.redmond.corp.microsoft.com>
	<20110824025913.GC30779@kroah.com>
	<6E21E5352C11B742B20C142EB499E048081B27B9@TK5EX14MBXC126.redmond.corp.microsoft.com>
	<20110824201144.GA28667@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B29C8@TK5EX14MBXC126.redmond.corp.microsoft.com>
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B29C8@TK5EX14MBXC126.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.79]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel-bounces@linuxdriverproject.org [mailto:devel-
> bounces@linuxdriverproject.org] On Behalf Of KY Srinivasan
> Sent: Wednesday, August 24, 2011 5:51 PM
> To: Greg KH
> Cc: devel@linuxdriverproject.org; Haiyang Zhang; gregkh@suse.de; linux-
> kernel@vger.kernel.org; virtualization@lists.osdl.org
> Subject: RE: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
> mod_devicetable.h
> 
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Wednesday, August 24, 2011 4:12 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
> > mod_devicetable.h
> >
> > On Wed, Aug 24, 2011 at 04:46:11PM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Greg KH [mailto:greg@kroah.com]
> > > > Sent: Tuesday, August 23, 2011 10:59 PM
> > > > To: KY Srinivasan
> > > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > > > Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id
> to
> > > > mod_devicetable.h
> > > >
> > > > On Wed, Aug 24, 2011 at 12:44:38AM +0000, KY Srinivasan wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Greg KH [mailto:greg@kroah.com]
> > > > > > Sent: Tuesday, August 23, 2011 6:42 PM
> > > > > > To: KY Srinivasan
> > > > > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang
> Zhang
> > > > > > Subject: Re: [PATCH 003/117] Staging: hv: Add struct
> hv_vmbus_device_id
> > to
> > > > > > mod_devicetable.h
> > > > > >
> > > > > > On Fri, Jul 15, 2011 at 10:45:51AM -0700, K. Y. Srinivasan wrote:
> > > > > > > In preparation for implementing vmbus aliases for auto-loading
> > > > > > > Hyper-V drivers, define vmbus specific device ID.
> > > > > > >
> > > > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > > > > ---
> > > > > > >  include/linux/mod_devicetable.h |    7 +++++++
> > > > > > >  1 files changed, 7 insertions(+), 0 deletions(-)
> > > > > > >
> > > > > > > diff --git a/include/linux/mod_devicetable.h
> > > > > > b/include/linux/mod_devicetable.h
> > > > > > > index ae28e93..5a12377 100644
> > > > > > > --- a/include/linux/mod_devicetable.h
> > > > > > > +++ b/include/linux/mod_devicetable.h
> > > > > > > @@ -405,6 +405,13 @@ struct virtio_device_id {
> > > > > > >  };
> > > > > > >  #define VIRTIO_DEV_ANY_ID	0xffffffff
> > > > > > >
> > > > > > > +/*
> > > > > > > + * For Hyper-V devices we use the device guid as the id.
> > > > > > > + */
> > > > > > > +struct hv_vmbus_device_id {
> > > > > > > +	__u8 guid[16];
> > > > > > > +};
> > > > > >
> > > > > > Why do you not need a driver_data pointer here?  Are you sure you
> aren't
> > > > > > ever going to need it in the future?  Hint, I think you will...
> > > > >
> > > > > I am not sure I am following you here; the guid is the device ID and it is
> > > > > guaranteed to remain the same. What is the driver _data pointer here
> > > > > you are referring to here.  While some device id have the _data pointer,
> > > > > there are others that don't - for instance struct virtio_device_id. In
> > > > > our case, I am not sure how I would use this private pointer.
> > > >
> > > > You use it like all other drivers use it, only if needed.
> > >
> > > Fair enough; the point is I am not sure how I would use it.
> > >
> > > >
> > > > Hint, I think you need to use it in your hv_utils driver, it would
> > > > reduce the size of your code and simplify your logic.
> > >
> > > Could you expand on this. Currently the util driver handles a bunch
> > > services that have their own guids - and these have been included
> > > in the idtable. How would having the pointer simplify this code.
> >
> > It would allow you, in your probe function, to do something different
> > depending on the guid that the probe function was matching on.  So you
> > would not have to check the guid again to do that, just use the data
> > pointed in that void pointer and away you go.
> >
> > As an example, look at drivers/usb/class/cdc-acm.c, the acm_ids[]
> > variable which uses the driver_info field to contain a quirk for the
> > device.
> 
> Ok; this makes sense. But I currently don't have any quirks to support!
> The util driver is not even a driver in the true sense. I made it a driver and
> added the probe function just to support auto-loading with the vmbus ID space
> that I am trying to implement here - the probe function does nothing.
> 
> So, if it is ok with you, I will not add driver_data pointer since I will not be
> using it.
> 
> >
> > > I looked at the usage of this in PCI and it appears to be for supporting
> > > dynamic  IDs for existing drivers.
> >
> > No, that's exactly wrong.  dynamic ids play havoc with this pointer,
> > making some drivers not be able to handle dynamic ids because they rely
> > on it for some driver-specific information to be passed in it, which
> > dynamic ids can not handle.
> >
> > Oh, have you remembered to turn off dynamic ids for these devices?  Or
> > do you support them properly?
> 
> I don't support dynamic IDs. What would I need to do to turn it off.

Greg,

Since I don't have any (current) use for the driver_data pointer, I have gone ahead
and cleaned up the first 74 patches without adding the driver_data. 
With the mushing of the patches   you had proposed this is about
a 60 patch series and addresses all the other comments you had in the first 74 patches.
I hope I have gotten the "right" granularity now.   If it is ok with you, I could send these 
out for your consideration.

The only unresolved issue in the remaining patches (75 - 117) is the reference counting
issue we have been debating. As I noted in my earlier emails on this topic, the reference
counting has been there for a long time and I am reluctant get rid of that code without 
additional testing/analysis. So I want to propose the following options:

1) Keep the existing code and I will skip the patches that cleaned up the reference counting

2) Take the cleanup that I have implemented

In either case, I would further test and analyze this code to see if (a) the race condition that is being
addressed is valid and (b) if there is a different mechanism that could be used to deal with it. Given
the gaping holes in the current implementation, my personal preference would be to go with the 
second option. Let me know what you want me to do here.  

Regards,

K. Y
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel

