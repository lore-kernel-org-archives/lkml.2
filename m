Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2CVJQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:16:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6228 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2CVJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:16:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 22 Mar 2012 02:16:05 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 22 Mar 2012 14:46:02 +0530
Subject: RE: [PATCH] mfd: Remove unused mutex from struct tps65090
Thread-Topic: [PATCH] mfd: Remove unused mutex from struct tps65090
Thread-Index: Ac0IDDNNgmjzsPfTQn2w6P5hgcS8BQAABpwg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3127FFC@BGMAIL02.nvidia.com>
References: <1332407659.3870.1.camel@phoenix>
In-Reply-To: <1332407659.3870.1.camel@phoenix>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2M9GI0M019008

Looks good to me.
Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@gmail.com]
> Sent: Thursday, March 22, 2012 2:44 PM
> To: linux-kernel@vger.kernel.org
> Cc: Venu Byravarasu; Samuel Ortiz
> Subject: [PATCH] mfd: Remove unused mutex from struct tps65090
> 
> The mutex lock is not used after converting to use regmap, remove it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/tps65090.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
> index a66d4df..9a84bda 100644
> --- a/drivers/mfd/tps65090.c
> +++ b/drivers/mfd/tps65090.c
> @@ -79,7 +79,6 @@ static struct mfd_cell tps65090s[] = {
>  };
> 
>  struct tps65090 {
> -	struct mutex		lock;
>  	struct device		*dev;
>  	struct i2c_client	*client;
>  	struct regmap		*rmap;
> @@ -283,8 +282,6 @@ static int __devinit tps65090_i2c_probe(struct
> i2c_client *client,
>  	tps65090->dev = &client->dev;
>  	i2c_set_clientdata(client, tps65090);
> 
> -	mutex_init(&tps65090->lock);
> -
>  	if (client->irq) {
>  		ret = tps65090_irq_init(tps65090, client->irq, pdata-
> >irq_base);
>  		if (ret) {
> --
> 1.7.5.4
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
