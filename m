Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0F3ACy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:02:54 -0400
Received: from koto.vergenet.net ([210.128.90.7]:41324 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab0F3ACw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:02:52 -0400
Date: Wed, 30 Jun 2010 09:02:50 +0900
From: Simon Horman <horms@verge.net.au>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Nobhiro KUSUNO <n-kusuno@fc4.so-net.ne.jp>,
       Sebastian =?utf-8?Q?Dalfu=C3=9F?= <sd@sedf.de>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/25] usb_main_dev: remove casts from void*
Message-ID: <20100630000250.GC2138@verge.net.au>
References: <1277806573-31384-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277806573-31384-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 02:16:12PM +0400, Kulikov Vasiliy wrote:
> Remove unnesessary casts from void*.

No objections here.

FWIW, Reviewed-by: Simon Horman <horms@verge.net.au>

> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/rt2860/usb_main_dev.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
> index b740662..40eab25 100644
> --- a/drivers/staging/rt2860/usb_main_dev.c
> +++ b/drivers/staging/rt2860/usb_main_dev.c
> @@ -421,8 +421,8 @@ int MlmeThread(IN void *Context)
>  	int status;
>  	status = 0;
>  
> -	pTask = (struct rt_rtmp_os_task *)Context;
> -	pAd = (struct rt_rtmp_adapter *)pTask->priv;
> +	pTask = Context;
> +	pAd = pTask->priv;
>  
>  	RtmpOSTaskCustomize(pTask);
>  
> @@ -490,8 +490,8 @@ int RTUSBCmdThread(IN void *Context)
>  	int status;
>  	status = 0;
>  
> -	pTask = (struct rt_rtmp_os_task *)Context;
> -	pAd = (struct rt_rtmp_adapter *)pTask->priv;
> +	pTask = Context;
> +	pAd = pTask->priv;
>  
>  	RtmpOSTaskCustomize(pTask);
>  
> -- 
> 1.7.0.4
