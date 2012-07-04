Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab2GDHQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:16:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6548 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab2GDHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:16:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 04 Jul 2012 00:16:40 -0700
Message-ID: <4FF3ECD5.2010705@nvidia.com>
Date: Wed, 4 Jul 2012 12:42:21 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps65910: Set enable enable_time in regulator_desc
References: <1341367157.10587.1.camel@phoenix>
In-Reply-To: <1341367157.10587.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2012 07:29 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/regulator/tps65910-regulator.c |   12 +-----------
>   1 file changed, 1 insertion(+), 11 deletions(-)
>
> diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
> index 66da87c..a534e087 100644
> --- a/drivers/regulator/tps65910-regulator.c
> +++ b/drivers/regulator/tps65910-regulator.c
> @@ -412,13 +412,6 @@ static int tps65911_get_ctrl_register(int id)
>   	}
>   }

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

Looks good to me.

