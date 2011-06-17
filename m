Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab1FQPP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:15:26 -0400
Received: from matrix.voodoobox.net ([75.127.97.206]:58442 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab1FQPPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:15:20 -0400
X-Greylist: delayed 3664 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jun 2011 11:15:19 EDT
Subject: Re: [PATCH net-next V2] drivers/net: Remove casts of void *
From: David Dillow <dave@thedillows.org>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 17 Jun 2011 10:14:12 -0400
In-Reply-To: <3bea9d0803a4ebfee2bb0f6e42defbf76126dc86.1308287030.git.joe@perches.com>
References: <3bea9d0803a4ebfee2bb0f6e42defbf76126dc86.1308287030.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308320052.2198.1.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 22:08 -0700, Joe Perches wrote:
> Unnecessary casts of void * clutter the code.
> 
> These are the remainder casts after several specific
> patches to remove netdev_priv and dev_priv.

> diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
> index 3de4283..1d5091a 100644
> --- a/drivers/net/typhoon.c
> +++ b/drivers/net/typhoon.c
> @@ -2367,7 +2367,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	dev->irq = pdev->irq;
>  	tp = netdev_priv(dev);
> -	tp->shared = (struct typhoon_shared *) shared;
> +	tp->shared = shared;
>  	tp->shared_dma = shared_dma;
>  	tp->pdev = pdev;
>  	tp->tx_pdev = pdev;

Acked-by: David Dillow <dave@thedillows.org>

