Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1LTX2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:28:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab1LTX2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:28:03 -0500
Date: Wed, 21 Dec 2011 00:28:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ignaz Forster <ignaz.forster@gmx.de>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable HID_QUIRK_MULTI_INPUT for Trio Linker Plus II
In-Reply-To: <4EEC8839.1010801@gmx.de>
Message-ID: <alpine.LNX.2.00.1112210027550.8727@pobox.suse.cz>
References: <4EEC8839.1010801@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Dec 2011, Ignaz Forster wrote:

> Add quirk for the Trio Linker Plus II - the adapter supports several controllers simultaneously, generating a new HID entry for each connected device.
> 
> Signed-off-by: Ignaz Forster <ignaz.forster@gmx.de>
> ---
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 5028d60..4d256a7 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -47,6 +47,7 @@ static const struct hid_blacklist {
>  
>  	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
>  
> +	{ USB_VENDOR_ID_EMS, USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II, HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_ETURBOTOUCH, USB_DEVICE_ID_ETURBOTOUCH, HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_GREENASIA, USB_DEVICE_ID_GREENASIA_DUAL_USB_JOYPAD, HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
