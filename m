Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab2HHUW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:22:26 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:16387 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab2HHUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:22:25 -0400
Date: Wed, 8 Aug 2012 22:22:23 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Marek Belisko <marek.belisko@open-nandra.com>
cc: gregkh@linuxfoundation.org, andrzej.p@samsung.com, lockwood@android.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:ccg: Fix missing brackets for sizeof (found by
 sparse).
In-Reply-To: <1344456878-968-1-git-send-email-marek.belisko@open-nandra.com>
Message-ID: <alpine.LNX.2.00.1208082221270.10061@swampdragon.chaosbits.net>
References: <1344456878-968-1-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Marek Belisko wrote:

> Fix following:
> WARNING: sizeof fsg should be sizeof(fsg)
> +	memset(&fsg, 0, sizeof fsg);
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  drivers/staging/ccg/ccg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/ccg/ccg.c b/drivers/staging/ccg/ccg.c
> index 6a7aab8..81ac6bb 100644
> --- a/drivers/staging/ccg/ccg.c
> +++ b/drivers/staging/ccg/ccg.c
> @@ -728,7 +728,7 @@ static int mass_storage_function_init(struct ccg_usb_function *f,
>  	struct fsg_common *common;
>  	int err;
>  
> -	memset(&fsg, 0, sizeof fsg);
> +	memset(&fsg, 0, sizeof(fsg));
>  	fsg.nluns = 1;
>  	fsg.luns[0].removable = 1;
>  	fsg.vendor_name = iManufacturer;
> 
Looks good to me.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

