Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1LMUeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:34:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52254 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1LMUeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:34:15 -0500
Message-ID: <4EE7B667.100@solonet.org.ua>
Date: Tue, 13 Dec 2011 22:32:39 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>
CC: Oliver Neukum <oliver@neukum.name>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add PCI IDs for Motorola H24 HSPA USB module.
References: <m3liqiylz4.fsf@t19.piap.pl>
In-Reply-To: <m3liqiylz4.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 03:10 PM, Krzysztof Hałasa wrote:
> Add PCI IDs for Motorola H24 HSPA USB module.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -1458,6 +1458,16 @@ static const struct usb_device_id acm_ids[] = {
>  	},
>  	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
>  	},
> +	/* Motorola H24 HSPA module: */

AFAIK, Motorola's M2M division was acquired by Telit in March 2011, so
now those devices are called Telit H24. Can you please add note about
that so readers can understand that this code applies or Telit H24 too?


-- 
Best regards, Denis Kuzmenko.
