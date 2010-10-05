Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0JETKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:10:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60679 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0JETKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:10:50 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 6 Oct 2010 00:40:33 +0530
Subject: RE: [PATCH 0/3] prepare TI_ST to move out of staging
Thread-Topic: [PATCH 0/3] prepare TI_ST to move out of staging
Thread-Index: ActkvmoqowOT3q3CQJ6/pyVk1qG5kgAAB1yAAAB+o5A=
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21CB25@dbde02.ent.ti.com>
References: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
 <20101005184925.GA20825@kroah.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

 
> -----Original Message-----
> From: Savoy, Pavan
> Sent: Tuesday, October 05, 2010 1:58 PM
> To: 'Greg KH'
> Cc: gregkh@suse.de; alan@lxorguk.ukuu.org.uk; devel@driverdev.osuosl.org;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH 0/3] prepare TI_ST to move out of staging
> 
> 
> Greg,
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, October 05, 2010 1:49 PM
> > To: Savoy, Pavan
> > Cc: gregkh@suse.de; alan@lxorguk.ukuu.org.uk; devel@driverdev.osuosl.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 0/3] prepare TI_ST to move out of staging
> >
> > On Thu, Sep 30, 2010 at 04:13:27PM -0400, pavan_savoy@ti.com wrote:
> > > From: Pavan Savoy <pavan_savoy@ti.com>
> > >
> > > Greg,
> > >
> > > As suggested, the patch has been modified to set of 3 patches.
> > > 1. to add the new line discipline number to tty.h
> > > 2. rm the __KERNEL__ since the header is no more required for user-space
> > > 3. mv the header file to include/linux/
> > >
> > > Please review.
> >
> > Looks good, all queued up now.
> >
> > So, on to moving the drivers out of the staging tree, right?  Care to
> > send me patches for them?  Have you gotten the bluetooth driver reviewed
> > yet?
> 
> No not yet.
> I had planned to put up a patch to move the st_core.c, st_kim.c and st_ll.c to
> drivers/misc/ first.
> Then put together Bluetooth header and driver where in I will bring in
> Marcel/Johan & linux-bluetooth into the loop.
> Then move the unified bt_drv.c to something like ti_st_bt.c to
> drivers/bluetooth/
> 
> Does this sound OK?
> Marcel pretty much knows about the driver since I first posted the patch to
> linux-bluetooth too.

Along with Bluetooth, we have some FM V4L2 patches which are being reviewed and re-submitted to the linux-media list, we will bring in them, once the linux-media ACKs them.

They are intended for staging too, since there are few conflicts with other patches posted, I suppose it should be alright for them to go into the linux-next via your staging-next since the linux-media trees lags behind linux-next.


 > thanks,
> >
> > greg k-h
