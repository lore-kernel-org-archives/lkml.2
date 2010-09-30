Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab0I3Rd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:33:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59319 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0I3Rd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:33:27 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 30 Sep 2010 23:03:02 +0530
Subject: RE: [PATCH] drivers:staging:ti-st: mv ti_wilink_st header
Thread-Topic: [PATCH] drivers:staging:ti-st: mv ti_wilink_st header
Thread-Index: ActgxQOtCX7DXVK3RLq5y14XCzqXkQAAFP5Q
Message-ID: <19F8576C6E063C45BE387C64729E739404A9D8AEA7@dbde02.ent.ti.com>
References: <1285777522-13709-1-git-send-email-pavan_savoy@ti.com>
 <20100930115123.GB2779@kroah.com>
In-Reply-To: <20100930115123.GB2779@kroah.com>
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
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, September 30, 2010 6:51 AM
> To: Savoy, Pavan
> Cc: gregkh@suse.de; alan@lxorguk.ukuu.org.uk; devel@driverdev.osuosl.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] drivers:staging:ti-st: mv ti_wilink_st header
> 
> On Wed, Sep 29, 2010 at 12:25:22PM -0400, pavan_savoy@ti.com wrote:
> > From: Pavan Savoy <pavan_savoy@ti.com>
> >
> > Greg,
> >
> > How is the movement of drivers done out of staging?
> > Should I submit patches like these, which move individual files without
> > breaking the build during anytime of movement?
> 
> Yes.
> 
> > In few following days I plan to submit patches to move the ST headers
> sources
> > out.
> > ti_wilink_st.h -> include/linux/
> > st_core.c, st_kim.c and st_ll.c -> drivers/misc/
> > Makefile and Kconfig changes to drivers/misc/Kconfig and
> drivers/misc/Makefile
> > bt_drv.c -> drivers/bluetooth/
> 
> Yes, that sounds great.
> 
> But, the bluetooth patch should go to the bluetooth maintainer for his
> review, I'll need the ack from him before I can apply it.

Yes, I will loop in linux-bluetooth and Marcel when I post the Bluetooth driver patch, he has been already introduced to ST, so hopefully the transition is smoother.

> Oh, this patch looks nice, but I found one problem:
> 
> > --- a/drivers/staging/ti-st/ti_wilink_st.h
> > +++ /dev/null
> > -#ifndef TI_WILINK_ST_H
> > -#define TI_WILINK_ST_H
> > -
> > -/* TODO:
> > - * Move the following to tty.h upon acceptance
> > - */
> > -#define N_TI_WL	22	/* Ldisc for TI's WL BT, FM, GPS combo chips */
> 
> We need to do that now, before you move this file.
> 
> Then, you can drop this:
> 
> > -#ifdef __KERNEL__
> 
> As it will not be needed, right?
> 
> Care to send me a patch that does this first?

Yes, sending it right away.

> thanks,
> 
> greg k-h
