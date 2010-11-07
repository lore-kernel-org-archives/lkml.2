Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0KGSll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:41:41 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20549 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0KGSlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:41:40 -0500
Date: Sun, 7 Nov 2010 19:30:22 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Greg Kroah-Hartman <gregkh@suse.de>, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: r8712u: Remove extraneous variables from
 osdep_service.h
In-Reply-To: <4cd6ee5a.zGhzRELurpN2EqEs%Larry.Finger@lwfinger.net>
Message-ID: <alpine.LNX.2.00.1011071922580.26247@swampdragon.chaosbits.net>
References: <4cd6ee5a.zGhzRELurpN2EqEs%Larry.Finger@lwfinger.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Larry Finger wrote:

> 
> Jesper Juhl submitted a patch to remove one extraneous variable in
> this file; however, there are several others.
> 

I was reviewing memory allocater functions all over the kernel, not 
looking for unneeded variables as such, so I didn't check the entire file.

I've read through your patch and it looks good to me.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/staging/rtl8712/osdep_service.h |   20 ++++----------------
>  1 files changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
> index f891a1b..7d62714 100644
> --- a/drivers/staging/rtl8712/osdep_service.h
> +++ b/drivers/staging/rtl8712/osdep_service.h
> @@ -218,34 +218,22 @@ static inline void flush_signals_thread(void)
>  
>  static inline u32 _RND8(u32 sz)
>  {
> -	u32	val;
> -
> -	val = ((sz >> 3) + ((sz & 7) ? 1 : 0)) << 3;
> -	return val;
> +	return ((sz >> 3) + ((sz & 7) ? 1 : 0)) << 3;
>  }
>  
>  static inline u32 _RND128(u32 sz)
>  {
> -	u32	val;
> -
> -	val = ((sz >> 7) + ((sz & 127) ? 1 : 0)) << 7;
> -	return val;
> +	return ((sz >> 7) + ((sz & 127) ? 1 : 0)) << 7;
>  }
>  
>  static inline u32 _RND256(u32 sz)
>  {
> -	u32	val;
> -
> -	val = ((sz >> 8) + ((sz & 255) ? 1 : 0)) << 8;
> -	return val;
> +	return ((sz >> 8) + ((sz & 255) ? 1 : 0)) << 8;
>  }
>  
>  static inline u32 _RND512(u32 sz)
>  {
> -	u32	val;
> -
> -	val = ((sz >> 9) + ((sz & 511) ? 1 : 0)) << 9;
> -	return val;
> +	return ((sz >> 9) + ((sz & 511) ? 1 : 0)) << 9;
>  }
>  
>  #define STRUCT_PACKED __attribute__ ((packed))
> 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

