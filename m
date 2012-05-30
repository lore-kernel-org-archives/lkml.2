Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2E3Tgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:36:44 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2558 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482Ab2E3Tgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:36:43 -0400
Message-ID: <1338406601.7051.1.camel@x61.thuisdomein>
Subject: Re: [PATCH] bluetooth: btusb: Add vendor ID 0489:e031 for BCM20702A0
From: Paul Bolle <pebolle@tiscali.nl>
To: Ayan George <ayan.george@canonical.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 21:36:41 +0200
In-Reply-To: <4fc6745d.+wSbKD2qBTl+TgNj%ayan.george@canonical.com>
References: <4fc6745d.+wSbKD2qBTl+TgNj%ayan.george@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 30 May 2012 19:36:41.0248 (UTC) FILETIME=[89918200:01CD3E9B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 19:26 +0000, Ayan George wrote:
> Bus=02 Lev=02 Prnt=02 Port=03 Cnt=02 Dev#= 4 Spd=12 MxCh= 0
> D: Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
> P: Vendor=0489 ProdID=e031 Rev=01.12
> S: Manufacturer=Broadcom Corp
> S: Product=BCM20702A0
> S: SerialNumber=C0F8DAB42725
> C: #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I: If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> 
> BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/863051
> Signed-off-by: Ayan George <ayan.george@canonical.com>
> ---
>  drivers/bluetooth/btusb.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index c9463af..e847aa0 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -102,6 +102,7 @@ static struct usb_device_id btusb_table[] = {
>  
>  	/* Broadcom BCM20702A0 */
>  	{ USB_DEVICE(0x0489, 0xe042) },
> +	{ USB_DEVICE(0x0489, 0xe031) },

Can't this be moved one line up?

>  	{ USB_DEVICE(0x0a5c, 0x21e3) },
>  	{ USB_DEVICE(0x0a5c, 0x21e6) },
>  	{ USB_DEVICE(0x0a5c, 0x21e8) },


Paul Bolle

