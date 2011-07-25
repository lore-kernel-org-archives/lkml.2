Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1GYJYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:24:10 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:50040 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1GYJYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:24:06 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jul 2011 05:24:05 EDT
Subject: Re: [PATCH 3/3] hid-multitouch: Add LG Display Multitouch device.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <1311545261-34067-3-git-send-email-jeffbrown@android.com>
Date: Mon, 25 Jul 2011 11:18:45 +0200
Cc: USB list <linux-input@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jeff Brown <jeffbrown@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <9B9DAF0C-EB98-4DC3-9D29-F388CB599E61@enac.fr>
References: <1311545261-34067-1-git-send-email-jeffbrown@android.com> <1311545261-34067-3-git-send-email-jeffbrown@android.com>
To: jeffbrown@android.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 25 juil. 2011 à 00:07, jeffbrown@android.com a écrit :

> From: Jeff Brown <jeffbrown@google.com>
> 
> Signed-off-by: jeffbrown@android.com
> ---
> drivers/hid/hid-ids.h        |    3 +++
> drivers/hid/hid-multitouch.c |    5 +++++
> 2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index db63ccf..637e6e9 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -419,6 +419,9 @@
> #define USB_DEVICE_ID_LD_HYBRID		0x2090
> #define USB_DEVICE_ID_LD_HEATCONTROL	0x20A0
> 
> +#define USB_VENDOR_ID_LG		0x1fd2
> +#define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
> +
> #define USB_VENDOR_ID_LOGITECH		0x046d
> #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
> #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 4ee21ac..b03a0b0 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -682,6 +682,11 @@ static const struct hid_device_id mt_devices[] = {
> 		HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
> 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
> 
> +	/* LG Display panels */
> +	{ .driver_data = MT_CLS_DEFAULT,
> +		HID_USB_DEVICE(USB_VENDOR_ID_LG,
> +			USB_DEVICE_ID_LG_MULTITOUCH) },
> +
> 	/* Lumio panels */
> 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
> 		HID_USB_DEVICE(USB_VENDOR_ID_LUMIO,
> -- 
> 1.7.0.4
> 

I don't have access to the panel for testing, but I trust that Jeff has tested it :-)

Acked-by: Stéphane Chatty <chatty@enac.fr>


