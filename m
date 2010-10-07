Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0JGVYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:24:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55211 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab0JGVYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:24:35 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>
CC: Greg KH <greg@kroah.com>, "pavan-savoy@ti.com" <pavan-savoy@ti.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Oct 2010 02:54:22 +0530
Subject: RE: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Topic: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Index: ActmYi9vhCBjJv/0SVa8bmtPbV1Z+gAA6KGQ
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21D256@dbde02.ent.ti.com>
References: <1286404493-23816-1-git-send-email-pavan-savoy@ti.com>
 <1286404493-23816-2-git-send-email-pavan-savoy@ti.com>
 <1286445948.6145.70.camel@aeonflux> <20101007143409.GB14913@kroah.com>
 <1286464867.6145.148.camel@aeonflux> <20101007175715.GA13602@vigoh>
In-Reply-To: <20101007175715.GA13602@vigoh>
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

Marcel, Gustavo,

> -----Original Message-----
> From: Gustavo F. Padovan [mailto:pao@profusion.mobi] On Behalf Of Gustavo F.
> Padovan
> Sent: Thursday, October 07, 2010 12:57 PM
> To: Marcel Holtmann
> Cc: Greg KH; pavan-savoy@ti.com; linux-bluetooth@vger.kernel.org;
> johan.hedberg@gmail.com; linux-kernel@vger.kernel.org; Savoy, Pavan
> Subject: Re: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
> 
> * Marcel Holtmann <marcel@holtmann.org> [2010-10-07 17:21:07 +0200]:
> 
> > Hi Greg,
> >
> > > > > This is the bluetooth protocol driver for the TI WiLink7 chipsets.
> > > > > Texas Instrument's WiLink chipsets combine wireless technologies
> > > > > like BT, FM, GPS and WLAN onto a single chip.
> > > > >
> > > > > This Bluetooth driver works on top of the TI_ST shared transport
> > > > > line discipline driver which also allows other drivers like
> > > > > FM V4L2 and GPS character driver to make use of the same UART
> interface.
> > > > >
> > > > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > > > > ---
> > > > >  drivers/bluetooth/bt_ti.c      |  463
> ++++++++++++++++++++++++++++++++++++
> > > > >  drivers/staging/ti-st/bt_drv.c |  509 -------------------------------
> ---------
> > > > >  drivers/staging/ti-st/bt_drv.h |   61 -----
> > > > >  3 files changed, 463 insertions(+), 570 deletions(-)
> > > > >  create mode 100644 drivers/bluetooth/bt_ti.c
> > > > >  delete mode 100644 drivers/staging/ti-st/bt_drv.c
> > > > >  delete mode 100644 drivers/staging/ti-st/bt_drv.h
> > > >
> > > > I don't care about staging at all. So you sort that out with Greg.
> > > >
> > > > Submit your driver for upstream inclusion. And once accepted you can pin
> > > > Greg about removing it.
> > >
> > > The driver is already in staging, this is the request to move it out of
> > > staging and into the "correct" place in the tree.  The core of the ti-st
> > > code is now in the drivers/misc/ directory in the linux-next tree, and
> > > this patch is the request to move the bluetooth drive into the proper
> > > drivers/bluetooth/ location.
> >
> > nice idea, but I don't want it that way. I am not dealing with staging
> > at all. They can submit this driver for upstream inclusion and then
> > delete it in a second step from staging. Or the other way around.
> 
> We just have to be sure to do both steps in the same release cycle,
> otherwise we could ship the driver twice in the kernel (considering we
> will delete it after merge in drivers/bluetooth/)

Yes, once this is reviewed, I will send across patches to delete it from staging.
Also note, I have sent across updates patches, So please review.

The shared transport design can be found @ http://omappedia.org/wiki/Wilink_ST


> Gustavo F. Padovan
> ProFUSION embedded systems - http://profusion.mobi
