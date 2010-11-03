Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0KCSVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:21:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43356 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0KCSVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:21:52 -0400
Date: Wed, 3 Nov 2010 14:21:59 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        gimli <gimli@dark-green.com>
Subject: Re: [PATCH 3/6] MacBookAir3,1(3,2) btusb support
Message-ID: <20101103182159.GA17943@vigoh>
References: <9e7738c0461aa509dd55fe470df3855e@mognix.dark-green.com>
 <20101102152454.GC11778@core.coreip.homeip.net>
 <1288712282.3322.181.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288712282.3322.181.camel@aeonflux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Edgar,

* Marcel Holtmann <marcel@holtmann.org> [2010-11-02 16:38:02 +0100]:

> Hi Dmitry,
> 
> > Not sure of you guys monitor LKML...
> 
> not on a regular basis.
> 
> > > This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the btusb
> > > driver.
> > > 
> > > Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>

Please also provide the output of usb-devices for this hardware in
commit message when resubmitting the patch.

> > 
> > > --- a/drivers/bluetooth/btusb.c	2010-10-30 21:08:45.170492002 +0200
> > > +++ b/drivers/bluetooth/btusb.c	2010-10-30 21:18:11.820492000 +0200
> > > @@ -62,6 +62,9 @@
> > >  	/* Apple iMac11,1 */
> > >  	{ USB_DEVICE(0x05ac, 0x8215) },
> > >  
> > > +	/* Apple MacBookAir3,1, MacBookAir3,2 */
> > > +	{ USB_DEVICE(0x05ac, 0x821b) },
> > > +
> > >  	/* AVM BlueFRITZ! USB v2.0 */
> > >  	{ USB_DEVICE(0x057c, 0x3800) },
> 
> patch looks fine to me, but it should be send to linux-bluetooth mailing
> list.
> 
> Acked-by: Marcel Holtmann <marcel@holtmann.org>

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
