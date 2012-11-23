Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2KWGPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 01:15:21 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47523 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab2KWGPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 01:15:19 -0500
MIME-Version: 1.0
In-Reply-To: <1353650353-17576-1-git-send-email-tushar.behera@linaro.org>
References: <1353650353-17576-1-git-send-email-tushar.behera@linaro.org>
Date: Fri, 23 Nov 2012 11:45:18 +0530
Message-ID: <CAM=Q2cs=oYq4e17LXxUEhATiYLAjnzoTH-+nsO5KNQwGj2qSBA@mail.gmail.com>
Subject: Re: [PATCH 0/7] i2c: s3c2410: Add devm_* apis and cleanup
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, w.sang@pengutronix.de,
        kgene.kim@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 11:29 AM, Tushar Behera
<tushar.behera@linaro.org> wrote:
> This patchset cleans up the probe function of i2c-s3c2410 driver.
> These have been tested on Exynos4210 based Origen board.
>
> Tushar Behera (7):
>   i2c: s3c2410: Remove unnecessary label err_noclk
>   i2c: s3c2410: Convert to use devm_clk_get()
>   i2c: s3c2410: Convert to use devm_request_mem_region()
>   i2c: s3c2410: Convert to use devm_ioremap()
>   i2c: s3c2410: Convert to use devm_request_irq()

You may want to consider request_and_ioremap.


>   i2c: s3c2410: Move location of clk_prepare_enable() call in probe
>     function
>   i2c: s3c2410: Remove err_cpufreq label
>
>  drivers/i2c/busses/i2c-s3c2410.c |   74 ++++++++++++--------------------------
>  1 files changed, 23 insertions(+), 51 deletions(-)
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
