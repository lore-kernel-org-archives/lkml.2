Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab2BXPpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:45:40 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43869 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567Ab2BXPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:45:38 -0500
X-Sasl-enc: AIUbR43F1FpepIxas6HBe3Zk8SRnKzVIgjYJnsCnPYDD 1330098337
Date: Fri, 24 Feb 2012 07:40:46 -0800
From: Greg KH <greg@kroah.com>
To: meng zhang <meng.zhang@mediatek.com>
Cc: smurf@smurf.noris.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces
Message-ID: <20120224154046.GB16535@kroah.com>
References: <CACwCHpxjhEenzv+H3zK2cNKAA9KyuK=DPythY2UgHTmY_AhqaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACwCHpxjhEenzv+H3zK2cNKAA9KyuK=DPythY2UgHTmY_AhqaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 02:41:04PM +0800, meng zhang wrote:
> from: Meng Zhang <meng.zhang@mediatek.com>
> 
> 1. This patch is based on kernel 3.0.0

That is quite old, please make it against Linus's latest git tree if
possible, and if not, against 3.3-rc4.  And if not that, how about 3.3?

> 2. To declare the product IDs in option.c
> 
> Signed-off-by: Meng Zhang <meng.zhang@mediatek.com>
> ---------------------------------------------------------------------------------------
> 
> --- option.c	2012-02-23 10:42:40.635138657 +0800
> +++ option.c.orig	2011-10-07 22:50:04.000000000 +0800

Hm, I think you didn't read Documentation/SubmittingPatches for the
correct patch level to send things.  Please fix this as our automated
tools can not handle this patch

> @@ -416,9 +416,6 @@ static void option_instat_callback(struc
>  #define SAMSUNG_VENDOR_ID                       0x04e8
>  #define SAMSUNG_PRODUCT_GT_B3730                0x6889
> 
> -/* MediaTek products */
> -#define MEDIATEK_VENDOR_ID				0x0e8d
> -
>  /* some devices interfaces need special handling due to a number of reasons */
>  enum option_blacklist_reason {
>  		OPTION_BLACKLIST_NONE = 0,
> @@ -1008,10 +1005,6 @@ static const struct usb_device_id option
>  	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650
> CDMA 450 1xEVDO modem */

Your patch is also linewrapped, making it impossible to apply :(

Care to try this again after fixing it?

greg k-h
