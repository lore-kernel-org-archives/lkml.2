Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1BNXNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:13:37 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12588 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1BNXNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:13:34 -0500
Date: Tue, 15 Feb 2011 00:12:31 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] mISDN: fix printk typo fushing
In-Reply-To: <1297724762.1793.35.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1102150012140.4530@swampdragon.chaosbits.net>
References: <1297724762.1793.35.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  drivers/isdn/mISDN/hwchannel.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/isdn/mISDN/hwchannel.c b/drivers/isdn/mISDN/hwchannel.c
> index 199f374..f6e108d 100644
> --- a/drivers/isdn/mISDN/hwchannel.c
> +++ b/drivers/isdn/mISDN/hwchannel.c
> @@ -206,7 +206,7 @@ recv_Bchannel(struct bchannel *bch, unsigned int id)
>  	hh->id = id;
>  	if (bch->rcount >= 64) {
>  		printk(KERN_WARNING "B-channel %p receive queue overflow, "
> -			"fushing!\n", bch);
> +			"flushing!\n", bch);
>  		skb_queue_purge(&bch->rqueue);
>  		bch->rcount = 0;
>  		return;
> @@ -231,7 +231,7 @@ recv_Bchannel_skb(struct bchannel *bch, struct sk_buff *skb)
>  {
>  	if (bch->rcount >= 64) {
>  		printk(KERN_WARNING "B-channel %p receive queue overflow, "
> -			"fushing!\n", bch);
> +			"flushing!\n", bch);
>  		skb_queue_purge(&bch->rqueue);
>  		bch->rcount = 0;
>  	}
> @@ -279,7 +279,7 @@ confirm_Bsend(struct bchannel *bch)
>  
>  	if (bch->rcount >= 64) {
>  		printk(KERN_WARNING "B-channel %p receive queue overflow, "
> -			"fushing!\n", bch);
> +			"flushing!\n", bch);
>  		skb_queue_purge(&bch->rqueue);
>  		bch->rcount = 0;
>  	}
> 

Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

