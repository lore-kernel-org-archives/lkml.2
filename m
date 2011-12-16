Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261Ab1LPQif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:38:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760202Ab1LPQiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:38:25 -0500
Date: Fri, 16 Dec 2011 17:38:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Aurelien Jacobs <aurel@gnuage.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] asix: new device id
In-Reply-To: <1324050921-9007-1-git-send-email-aurel@gnuage.org>
Message-ID: <alpine.LRH.2.00.1112161737040.15661@twin.jikos.cz>
References: <1324050921-9007-1-git-send-email-aurel@gnuage.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011, Aurelien Jacobs wrote:

> Adds the device id needed for the USB Ethernet Adapter delivered by
> ASUS with their Zenbook.
> 
> Signed-off-by: Aurelien Jacobs <aurel@gnuage.org>
> ---
>  drivers/net/usb/asix.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
> index e6fed4d..e95f0e6 100644
> --- a/drivers/net/usb/asix.c
> +++ b/drivers/net/usb/asix.c
> @@ -1655,6 +1655,10 @@ static const struct usb_device_id	products [] = {
>  	// ASIX 88772a
>  	USB_DEVICE(0x0db0, 0xa877),
>  	.driver_info = (unsigned long) &ax88772_info,
> +}, {
> +	// Asus USB Ethernet Adapter
> +	USB_DEVICE (0x0b95, 0x7e2b),
> +	.driver_info = (unsigned long) &ax88772_info,
>  },
>  	{ },		// END
>  };

Adding netdev to CC so that it doesn't get lost.

-- 
Jiri Kosina
SUSE Labs

