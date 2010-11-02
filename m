Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0KBPib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:38:31 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59062 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0KBPiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:38:24 -0400
Subject: Re: [PATCH 3/6] MacBookAir3,1(3,2) btusb support
From: Marcel Holtmann <marcel@holtmann.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        gimli <gimli@dark-green.com>
In-Reply-To: <20101102152454.GC11778@core.coreip.homeip.net>
References: <9e7738c0461aa509dd55fe470df3855e@mognix.dark-green.com>
	 <20101102152454.GC11778@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 16:38:02 +0100
Message-ID: <1288712282.3322.181.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> Not sure of you guys monitor LKML...

not on a regular basis.

> > This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the btusb
> > driver.
> > 
> > Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
> 
> > --- a/drivers/bluetooth/btusb.c	2010-10-30 21:08:45.170492002 +0200
> > +++ b/drivers/bluetooth/btusb.c	2010-10-30 21:18:11.820492000 +0200
> > @@ -62,6 +62,9 @@
> >  	/* Apple iMac11,1 */
> >  	{ USB_DEVICE(0x05ac, 0x8215) },
> >  
> > +	/* Apple MacBookAir3,1, MacBookAir3,2 */
> > +	{ USB_DEVICE(0x05ac, 0x821b) },
> > +
> >  	/* AVM BlueFRITZ! USB v2.0 */
> >  	{ USB_DEVICE(0x057c, 0x3800) },

patch looks fine to me, but it should be send to linux-bluetooth mailing
list.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


