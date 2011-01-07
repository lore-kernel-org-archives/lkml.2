Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1AGMHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:07:41 -0500
Received: from mailout01.t-online.de ([194.25.134.80]:56788 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1AGMHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:07:39 -0500
Message-ID: <4D2701F7.5090503@t-online.de>
Date: Fri, 07 Jan 2011 13:07:19 +0100
From: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101230 Lanikai/3.1.7
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Sergey Vlasov <vsu@altlinux.ru>, Greg KH <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: [PATCH v2] USB: usb-storage: unusual_devs update for Cypress
 ATACB
References: <4D11FBEF.7040101@t-online.de>
In-Reply-To: <4D11FBEF.7040101@t-online.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: Z1ZY6vZl8hJbU0l5PeSQPbsL60AgjPQk8uh9pInVYWLeGFrro73XwDC5OiAlYY9Z4f
X-TOI-MSGID: ee2f2cb7-02ee-420c-ae6c-372205d9a12b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Added new device ID for unusual Cypress ATACB device.
>
> Signed-off-by: Richard Schütz <r.schtz@t-online.de>
> ---
>
> Applies to 2.6.37-rc7 now.
>
> --- a/drivers/usb/storage/unusual_cypress.h 2010-12-21 20:26:40.000000000 +0100
> +++ b/drivers/usb/storage/unusual_cypress.h 2010-12-22 12:38:49.013825668 +0100
> @@ -31,4 +31,9 @@ UNUSUAL_DEV( 0x04b4, 0x6831, 0x0000, 0x
> "Cypress ISD-300LP",
> USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
>
> +UNUSUAL_DEV( 0x14cd, 0x6116, 0x0000, 0x9999,
> + "Super Top",
> + "USB 2.0 SATA BRIDGE",
> + USB_SC_CYP_ATACB, USB_PR_DEVICE, NULL, 0),
> +
> #endif /* defined(CONFIG_USB_STORAGE_CYPRESS_ATACB) || ... */
>

Why was this simple patch not accepted (yet)? Is something wrong with it?

Discussion was here:
http://thread.gmane.org/gmane.linux.usb.general/40545
http://thread.gmane.org/gmane.linux.usb.general/40550

-- 
Regards,
Richard Schütz
