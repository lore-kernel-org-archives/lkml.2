Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab0JHOyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:54:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59218 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420Ab0JHOyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:54:54 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
CC: "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 8 Oct 2010 20:24:41 +0530
Subject: RE: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Topic: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Thread-Index: ActmxBoaXVmrIZigRYa1xxxykcw0JgANGdIA
Message-ID: <19F8576C6E063C45BE387C64729E739404AA3B766D@dbde02.ent.ti.com>
References: <1286477237-7526-1-git-send-email-pavan_savoy@ti.com>
	 <1286477237-7526-2-git-send-email-pavan_savoy@ti.com>
	 <20101007184534.GB13602@vigoh> <1286527062.6145.182.camel@aeonflux>
In-Reply-To: <1286527062.6145.182.camel@aeonflux>
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



> -----Original Message-----
> From: Marcel Holtmann [mailto:marcel@holtmann.org]
> Sent: Friday, October 08, 2010 3:38 AM
> To: Gustavo F. Padovan
> Cc: Savoy, Pavan; linux-bluetooth@vger.kernel.org; greg@kroah.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
> 
> Hi Gustavo,
> 
> > Change the commit subject to "Bluetooth: TI_ST bluetooth driver"
> >
> > * pavan_savoy@ti.com <pavan_savoy@ti.com> [2010-10-07 14:47:16 -0400]:
> >
> > > From: Pavan Savoy <pavan_savoy@ti.com>
> > >
> > > This is the bluetooth protocol driver for the TI WiLink7 chipsets.
> > > Texas Instrument's WiLink chipsets combine wireless technologies
> > > like BT, FM, GPS and WLAN onto a single chip.
> > >
> > > This Bluetooth driver works on top of the TI_ST shared transport
> > > line discipline driver which also allows other drivers like
> > > FM V4L2 and GPS character driver to make use of the same UART interface.
> > >
> > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > > ---
> > >  drivers/bluetooth/bt_ti.c |  489
> +++++++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 489 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/bluetooth/bt_ti.c
> >
> > We don't have filename with bt_.. in drivers/bluetooth/. Maybe ti_st.c
> > should be a better name, or something like that.
> 
> actually we have the bt prefix for company generic ones where they
> didn't wanna use the hardware name.
> 
> So I prefer to use the hardware for a driver since it is much more clear
> that way. You acronym naming here is bad. It is confusing like hell.
> 
> What about just calling this btwilink.c or something. I just spinning
> ideas here.

Ok, I like btwilink.c too. Does bt_wilink.c sound OK?
I have sent a patch with ti_st.c as of now.

Please review, and provide comments. I will incorporate comments and change
Name in the next version of the patch.

Thanks,
Pavan

> Regards
> 
> Marcel
> 

