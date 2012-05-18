Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966993Ab2ERTYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:24:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52260 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160Ab2ERTYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:24:49 -0400
Date: Fri, 18 May 2012 12:24:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1]USB:storage:fixed space at the start of a line issues.
Message-ID: <20120518192445.GA4781@kroah.com>
References: <1337368715-3859-1-git-send-email-ahiliation@yahoo.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337368715-3859-1-git-send-email-ahiliation@yahoo.co.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 12:48:35AM +0530, Jeffrin Jose wrote:
> Fixed space at the start of a line issues found
> by checkpatch.pl tool in drivers/usb/storage/usual-tables.c
> 
> Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>

Your subject is better, but now you forgot the spaces after the ':'
characters, what happened to them?

> ---
>  drivers/usb/storage/usual-tables.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
> index b969279..f2301ee 100644
> --- a/drivers/usb/storage/usual-tables.c
> +++ b/drivers/usb/storage/usual-tables.c
> @@ -34,17 +34,17 @@
>  		    vendorName, productName, useProtocol, useTransport, \
>  		    initFunction, flags) \
>  { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
> -  .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
> +.driver_info = (flags)|(USB_US_TYPE_STOR<<24) }

That's dumb, and should not be changed, sorry.

checkpatch isn't always correct, please think when using it.

greg k-h
