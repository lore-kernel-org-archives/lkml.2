Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab2JaSPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:15:13 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:51644 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab2JaSPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:15:11 -0400
Date: Wed, 31 Oct 2012 16:15:02 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Jeff Cook <jeff@deserettechnology.com>
Cc: linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add support for BCM20702A0 [0b05, 17b5]
Message-ID: <20121031181502.GA1679@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Jeff Cook <jeff@deserettechnology.com>,
	linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
	johan.hedberg@gmail.com, linux-kernel@vger.kernel.org
References: <5087B517.9090703@deserettechnology.com>
 <1351335688-17936-1-git-send-email-jeff@deserettechnology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351335688-17936-1-git-send-email-jeff@deserettechnology.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

* Jeff Cook <jeff@deserettechnology.com> [2012-10-27 05:01:28 -0600]:

> Vendor-specific ID for BCM20702A0.
> Support for bluetooth over Asus Wi-Fi GO!, included with Asus P8Z77-V
> Deluxe.
> 
> T:  Bus=07 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=12  MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0b05 ProdID=17b5 Rev=01.12
> S:  Manufacturer=Broadcom Corp
> S:  Product=BCM20702A0
> S:  SerialNumber=94DBC98AC113
> C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> 
> Signed-off-by: Jeff Cook <jeff@deserettechnology.com>
> ---
>  drivers/bluetooth/btusb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 654e248..1d7b126 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -96,6 +96,7 @@ static struct usb_device_id btusb_table[] = {
>  	{ USB_DEVICE(0x0c10, 0x0000) },
>  
>  	/* Broadcom BCM20702A0 */
> +	{ USB_DEVICE(0x0b05, 0x17b5) },
>  	{ USB_DEVICE(0x0489, 0xe042) },
>  	{ USB_DEVICE(0x413c, 0x8197) },

This patch doesn't apply on bluetooth.git can you please rebase it on of it.
You can find the bluetooth.git tree at:

http://git.kernel.org/?p=linux/kernel/git/bluetooth/bluetooth.git;a=summary

	Gustavo
