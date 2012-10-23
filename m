Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2JWGQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:16:51 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64553 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2JWGQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <000f01cdb047$0f033f10$2d09bd30$%choi@samsung.com>
References: <000f01cdb047$0f033f10$2d09bd30$%choi@samsung.com>
Date: Tue, 23 Oct 2012 11:46:49 +0530
Message-ID: <CAK44p227GpAkFDYXwXUTt19H-YiA74OvYofjpyr_7nKj+HhPMw@mail.gmail.com>
Subject: Re: [PATCH] thermal: exynos: Fix wrong name of MODULE_DEVICE_TABLE
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>,
        "Brown, Len" <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, Sachin Kamat <sachin.kamat@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2012 16:49, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> exynos4_tmu_driver_ids should be exynos_tmu_driver_ids.
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/thermal/exynos_thermal.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index fd03e85..6dd29e4 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -815,7 +815,7 @@ static struct platform_device_id exynos_tmu_driver_ids[]
> = {
>         },
>         { },
>  };
> -MODULE_DEVICE_TABLE(platform, exynos4_tmu_driver_ids);
> +MODULE_DEVICE_TABLE(platform, exynos_tmu_driver_ids);

Your changes looks fine. Adding the thermal maintainers.

Reviewed-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>

Thanks,
Amit Daniel
>
>  static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
>                         struct platform_device *pdev)
> --
> 1.7.1
>
