Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2IMEtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:49:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62600 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2IMEtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:49:40 -0400
Date: Wed, 12 Sep 2012 21:49:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: gpio_keys_polled: fix dt pdata->nbuttons
Message-ID: <20120913044935.GA17105@core.coreip.homeip.net>
References: <1347485243-21173-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347485243-21173-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 06:27:23PM -0300, Alexandre Pereira da Silva wrote:
> pdata->nbuttons should be updated by the dt code.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Applied, thank you Alexandre.
 
> ---
>  drivers/input/keyboard/gpio_keys_polled.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
> index 7908952..f2142de 100644
> --- a/drivers/input/keyboard/gpio_keys_polled.c
> +++ b/drivers/input/keyboard/gpio_keys_polled.c
> @@ -129,6 +129,7 @@ gpio_keys_polled_get_devtree_pdata(struct device *dev)
>  	}
>  
>  	pdata->buttons = (struct gpio_keys_button *)(pdata + 1);
> +	pdata->nbuttons = nbuttons;
>  
>  	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
>  	of_property_read_u32(node, "poll-interval", &pdata->poll_interval);
> -- 
> 1.7.10
> 

-- 
Dmitry
