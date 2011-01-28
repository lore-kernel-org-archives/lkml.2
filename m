Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1A1Qbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:31:34 -0500
Received: from butterbrot.org ([88.198.47.201]:60815 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab1A1Qbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:31:33 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 11:31:33 EST
Subject: Re: [2/2] hid-multitouch: introduce IrTouch Infrared USB device
From: Florian Echtler <floe@butterbrot.org>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1296230680-2871-2-git-send-email-benjamin.tissoires@enac.fr>
References: <1296230680-2871-2-git-send-email-benjamin.tissoires@enac.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 17:24:00 +0100
Message-ID: <1296231840.2959.23.camel@hanuta>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

> The product id is the 42 inches one. I don't know if they have
> other product id for the other size, or if it is a per-size product id.
This is very interesting, I have access to a 65" IrTouch system which
has VID 0x6615 and PID 0x0C20. I wasn't aware that there are already
kernel drivers for their systems, I had been playing around with their
awful binary driver and had done some experiments with libusb. Is there
a documentation of some kind available?
 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 92a0d61..b1dd7ad 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -333,6 +333,9 @@
>  #define USB_VENDOR_ID_IMATION		0x0718
>  #define USB_DEVICE_ID_DISC_STAKKA	0xd000
>  
> +#define USB_VENDOR_ID_IRTOUCHSYSTEMS	0x6615
> +#define USB_DEVICE_ID_IRTOUCH_INFRARED_USB	0x0070
I will test this on our screen next week.
I assume that I should use the tree from:
http://git.kernel.org/?p=linux/kernel/git/rydberg/input-mt.git;a=summary

Note: after briefly browsing through hid-multitouch.c, it seems to me
that there might be issues; the USB interface on our screen doesn't
report as HID device, but as vendor class (0xFF).

Florian


