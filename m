Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0CVP1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:27:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:57284 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab0CVP1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:27:09 -0400
Date: Mon, 22 Mar 2010 16:27:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Michael Poole <mdpoole@troilus.org>, simon.windows@gmail.com,
       Sean Hildebrand <silverwraithii@gmail.com>,
       Sid Boyce <sboyce@blueyonder.co.uk>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2] Updated hid_blacklist, reformatted code and removed
 unused variable
In-Reply-To: <201003221614.38424.erazor_de@users.sourceforge.net>
Message-ID: <alpine.LNX.2.00.1003221626070.18642@pobox.suse.cz>
References: <1268926981.11269.3.camel@localhost> <1269269304.2236.1.camel@localhost> <alpine.LNX.2.00.1003221552360.18642@pobox.suse.cz> <201003221614.38424.erazor_de@users.sourceforge.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010, Stefan Achatz wrote:

> > > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > > index 368fbb0..dbd6fb8 100644
> > > --- a/drivers/hid/hid-core.c
> > > +++ b/drivers/hid/hid-core.c
> > > @@ -1346,6 +1346,7 @@ static const struct hid_device_id hid_blacklist[] =
> > > { { HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX,
> > > USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) }, {
> > > HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH)
> > > }, { HID_USB_DEVICE(USB_VENDOR_ID_QUANTA,
> > > USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) }, +	{
> > > HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_KONE) }, {
> > > HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
> > > { HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER)
> > > }, { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY,
> > > USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
> >
> > Thanks for the fix. I only wonder how well has the driver been tested, as
> > without this change it couldn't get to operate the device at all ... ?
> >
> > Thanks,
> 
> Hi,
> 
> As most testing was done with external module compilation on different kernel 
> versions with generic hid compiled as internal or as module I have a script 
> that uses the drivers sysfs bind/unbind funtionality to switch from generic 
> hid to kone driver. Thats issued via udev and was active all the time.

OK, thanks.

I will fold the patches into one, and I will also make the driver 
independent on CONFIG_EMBEDDED, to be comopatible with other HID drivers 
which are not simple quirks, but rather full, stand-alone HID device 
drivers.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
