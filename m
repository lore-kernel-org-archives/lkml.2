Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1HXVvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:51:05 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:4115 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1HXVvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:51:02 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Thread-Topic: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Thread-Index: AQHMQxTTgzmsMn/8gUaVtEtcxauI8JUruumA//+rW0CAAJyGgIAAbFsAgAC0IAD//5FzEA==
Date: Wed, 24 Aug 2011 21:51:00 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B29C8@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-3-git-send-email-kys@microsoft.com>
 <20110823224157.GA9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B236E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824025913.GC30779@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B27B9@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824201144.GA28667@kroah.com>
In-Reply-To: <20110824201144.GA28667@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.72]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, August 24, 2011 4:12 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
> mod_devicetable.h
> 
> On Wed, Aug 24, 2011 at 04:46:11PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Tuesday, August 23, 2011 10:59 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > > Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
> > > mod_devicetable.h
> > >
> > > On Wed, Aug 24, 2011 at 12:44:38AM +0000, KY Srinivasan wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Greg KH [mailto:greg@kroah.com]
> > > > > Sent: Tuesday, August 23, 2011 6:42 PM
> > > > > To: KY Srinivasan
> > > > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > > > > Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id
> to
> > > > > mod_devicetable.h
> > > > >
> > > > > On Fri, Jul 15, 2011 at 10:45:51AM -0700, K. Y. Srinivasan wrote:
> > > > > > In preparation for implementing vmbus aliases for auto-loading
> > > > > > Hyper-V drivers, define vmbus specific device ID.
> > > > > >
> > > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > > > ---
> > > > > >  include/linux/mod_devicetable.h |    7 +++++++
> > > > > >  1 files changed, 7 insertions(+), 0 deletions(-)
> > > > > >
> > > > > > diff --git a/include/linux/mod_devicetable.h
> > > > > b/include/linux/mod_devicetable.h
> > > > > > index ae28e93..5a12377 100644
> > > > > > --- a/include/linux/mod_devicetable.h
> > > > > > +++ b/include/linux/mod_devicetable.h
> > > > > > @@ -405,6 +405,13 @@ struct virtio_device_id {
> > > > > >  };
> > > > > >  #define VIRTIO_DEV_ANY_ID	0xffffffff
> > > > > >
> > > > > > +/*
> > > > > > + * For Hyper-V devices we use the device guid as the id.
> > > > > > + */
> > > > > > +struct hv_vmbus_device_id {
> > > > > > +	__u8 guid[16];
> > > > > > +};
> > > > >
> > > > > Why do you not need a driver_data pointer here?  Are you sure you aren't
> > > > > ever going to need it in the future?  Hint, I think you will...
> > > >
> > > > I am not sure I am following you here; the guid is the device ID and it is
> > > > guaranteed to remain the same. What is the driver _data pointer here
> > > > you are referring to here.  While some device id have the _data pointer,
> > > > there are others that don't - for instance struct virtio_device_id. In
> > > > our case, I am not sure how I would use this private pointer.
> > >
> > > You use it like all other drivers use it, only if needed.
> >
> > Fair enough; the point is I am not sure how I would use it.
> >
> > >
> > > Hint, I think you need to use it in your hv_utils driver, it would
> > > reduce the size of your code and simplify your logic.
> >
> > Could you expand on this. Currently the util driver handles a bunch
> > services that have their own guids - and these have been included
> > in the idtable. How would having the pointer simplify this code.
> 
> It would allow you, in your probe function, to do something different
> depending on the guid that the probe function was matching on.  So you
> would not have to check the guid again to do that, just use the data
> pointed in that void pointer and away you go.
> 
> As an example, look at drivers/usb/class/cdc-acm.c, the acm_ids[]
> variable which uses the driver_info field to contain a quirk for the
> device.

Ok; this makes sense. But I currently don't have any quirks to support!
The util driver is not even a driver in the true sense. I made it a driver and
added the probe function just to support auto-loading with the vmbus ID space
that I am trying to implement here - the probe function does nothing.

So, if it is ok with you, I will not add driver_data pointer since I will not be
using it.
 
> 
> > I looked at the usage of this in PCI and it appears to be for supporting
> > dynamic  IDs for existing drivers.
> 
> No, that's exactly wrong.  dynamic ids play havoc with this pointer,
> making some drivers not be able to handle dynamic ids because they rely
> on it for some driver-specific information to be passed in it, which
> dynamic ids can not handle.
> 
> Oh, have you remembered to turn off dynamic ids for these devices?  Or
> do you support them properly?

I don't support dynamic IDs. What would I need to do to turn it off.

Regards,

K. Y
