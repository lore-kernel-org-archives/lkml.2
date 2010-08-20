Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab0HTUrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:47:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38408 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab0HTUrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:47:00 -0400
Date: Fri, 20 Aug 2010 14:46:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: Fix missing includes - ll_temac
Message-ID: <20100820204657.GB13910@angua.secretlab.ca>
References: <1282200178-1145-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282200178-1145-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 08:42:58AM +0200, Michal Simek wrote:
> It is the next patch which is fixing missing header
> which were removed from prom.h.
> 
> Related patches:
> "of/address: Clean up function declarations" (sha1 id 22ae782f8)
> "of: Fix missing includes" (sha1 id f1ca09b2b)
> 

Applied.

> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  drivers/net/ll_temac_main.c |    1 +
>  drivers/net/ll_temac_mdio.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
> index c7b6247..a9d216d 100644
> --- a/drivers/net/ll_temac_main.c
> +++ b/drivers/net/ll_temac_main.c
> @@ -38,6 +38,7 @@
>  #include <linux/of_device.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_platform.h>
> +#include <linux/of_address.h>
>  #include <linux/skbuff.h>
>  #include <linux/spinlock.h>
>  #include <linux/tcp.h>      /* needed for sizeof(tcphdr) */
> diff --git a/drivers/net/ll_temac_mdio.c b/drivers/net/ll_temac_mdio.c
> index 5ae28c9..8cf9d4f 100644
> --- a/drivers/net/ll_temac_mdio.c
> +++ b/drivers/net/ll_temac_mdio.c
> @@ -10,6 +10,7 @@
>  #include <linux/phy.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/of_address.h>
>  #include <linux/slab.h>
>  #include <linux/of_mdio.h>
>  
> -- 
> 1.5.5.6
> 
