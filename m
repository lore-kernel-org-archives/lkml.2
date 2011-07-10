Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab1GJXj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:39:58 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20513 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab1GJXjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:39:54 -0400
Date: Mon, 11 Jul 2011 01:39:53 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Edwin van Vliet <edwin@cheatah.nl>
cc: starvik@axis.com, jesper.nilsson@axis.com, alan@linux.intel.com,
        linux-cris-kernel@axis.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/tty/serial/crisv10: fix double assignment
In-Reply-To: <1310341051-27057-1-git-send-email-edwin@cheatah.nl>
Message-ID: <alpine.LNX.2.00.1107110139070.2818@swampdragon.chaosbits.net>
References: <1310341051-27057-1-git-send-email-edwin@cheatah.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Edwin van Vliet wrote:

> Struct member dma_in_enabled was assigned twice in a row.
> 
> Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
> ---
>  drivers/tty/serial/crisv10.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
> index 225123b..0c55181 100644
> --- a/drivers/tty/serial/crisv10.c
> +++ b/drivers/tty/serial/crisv10.c
> @@ -330,7 +330,6 @@ static struct e100_serial rs_table[] = {
>  	  .dma_in_irq_description = "serial 1 dma rec",
>  #else
>  	  .dma_in_enabled = 0,
> -	  .dma_in_enabled = 0,
>  	  .dma_in_nbr = UINT_MAX,
>  	  .dma_in_irq_nbr = 0,
>  	  .dma_in_irq_flags = 0,
> 
Looks correct to me.
Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

