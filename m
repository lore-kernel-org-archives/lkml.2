Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2LMQKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:10:44 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:60428 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab2LMQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:10:43 -0500
MIME-Version: 1.0
In-Reply-To: <1355410348-5129-3-git-send-email-gautam.vivek@samsung.com>
References: <1355410348-5129-1-git-send-email-gautam.vivek@samsung.com>
	<1355410348-5129-3-git-send-email-gautam.vivek@samsung.com>
Date: Thu, 13 Dec 2012 21:40:41 +0530
Message-ID: <CAFp+6iGwEYTLZrC74LVNn+R2wNo68Nvu1RWvNeeCi5LESeCo1w@mail.gmail.com>
Subject: Re: [PATCH 2/2] usb: dwc3-exynos: Fix compatible strings for the device
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, balbi@ti.com, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, jg1.han@samsung.com,
        thomas.abraham@linaro.org, Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: LKML

On Thu, Dec 13, 2012 at 8:22 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Using specific chip in compatible strings. Newer SOCs can claim
> device by using older string in the compatible list.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
> index aae5328..9dce99a 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -188,7 +188,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
>
>  #ifdef CONFIG_OF
>  static const struct of_device_id exynos_dwc3_match[] = {
> -       { .compatible = "samsung,exynos-dwc3" },
> +       { .compatible = "samsung,exynos5250-dwc3" },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_dwc3_match);
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks & Regards
Vivek
