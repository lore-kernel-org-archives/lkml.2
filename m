Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab2ENQPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:15:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16364 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab2ENQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:15:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 14 May 2012 09:15:36 -0700
Message-ID: <4FB12EA3.504@nvidia.com>
Date: Mon, 14 May 2012 21:41:15 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: tps62360: Fix build error due to missing semicolon
References: <1337011088.6054.0.camel@phoenix>
In-Reply-To: <1337011088.6054.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2012 09:28 PM, Axel Lin wrote:
> Fix below build error:
>    CC [M]  drivers/regulator/tps62360-regulator.o
> drivers/regulator/tps62360-regulator.c:351:1: error: expected ',' or ';' before 'extern'
> make[2]: *** [drivers/regulator/tps62360-regulator.o] Error 1
> make[1]: *** [drivers/regulator] Error 2
> make: *** [drivers] Error 2
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/regulator/tps62360-regulator.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
> index 60765cc..82cd763 100644
> --- a/drivers/regulator/tps62360-regulator.c
> +++ b/drivers/regulator/tps62360-regulator.c
> @@ -347,7 +347,7 @@ static const struct of_device_id tps62360_of_match[] = {
>   	 { .compatible = "ti,tps62362", .data = (void *)TPS62362},
>   	 { .compatible = "ti,tps62363", .data = (void *)TPS62363},
>   	{},
> -}
> +};
>   MODULE_DEVICE_TABLE(of, tps62360_of_match);
>   #endif
>
Really strange!! I am not getting this compilation error in my build.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

