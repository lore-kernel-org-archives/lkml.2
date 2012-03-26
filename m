Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2CZDvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 23:51:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13448 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2CZDvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 23:51:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 25 Mar 2012 20:51:37 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Mar 2012 09:21:33 +0530
Subject: RE: [PATCH 1/2] mfd: tps65090: Fix ifdefs for suspend mode
Thread-Topic: [PATCH 1/2] mfd: tps65090: Fix ifdefs for suspend mode
Thread-Index: Ac0IWxPp47b4NkbvTLW1KNYlLaKtOwCp8K6A
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD312816E@BGMAIL02.nvidia.com>
References: <1332441541-28197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1332441541-28197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> CONFIG_PM also covers runtime only PM.
Hi Mark,
As CONFIG_PM covers both runtime and full system suspend/resume
activities, I do not really understand what we gain with this change.

Can you please provide more details?
Thanks,
Venu
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/tps65090.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
> index a66d4df..ac7e8b1 100644
> --- a/drivers/mfd/tps65090.c
> +++ b/drivers/mfd/tps65090.c
> @@ -334,7 +334,7 @@ static int __devexit tps65090_i2c_remove(struct
> i2c_client *client)
>  	return 0;
>  }
> 
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
