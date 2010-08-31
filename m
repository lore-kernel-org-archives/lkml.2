Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0HaWik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 18:38:40 -0400
Received: from kroah.org ([198.145.64.141]:41274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab0HaWii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 18:38:38 -0400
Date: Tue, 31 Aug 2010 15:31:29 -0700
From: Greg KH <greg@kroah.com>
To: T Dent <tdent48227@gmail.com>
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com,
        Larry.Finger@lwfinger.net, joe@perches.com, pshah.mumbai@gmail.com
Subject: Re: [PATCH 1/8] Staging: rtl8187se: r8180: fixed alot
 checkpatch.pl issues
Message-ID: <20100831223129.GA316@kroah.com>
References: <AANLkTimEdzcqEv1SCMWyftCwGU-==+vMH8-uuzAHLOM+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimEdzcqEv1SCMWyftCwGU-==+vMH8-uuzAHLOM+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 05:00:13PM -0400, T Dent wrote:
> >From 73dfcd936fcacb6f1dce184e21b177c9fa4797d5 Mon Sep 17 00:00:00 2001
> From: Tracey Dent <Tdent48227@gmail.com>
> Date: Thu, 19 Aug 2010 16:13:48 -0400
> Subject: [PATCH 1/8] Staging: rtl8187se: r8180: fixed alot checkpatch.pl issues
> 
> Fixed numerous coding style issues using checkpatch.pl
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/rtl8187se/r8180.h |  537 ++++++++++++++++++-------------------
>  1 files changed, 265 insertions(+), 272 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/r8180.h
> b/drivers/staging/rtl8187se/r8180.h
> index d15bdf6..c5b1cba 100644
> --- a/drivers/staging/rtl8187se/r8180.h
> +++ b/drivers/staging/rtl8187se/r8180.h
> @@ -1,18 +1,18 @@
>  /*
> -   This is part of rtl8180 OpenSource driver.
> -   Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
> -   Released under the terms of GPL (General Public Licence)
> +	This is part of rtl8180 OpenSource driver.
> +	Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
> +	Released under the terms of GPL (General Public Licence)
> 
> -   Parts of this driver are based on the GPL part of the
> -   official realtek driver
> +	Parts of this driver are based on the GPL part of the
> +	official realtek driver
> 
> -   Parts of this driver are based on the rtl8180 driver skeleton
> -   from Patric Schenke & Andres Salomon
> +	Parts of this driver are based on the rtl8180 driver skeleton
> +	from Patric Schenke & Andres Salomon
> 
> -   Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
> +	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
> 
> -   We want to tanks the Authors of those projects and the Ndiswrapper
> -   project Authors.
> +	We want to tanks the Authors of those projects and the Ndiswrapper
> +	project Authors.
>  */
> 
>  #ifndef R8180H
> @@ -20,13 +20,13 @@
> 
> 
>  #define RTL8180_MODULE_NAME "r8180"
> -#define DMESG(x,a...) printk(KERN_INFO RTL8180_MODULE_NAME ": " x "\n", ## a)
> -#define DMESGW(x,a...) printk(KERN_WARNING RTL8180_MODULE_NAME ":
> WW:" x "\n", ## a)

Your patches are line-wrapped and can't be applied :(

Care to fix your email client and resend them?

thanks,

greg k-h
