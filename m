Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab2GKAGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:06:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55107 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755454Ab2GKAGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:06:52 -0400
Message-ID: <1341953917.6118.165.camel@joe2Laptop>
Subject: Re: [PATCH 1/3] panel: Use pr_debug(...) rather than
 printk(KERN_DEBUG ...)
From: Joe Perches <joe@perches.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: greg@kroah.com, willy@meta-x.org, linux-kernel@vger.kernel.org
In-Reply-To: <1341919338-8800-1-git-send-email-yamanetoshi@gmail.com>
References: <1341919338-8800-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jul 2012 13:58:37 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 20:22 +0900, Toshiaki Yamane wrote:
> This change is inspired by checkpatch.
[]
> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
[]
> @@ -1838,9 +1838,8 @@ static void panel_process_inputs(void)
>  	struct logical_input *input;
>  
>  #if 0
> -	printk(KERN_DEBUG
> -	       "entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
> -	       phys_prev, phys_curr);
> +	pr_debug("entering panel_process_inputs with pp=%016Lx & pc=%016Lx\n",
> +		 phys_prev, phys_curr);
>  #endif

Might as well delete these #if 0 blocks instead

>  
>  	keypressed = 0;
> @@ -2003,8 +2002,8 @@ static struct logical_input *panel_bind_key(char *name, char *press,
>  	key->fall_time = 1;
>  
>  #if 0
> -	printk(KERN_DEBUG "bind: <%s> : m=%016Lx v=%016Lx\n", name, key->mask,
> -	       key->value);
> +	pr_debug("bind: <%s> : m=%016Lx v=%016Lx\n", name, key->mask,
> +		 key->value);
>  #endif
>  	strncpy(key->u.kbd.press_str, press, sizeof(key->u.kbd.press_str));
>  	strncpy(key->u.kbd.repeat_str, repeat, sizeof(key->u.kbd.repeat_str));




