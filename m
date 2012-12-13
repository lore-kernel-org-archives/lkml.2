Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2LMQJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:09:42 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:48781 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab2LMQJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:09:41 -0500
MIME-Version: 1.0
In-Reply-To: <1355410348-5129-2-git-send-email-gautam.vivek@samsung.com>
References: <1355410348-5129-1-git-send-email-gautam.vivek@samsung.com>
	<1355410348-5129-2-git-send-email-gautam.vivek@samsung.com>
Date: Thu, 13 Dec 2012 21:39:39 +0530
Message-ID: <CAFp+6iEUrP5by8+HHFBMYJcu1v9QB1=RGp675e-VfOoYR9dRjQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb: ehci-s5p/ohci-exynos: Fix compatible strings for
 the device
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

On Thu, Dec 13, 2012 at 8:22 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Using specific chip in compatible strings. Newer SOCs can claim
> device by using older string in the compatible list.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/host/ehci-s5p.c    |    2 +-
>  drivers/usb/host/ohci-exynos.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 319dcfa..f18e6ac 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -266,7 +266,7 @@ static const struct dev_pm_ops s5p_ehci_pm_ops = {
>
>  #ifdef CONFIG_OF
>  static const struct of_device_id exynos_ehci_match[] = {
> -       { .compatible = "samsung,exynos-ehci" },
> +       { .compatible = "samsung,exynos4210-ehci" },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_ehci_match);
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index aa3b884..77f2017 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -267,7 +267,7 @@ static const struct dev_pm_ops exynos_ohci_pm_ops = {
>
>  #ifdef CONFIG_OF
>  static const struct of_device_id exynos_ohci_match[] = {
> -       { .compatible = "samsung,exynos-ohci" },
> +       { .compatible = "samsung,exynos4210-ohci" },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_ohci_match);
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
