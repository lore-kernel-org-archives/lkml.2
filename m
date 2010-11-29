Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0K2Tq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:46:26 -0500
Received: from kroah.org ([198.145.64.141]:54567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab0K2TqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:46:25 -0500
Date: Mon, 29 Nov 2010 11:43:22 -0800
From: Greg KH <greg@kroah.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] staging: ft1000: Remove unused headers.
Message-ID: <20101129194322.GA14086@kroah.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
 <1290515373-16145-5-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290515373-16145-5-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 01:29:31PM +0100, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> index 8d2c059..3df4b4c 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
> @@ -24,23 +24,14 @@
>  // 6/05/06    Whc                Porting to Linux 2.6.9
>  //
>  //---------------------------------------------------------------------------
> -#include <linux/module.h>
> -#include <linux/kernel.h>
>  #include <linux/sched.h>

Odds are you do want module.h and kernel.h but not sched.h, right?

> -#include <linux/signal.h>
> -#include <linux/errno.h>

You have no error numbers in this driver?  I doubt that.

>  #include <linux/poll.h>
>  #include <linux/netdevice.h>
>  #include <linux/delay.h>
>  #include <linux/miscdevice.h>
> -
> -#include <linux/fs.h>
> -#include <linux/kmod.h>

These can be removed.

>  #include <linux/ioctl.h>
> -#include <linux/unistd.h>

As can this.

thanks,

greg k-h
