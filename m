Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3AFVb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 16:31:29 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51842 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3AFVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 16:31:26 -0500
Date: Sun, 6 Jan 2013 13:27:54 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>, trivial@kernel.org
Subject: Re: [PATCH] bq2415x_charger: Remove unneeded version.h include
Message-ID: <20130106212753.GC26928@lizard.sbx05280.losalca.wayport.net>
References: <alpine.LNX.2.00.1212182305220.14788@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1212182305220.14788@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:07:06PM +0100, Jesper Juhl wrote:
> The file uses nothing from the header, so including it is pointless.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Sachin Kamat sent a similar cleanup in Nov, so he wins. :)

> ---
>  drivers/power/bq2415x_charger.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
> index ee842b3..2d1b568 100644
> --- a/drivers/power/bq2415x_charger.c
> +++ b/drivers/power/bq2415x_charger.c
> @@ -28,7 +28,6 @@
>   * http://www.ti.com/product/bq24155
>   */
>  
> -#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/param.h>
> -- 
> 1.7.1
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
