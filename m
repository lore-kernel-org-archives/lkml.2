Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965227Ab0COPVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:21:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965207Ab0COPVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:21:53 -0400
Date: Mon, 15 Mar 2010 17:21:16 +0200
From: Shahar Havivi <shaharh@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt.c remove unused variables
Message-ID: <20100315152115.GA29368@redhat.com>
References: <20100306092856.GA4108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100306092856.GA4108@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 11:28:59AM +0200, Shahar Havivi wrote:
> Date: Sat, 6 Mar 2010 11:28:59 +0200
> From: Shahar Havivi <shaharh@redhat.com>
> To: linux-kernel@vger.kernel.org
> Subject: [PATCH] vt.c remove unused variables
Ignore this patch, already merged
> 
> console write declare orig_buf and orig_count but never use them.
> 
> Signed-off-by: Shahar Havivi <shaharh@redhat.com>
> ---
>  drivers/char/vt.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index 50faa1f..94f530a 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -2119,8 +2119,6 @@ static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int co
>  	uint8_t inverse;
>  	uint8_t width;
>  	u16 himask, charmask;
> -	const unsigned char *orig_buf = NULL;
> -	int orig_count;
>  
>  	if (in_interrupt())
>  		return count;
> @@ -2142,8 +2140,6 @@ static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int co
>  	    release_console_sem();
>  	    return 0;
>  	}
> -	orig_buf = buf;
> -	orig_count = count;
>  
>  	himask = vc->vc_hi_font_mask;
>  	charmask = himask ? 0x1ff : 0xff;
> -- 
> 1.6.3.3
> 
