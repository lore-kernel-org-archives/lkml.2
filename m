Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0C2Ee3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 00:34:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47971 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751398Ab0C2Ee1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 00:34:27 -0400
Date: Mon, 29 Mar 2010 06:34:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wbusb_s.h Coding style fixes.
Message-ID: <20100329043418.GF22696@elf.ucw.cz>
References: <1269806732-15864-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269806732-15864-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-03-28 22:05:32, Lars Lindley wrote:
> I fixed comments and some spacing.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

> ---
>  drivers/staging/winbond/wbusb_s.h |   23 ++++++++---------------
>  1 files changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wbusb_s.h b/drivers/staging/winbond/wbusb_s.h
> index 0c7e6a3..8961ae5 100644
> --- a/drivers/staging/winbond/wbusb_s.h
> +++ b/drivers/staging/winbond/wbusb_s.h
> @@ -1,16 +1,10 @@
> -//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> -// Copyright (c) 1996-2004 Winbond Electronic Corporation
> -//
> -//  Module Name:
> -//    wbusb_s.h
> -//
> -//  Abstract:
> -//    Linux driver.
> -//
> -//  Author:
> -//
> -//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> -
> +/* =========================================================
> + * Copyright (c) 1996-2004 Winbond Electronic Corporation
> + *
> + *  Module Name:
> + *    wbusb_s.h
> + * =========================================================
> + */
>  #ifndef __WINBOND_WBUSB_S_H
>  #define __WINBOND_WBUSB_S_H
>  
> @@ -18,8 +12,7 @@
>  
>  struct wb_usb {
>  	u32	IsUsb20;
> -	struct usb_device *udev;
> +	struct	usb_device *udev;
>  	u32	DetectCount;
>  };
> -
>  #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
