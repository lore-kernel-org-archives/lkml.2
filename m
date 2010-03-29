Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0C2EeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 00:34:10 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47927 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751398Ab0C2EeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 00:34:08 -0400
Date: Mon, 29 Mar 2010 06:33:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wblinux_f.h Coding style fixes v2.
Message-ID: <20100329043357.GE22696@elf.ucw.cz>
References: <1269806413-15784-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269806413-15784-1-git-send-email-lindley@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-03-28 22:00:13, Lars Lindley wrote:
> I fixed whitespace and comments.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

> ---
>  drivers/staging/winbond/wblinux_f.h |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wblinux_f.h b/drivers/staging/winbond/wblinux_f.h
> index 868e877..0a9d214 100644
> --- a/drivers/staging/winbond/wblinux_f.h
> +++ b/drivers/staging/winbond/wblinux_f.h
> @@ -4,13 +4,14 @@
>  #include "core.h"
>  #include "mds_s.h"
>  
> -//=========================================================================
> -// Copyright (c) 1996-2004 Winbond Electronic Corporation
> -//
> -// wblinux_f.h
> -//
> -int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev );
> -void wb35_set_multicast( struct net_device *netdev );
> -struct net_device_stats * wb35_netdev_stats( struct net_device *netdev );
> -
> +/*
> + * ====================================================================
> + * Copyright (c) 1996-2004 Winbond Electronic Corporation
> + *
> + * wblinux_f.h
> + * ====================================================================
> + */
> +int wb35_start_xmit(struct sk_buff *skb, struct net_device *netdev);
> +void wb35_set_multicast(struct net_device *netdev);
> +struct net_device_stats *wb35_netdev_stats(struct net_device *netdev);
>  #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
