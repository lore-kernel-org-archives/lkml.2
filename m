Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab2ESNsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 09:48:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58810 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2ESNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 09:48:51 -0400
Message-ID: <4FB7A4A2.20408@mvista.com>
Date: Sat, 19 May 2012 17:48:18 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jeffrin Jose <ahiliation@yahoo.co.in>
CC: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1]USB:storage:fixed space at the start of a line issues.
References: <1337368715-3859-1-git-send-email-ahiliation@yahoo.co.in>
In-Reply-To: <1337368715-3859-1-git-send-email-ahiliation@yahoo.co.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-05-2012 23:18, Jeffrin Jose wrote:

> Fixed space at the start of a line issues found
> by checkpatch.pl tool in drivers/usb/storage/usual-tables.c

> Signed-off-by: Jeffrin Jose<ahiliation@yahoo.co.in>
> ---
>   drivers/usb/storage/usual-tables.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

> diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
> index b969279..f2301ee 100644
> --- a/drivers/usb/storage/usual-tables.c
> +++ b/drivers/usb/storage/usual-tables.c
> @@ -34,17 +34,17 @@
>   		    vendorName, productName, useProtocol, useTransport, \
>   		    initFunction, flags) \
>   { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
> -  .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
> +.driver_info = (flags)|(USB_US_TYPE_STOR<<24) }

    Spaces are usually replaced by tab. Without indentation this looks worse 
than it was.

WBR, Sergei
