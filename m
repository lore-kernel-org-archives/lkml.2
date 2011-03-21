Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1CUQiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:38:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38343 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1CUQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:38:18 -0400
Date: Mon, 21 Mar 2011 16:37:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jesper Juhl <jj@chaosbits.net>, Deepak Saxena <dsaxena@plexity.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Remove bouncing author email from
	arch/arm/plat-iop/time.c
Message-ID: <20110321163759.GE4340@n2100.arm.linux.org.uk>
References: <alpine.LNX.2.00.1103150236500.26293@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103150236500.26293@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deepak, are you happy with this?

On Tue, Mar 15, 2011 at 02:39:19AM +0100, Jesper Juhl wrote:
> Mr. Deepak Saxena's email address, listed at the head of 
> arch/arm/plat-iop/time.c, bounces. Remove it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  time.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
> index 07f23bb..af6139d 100644
> --- a/arch/arm/plat-iop/time.c
> +++ b/arch/arm/plat-iop/time.c
> @@ -3,7 +3,7 @@
>   *
>   * Timer code for IOP32x and IOP33x based systems
>   *
> - * Author: Deepak Saxena <dsaxena@mvista.com>
> + * Author: Deepak Saxena
>   *
>   * Copyright 2002-2003 MontaVista Software Inc.
>   *
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
