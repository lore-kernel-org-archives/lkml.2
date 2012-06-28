Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2F1TK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:10:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54232 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab2F1TK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:10:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6756"; a="203300392"
Message-ID: <4FECAC3C.2010202@codeaurora.org>
Date: Thu, 28 Jun 2012 12:10:52 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3] Exynos : Add support for Exynos random number generator
References: <1340851345-27107-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1340851345-27107-1-git-send-email-jonghwa3.lee@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/12 19:42, Jonghwa Lee wrote:
> This patch supports Exynos SOC's PRNG driver. Exynos's PRNG has 5 seeds and
> 5 random number outputs. Module is excuted under runtime power management control,
> so it activates only while it's in use. Otherwise it will be suspended generally.
> It was tested on PQ board by rngtest program.
>
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

I'll leave the signoff chain discrepancy to whoever applies this patch.

> +
> +#include <linux/hw_random.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>

Is delay.h used?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

