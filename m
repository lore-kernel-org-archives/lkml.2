Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786Ab2EQNSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:18:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759908Ab2EQNSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:18:17 -0400
Date: Thu, 17 May 2012 15:18:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Oskar Schirmer <oskar@scara.com>
Cc: linux-kernel@vger.kernel.org, hannes@cmpxchg.org, shess@hessware.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] net: Change mail address of Oskar Schirmer
In-Reply-To: <1337161280-28953-4-git-send-email-oskar@scara.com>
Message-ID: <alpine.LNX.2.00.1205171518010.8796@pobox.suse.cz>
References: <1337161280-28953-1-git-send-email-oskar@scara.com> <1337161280-28953-4-git-send-email-oskar@scara.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Oskar Schirmer wrote:

> That old mail address doesnt exist any more.
> This changes all occurences to my new address.
> 
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/s6gmac.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/s6gmac.c b/drivers/net/ethernet/s6gmac.c
> index 1895605..6f0d284 100644
> --- a/drivers/net/ethernet/s6gmac.c
> +++ b/drivers/net/ethernet/s6gmac.c
> @@ -1,7 +1,7 @@
>  /*
>   * Ethernet driver for S6105 on chip network device
>   * (c)2008 emlix GmbH http://www.emlix.com
> - * Authors:	Oskar Schirmer <os@emlix.com>
> + * Authors:	Oskar Schirmer <oskar@scara.com>
>   *		Daniel Gloeckner <dg@emlix.com>
>   *
>   * This program is free software; you can redistribute it and/or
> @@ -1070,4 +1070,4 @@ module_exit(s6gmac_exit);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("S6105 on chip Ethernet driver");
> -MODULE_AUTHOR("Oskar Schirmer <os@emlix.com>");
> +MODULE_AUTHOR("Oskar Schirmer <oskar@scara.com>");

I am applying this to trivial.git.

-- 
Jiri Kosina
SUSE Labs
