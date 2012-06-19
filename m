Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab2FSLwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:52:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab2FSLwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:52:43 -0400
Date: Tue, 19 Jun 2012 13:52:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the v4l-dvb tree with Linus' tree
In-Reply-To: <4FE0678C.2050205@redhat.com>
Message-ID: <alpine.LNX.2.00.1206191351590.23121@pobox.suse.cz>
References: <20120619112939.23c80aed8f1db9682e37be87@canb.auug.org.au> <alpine.LNX.2.00.1206191205190.15308@pobox.suse.cz> <4FE0678C.2050205@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, Hans de Goede wrote:

> > > diff --cc drivers/hid/hid-ids.h
> > > index 6d3037e,70298d1..0000000
> > > --- a/drivers/hid/hid-ids.h
> > > +++ b/drivers/hid/hid-ids.h
> > > @@@ -160,9 -157,9 +160,12 @@@
> > >    #define USB_VENDOR_ID_AVERMEDIA		0x07ca
> > >    #define USB_DEVICE_ID_AVER_FM_MR800	0xb800
> > > 
> > > + #define USB_VENDOR_ID_AXENTIA		0x12cf
> > > + #define USB_DEVICE_ID_AXENTIA_FM_RADIO	0x7111
> > > +
> > >   +#define USB_VENDOR_ID_BAANTO		0x2453
> > >   +#define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
> > >   +
> > >    #define USB_VENDOR_ID_BELKIN		0x050d
> > >    #define USB_DEVICE_ID_FLIP_KVM		0x3201
> > 
> > Thanks for reporting this, Stephen.
> > 
> > Hmmm ... Mauro, Hans, do you feel it's actually proper to add the device
> > ids to hid-ids.h? I am using this file usually solely for the drivers on
> > the HID bus, which radio-si470x is not, I believe.
> 
> Not sure what you mean with "drivers on the HID bus", radio-si470x drivers
> do use a USB-HID class interface, but the driver itself does not use
> the kernel hid framework. The ids in hid-ids are used for adding this device
> to the hid-core "blacklist" to avoid usb-hid from binding to it, so that
> radio-si470x-usn can bind to it.

Gah, sorry, ENOTENOUGHCOFFEE, I have missed that hunk. All is fine then.

-- 
Jiri Kosina
SUSE Labs
