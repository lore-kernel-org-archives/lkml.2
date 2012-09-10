Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2IJR2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:28:45 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:33923 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2IJR2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:28:42 -0400
X-Greylist: delayed 1020 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Sep 2012 13:28:42 EDT
From: Thomas =?iso-8859-1?q?Sch=E4fer?= <tschaefer@t-online.de>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [ 34/95] USB: option: add ZTE K5006-Z
Date: Mon, 10 Sep 2012 19:11:27 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.20-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?iso-8859-1?q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <20120909224155.514234762@decadent.org.uk>
In-Reply-To: <20120909224155.514234762@decadent.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209101911.27928.tschaefer@t-online.de>
X-ID: S8EFNkZQrhKZSy5Yi8M6kzFEt56i06oCrIzNInl77Cx2ahNM0iU82lnNWaf0t9SQ-b
X-TOI-MSGID: 48ade4d5-d7dd-438e-aefa-a61b1c9f1de4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 10. September 2012 um 00:42:24 schrieb Ben Hutchings:
> 3.2-stable review patch.  If anyone has any objections, please let me know.



referring to

http://www.spinics.net/lists/linux-usb/msg70131.html

it should not be done with ff ff ff


Thomas







> 
> ------------------
> 
> From: Bjørn Mork <bjorn@mork.no>
> 
> commit f1b5c997e68533df1f96dcd3068a231bca495603 upstream.
> 
> The ZTE (Vodafone) K5006-Z use the following
> interface layout:
> 
> 00 DIAG
> 01 secondary
> 02 modem
> 03 networkcard
> 04 storage
> 
> Ignoring interface #3 which is handled by the qmi_wwan
> driver.
> 
> Cc: Thomas Schäfer <tschaefer@t-online.de>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/usb/serial/option.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index 9930628..cc40f47 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -886,6 +886,8 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1010, 0xff, 0xff, 
0xff),
>  	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1012, 0xff, 0xff, 0xff)
> }, +	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1018, 0xff, 0xff,
> 0xff), +	  .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1057, 0xff, 0xff, 0xff)
> }, { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1058, 0xff, 0xff,
> 0xff) }, { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1059, 0xff,
> 0xff, 0xff) },

