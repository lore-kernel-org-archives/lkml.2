Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1HCJCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:02:31 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:49554 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab1HCJCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:02:24 -0400
Date: Wed, 3 Aug 2011 11:02:23 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/usb: Use kzalloc
Message-ID: <20110803090223.GM4587@distanz.ch>
References: <1312301372.2629.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312301372.2629.10.camel@localhost.localdomain>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please add a Signed-off-by line as mentioned in
Documentation/SubmittingPatches.

Also you should Cc: the proper maintainer and list (in this case
netdev). You can use scripts/get_maintainers.pl to get this information

Cheers
Tobias

On 2011-08-02 at 18:09:28 +0200, Thomas Meyer <thomas@m3y3r.de> wrote:
> --- a/drivers/net/usb/cdc_ncm.c 2011-07-26 00:46:08.126846923 +0200
> +++ b/drivers/net/usb/cdc_ncm.c 2011-08-01 20:20:43.396390040 +0200
> @@ -479,12 +479,10 @@ static int cdc_ncm_bind(struct usbnet *d
>  	int temp;
>  	u8 iface_no;
>  
> -	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>  	if (ctx == NULL)
>  		return -ENODEV;
>  
> -	memset(ctx, 0, sizeof(*ctx));
> -
>  	init_timer(&ctx->tx_timer);
>  	spin_lock_init(&ctx->mtx);
>  	ctx->netdev = dev->net;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
