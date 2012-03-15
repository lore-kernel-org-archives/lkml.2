Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab2COEbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 00:31:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1792 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2COEbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 00:31:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 14 Mar 2012 21:31:38 -0700
Message-ID: <4F6170A6.5060107@nvidia.com>
Date: Thu, 15 Mar 2012 13:31:34 +0900
From: Jin Park <jinyoungp@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: aat2870: Add MODULE_ALIAS
References: <1331749633-27164-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1331749633-27164-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jin Park <jinyoungp@nvidia.com>

Thanks,
Jinyoung.

On 2012-03-15 오전 3:27, Mark Brown wrote:
> Not that it's ever likely to get used.
>
> Signed-off-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
> ---
>   drivers/regulator/aat2870-regulator.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
> index 9ed5c5d..7cc380e 100644
> --- a/drivers/regulator/aat2870-regulator.c
> +++ b/drivers/regulator/aat2870-regulator.c
> @@ -231,3 +231,4 @@ module_exit(aat2870_regulator_exit);
>   MODULE_DESCRIPTION("AnalogicTech AAT2870 Regulator");
>   MODULE_LICENSE("GPL");
>   MODULE_AUTHOR("Jin Park<jinyoungp@nvidia.com>");
> +MODULE_ALIAS("platform:aat2870-regulator");
