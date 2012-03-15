Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161160Ab2CORGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:06:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38956 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031926Ab2CORGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:06:17 -0400
Date: Thu, 15 Mar 2012 21:06:12 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Daniel Jeong <daniel.jeong@ti.com>
Subject: Re: [PATCH] power_supply: Add MODULE_DEVICE_TABLE for lp8727 charger
Message-ID: <20120315170612.GC11441@oksana.dev.rtsoft.ru>
References: <1326372302.5729.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1326372302.5729.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 08:45:02PM +0800, Axel Lin wrote:
> Add MODULE_DEVICE_TABLE to setup modalias for lp8727.
> The i2c_device_id table is supposed to be zero-terminated.
> Thus add a missing terminate entry for lp8727_ids.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/power/lp8727_charger.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
> index b15b575..8e901c9 100644
> --- a/drivers/power/lp8727_charger.c
> +++ b/drivers/power/lp8727_charger.c
> @@ -464,7 +464,9 @@ static int __devexit lp8727_remove(struct i2c_client *cl)
>  
>  static const struct i2c_device_id lp8727_ids[] = {
>  	{"lp8727", 0},
> +	{ },
>  };
> +MODULE_DEVICE_TABLE(i2c, lp8727_ids);

Applied, thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
